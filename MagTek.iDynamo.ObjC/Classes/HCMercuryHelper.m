//
//  MercurySOAPHelper.m
//  CallMercuryHostedCheckoutWebService
//
//  Created by Kevin Oliver on 5/16/13.
//  Copyright (c) 2013 Kevin Oliver. All rights reserved.
//

#import "HCMercuryHelper.h"

@implementation HCMercuryHelper

// Change this URL to https://hc.mercurypay.com/hcws/hcservice.asmx when runing transactions against production Hosted Checkout Web service

static NSString *const MERCURY_WEB_SERVICE_URL = @"https://hc.mercurydev.net/hcws/hcservice.asmx";

static int          _numberOfPasses = 0;
NSMutableData       *_conWebData;
NSMutableString     *_soapResults;
NSString            *_hcTransactionResult;
NSMutableDictionary *_dict;
NSString            *_currentElement;
NSXMLParser         *_xmlParser;
static BOOL         _recordResults = NO;
NSMutableString     *_hctransactionType;
NSString            *_noCaps;
NSString            *_paymentID;

-(void) hctransctionFromDictionary:(NSDictionary *)dictionary andPassword:(NSString *)password {
    
    NSString *soapMessage = [self buildSoapMessageFromDictionary:dictionary andPassword:password];
    NSURL *url = [NSURL URLWithString:MERCURY_WEB_SERVICE_URL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSString *soapAction = [NSString stringWithFormat:@"http://www.mercurypay.com/%@", @"InitializePayment"];
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

-(void) hcVerifyFromDictionary:(NSDictionary *)dictionary andPassword:(NSString *)password {
    
    NSString *soapMessage = [self buildVerifyMessageFromDictionary:dictionary andPassword:password];
    NSURL *url = [NSURL URLWithString:MERCURY_WEB_SERVICE_URL];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    NSString *soapAction = [NSString stringWithFormat:@"http://www.mercurypay.com/%@", @"VerifyPayment"];
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
    NSString *hcSoap = [NSString stringWithFormat:
                        
                        @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://www.mercurypay.com/\">\n"
                        "<soapenv:Header/>\n"
                        "<soapenv:Body>\n"
                        "<InitializePayment>\n"
                        "<request>\n"
                        "<MerchantID>018847445761734</MerchantID>\n"
                        "<Password>Y6@Mepyn!r0LsMNq</Password>\n"
                        "<Keypad>Off</Keypad>\n"
                        "<Invoice>12346</Invoice>\n"
                        "<TotalAmount>3.04</TotalAmount>\n"
                        "<TaxAmount>0.00</TaxAmount>\n"
                        "<TranType>Sale</TranType>\n"
                        "<Frequency>OneTime</Frequency>\n"
                        "<Memo>Testing HostedCheckout.POS.ObjC</Memo>\n"
                        "<ProcessCompleteUrl>COMPLETED</ProcessCompleteUrl>\n"
                        "<ReturnUrl>CANCELED</ReturnUrl>\n"
                        "<TotalAmountBackgroundColor>#00A4E4</TotalAmountBackgroundColor>\n"
                        "<DefaultSwipe>Swipe</DefaultSwipe>\n"
                        "<DisplayStyle>Custom</DisplayStyle>\n"
                        "<BackgroundColor>#00A4E4</BackgroundColor>\n"
                        "<ButtonBackgroundColor>#00A4E4</ButtonBackgroundColor>\n"
                        "<CancelButton>On</CancelButton>\n"
                        "</request>\n"
                        "</InitializePayment>\n"
                        "</soapenv:Body>\n"
                        "</soapenv:Envelope>\n"];
    
    return hcSoap;
}

- (NSString *)buildVerifyMessageFromDictionary:(NSDictionary *)dict andPassword:(NSString *)password {
    
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
    
    NSString *hcSoap = [NSString stringWithFormat:
                        
                        @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"http://www.mercurypay.com/\">\n"
                        "<soapenv:Header/>\n"
                        "<soapenv:Body>\n"
                        "<VerifyPayment>\n"
                        "<request>\n"
                        "<MerchantID>018847445761734</MerchantID>\n"
                        "<Password>Y6@Mepyn!r0LsMNq</Password>\n"
                        "<PaymentID>%@</PaymentID>\n"
                        "</request>\n"
                        "</VerifyPayment>\n"
                        "</soapenv:Body>\n"
                        "</soapenv:Envelope>\n", _paymentID];
    
    return hcSoap;
    
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
    [self.delegate performSelector:@selector(hctransactionDidFailWithError:) withObject:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _numberOfPasses = 1;
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
       NSString *hctransactionResult = @"InitializePaymentResult";
        
        if( [elementName isEqualToString:hctransactionResult])
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
        NSString *hctransactionResult = [NSString stringWithFormat:@"InitializePaymentResult"];
        
        if([elementName isEqualToString:hctransactionResult])
        {
            _hcTransactionResult = _soapResults;
            _hcTransactionResult = [_hcTransactionResult stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            _hcTransactionResult = [_hcTransactionResult stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];

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
        NSData *data = [_hcTransactionResult dataUsingEncoding:NSUTF8StringEncoding];
        _xmlParser = [[NSXMLParser alloc] initWithData: data];
        [_xmlParser setDelegate: self];
        [_xmlParser setShouldResolveExternalEntities: YES];
        [_xmlParser parse];
        _numberOfPasses += 1;
    }
    else
    {
        [self.delegate performSelector:@selector(hctransactionDidFinish:) withObject:_dict];
        
        if ([_dict objectForKey:@"PaymentID"]) {
            _paymentID = [_dict objectForKey:@"PaymentID"];
        }
    }
    
}

@end