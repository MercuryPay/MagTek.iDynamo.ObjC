//
//  MercurySOAPHelper.m
//  CallMercuryWebService
//
//  Created by Kevin Oliver on 5/16/13.
//  Copyright (c) 2013 Kevin Oliver. All rights reserved.
//

#import "MercuryHelper.h"

@implementation MercuryHelper

// Change this URL when runing transactions against production web service
static NSString *const MERCURY_WEB_SERVICE_URL = @"https://w1.mercurydev.net/ws/ws.asmx";

static int          _numberOfPasses = 0;
NSMutableData       *_conWebData;
NSMutableString     *_soapResults;
NSString            *_TransactionResult;
NSMutableDictionary *_dict;
NSString            *_currentElement;
NSXMLParser         *_xmlParser;
static BOOL         _recordResults = NO;
NSMutableString     *_transactionType;
NSString            *_noCaps;

-(void) transctionFromDictionary:(NSDictionary *)dictionary andPassword:(NSString *)password {
    
    _transactionType =[NSMutableString stringWithString:@"CreditTransaction"];
    
    if ([dictionary valueForKey:@"TranType"])
    {
        NSString *noCaps = [[dictionary valueForKey:@"TranType"] lowercaseString];
        
        if ([noCaps isEqualToString:@"prepaid"]) {
            _transactionType =[NSMutableString stringWithString:@"GiftTransaction"];
        }
    }
    
    NSString *soapMessage = [self buildSoapMessageFromDictionary:dictionary andPassword:password];
    NSURL *url = [NSURL URLWithString:MERCURY_WEB_SERVICE_URL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSString *soapAction = [NSString stringWithFormat:@"http://www.mercurypay.com/%@", _transactionType];
    [theRequest addValue: soapAction forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection ) {
        _conWebData = [NSMutableData data];
    }
    else {
        NSLog(@"theConnection is NULL");
    }
    
}

- (NSString *)buildSoapMessageFromDictionary:(NSDictionary *)dict andPassword:(NSString *)password {
    
    NSMutableString *tStream = [NSMutableString string];
    [tStream appendFormat:@"<TStream>\n"];
    [tStream appendFormat:@"<Transaction>\n"];
    
    for (NSString *key in [dict allKeys]) {
        [tStream appendFormat:@"<%@>%@</%@>\n", key, [dict objectForKey:key], key];
    }
    
    [tStream appendFormat:@"</Transaction>\n"];
    [tStream appendFormat:@"</TStream>\n"];
    
    NSString *transaction = [tStream copy];
    transaction = [transaction stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    transaction = [transaction stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://www.mercurypay.com\">\n"
                             "<tran>\n"
                             "%@"
                             "</tran>\n"
                             "<pw>%@</pw>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", _transactionType, transaction, password, _transactionType];
    return soapMessage;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_conWebData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_conWebData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate performSelector:@selector(transactionDidFailWithError:) withObject:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _numberOfPasses = 0;
    _xmlParser = [[NSXMLParser alloc] initWithData: _conWebData];
    [_xmlParser setDelegate: self];
    [_xmlParser setShouldResolveExternalEntities: YES];
    [_xmlParser parse];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    _numberOfPasses += 1;
    _dict = [[NSMutableDictionary alloc] init];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName   attributes: (NSDictionary *)attributeDict
{
    if (_numberOfPasses == 1)
    {
       NSString *transactionResult = [NSString stringWithFormat:@"%@Result", _transactionType];
        
        if( [elementName isEqualToString:transactionResult])
        {
            if(!_soapResults)
            {
                _soapResults = [[NSMutableString alloc] init];
            }
            _recordResults = YES;
        }
    }
    else
    {
        _currentElement = elementName;
        if(!_soapResults)
        {
            _soapResults = [[NSMutableString alloc] init];
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_numberOfPasses == 1)
    {
        if(_recordResults)
        {
            [_soapResults appendString: string];
        }
    }
    else
    {
        [_soapResults appendString: string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (_numberOfPasses == 1)
    {
        NSString *transactionResult = [NSString stringWithFormat:@"%@Result", _transactionType];
        
        if([elementName isEqualToString:transactionResult])
        {
            _TransactionResult = _soapResults;
            _TransactionResult = [_TransactionResult stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            _TransactionResult = [_TransactionResult stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];

            _recordResults = NO;
        }
    }
    else
    {
        if ([elementName isEqualToString:_currentElement]
            && ![_soapResults hasPrefix:@"<"])
        {
            NSString *value = [_soapResults stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [_dict setObject:value forKey:_currentElement];
        }
    }
    
    _soapResults = nil;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (_numberOfPasses == 1)
    {
        NSData *data = [_TransactionResult dataUsingEncoding:NSUTF8StringEncoding];
        _xmlParser = [[NSXMLParser alloc] initWithData: data];
        [_xmlParser setDelegate: self];
        [_xmlParser setShouldResolveExternalEntities: YES];
        [_xmlParser parse];
    }
    else
    {
        [self.delegate performSelector:@selector(transactionDidFinish:) withObject:_dict];
    }
}

@end
