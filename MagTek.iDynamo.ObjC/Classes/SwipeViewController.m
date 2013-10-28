//
//  SwipeViewController.m
//  MagTek.iDynamo.ObjC
//
//  Created by agharris73 on 9/18/13.
//  Copyright (c) 2013 Mercury. All rights reserved.
//

#import "SwipeViewController.h"
#import "MTSCRA.h"
#import "AppDelegate.h"

@interface SwipeViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *ccSwipe;
    @property (strong, nonatomic) MTSCRA *magTek;
//    @property (strong, nonatomic) uniMag *uniMag;
@end

@implementation SwipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.magTek = [[MTSCRA alloc] init];
    [self.magTek listenForEvents:(TRANS_EVENT_OK|TRANS_EVENT_START|TRANS_EVENT_ERROR)];
    [self.magTek setDeviceProtocolString:(@"com.magtek.idynamo")];
    
    self.simSwipeuDynamoSwitch.on = false;
    self.simSwipeiDynamoSwitch.on = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)simSwipeuDynamoButtonPressed:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:!self.simSwipeuDynamoSwitch.on animated:true];
    [self.simSwipeiDynamoSwitch setOn:false animated:true];

    [self magTek_deactivate];
    
    if (self.simSwipeuDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKAUDIOREADER];
    }
}

- (IBAction)simSwipeduDynamoSwitchFlipped:(id)sender {
    [self.simSwipeiDynamoSwitch setOn:false animated:true];
    
    [self magTek_deactivate];
    
    if (self.simSwipeuDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKAUDIOREADER];
    }
}

- (IBAction)simSwipeiDynamoButtonPressed:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:false animated:true];
    [self.simSwipeiDynamoSwitch setOn:!self.simSwipeiDynamoSwitch.on animated:true];
    
    [self magTek_deactivate];
    
    if (self.simSwipeiDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKIDYNAMO];
    }
}

- (IBAction)simSwipeiDynamoSwitchFlipped:(id)sender {
    [self.simSwipeuDynamoSwitch setOn:false animated:true];
    
    [self magTek_deactivate];
    
    if (self.simSwipeiDynamoSwitch.on) {
        [self magtek_activateWithDeviceType:MAGTEKIDYNAMO];
    }
}

//-----------------------------------------------------------------------------
#pragma mark - MagTek SDK activation/deactivation -
//-----------------------------------------------------------------------------

- (void)magtek_activateWithDeviceType:(UInt32)deviceType
{
    [self.magTek setDeviceType:deviceType];
    [self.magTek openDevice];
    [self magtek_registerObservers:true];
    [self displayDeviceStatus];
}

-(void)magTek_deactivate {
    [self magtek_registerObservers:false];
    [self disconnected];
    
    if (self.magTek != NULL && self.magTek.isDeviceOpened)
    {
        [self.magTek closeDevice];
    }
    
}

//-----------------------------------------------------------------------------
#pragma mark - MagTek SDK observers -
//-----------------------------------------------------------------------------

- (void)magtek_registerObservers:(BOOL) reg {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    if (reg) {
        [nc addObserver:self selector:@selector(trackDataReady:) name:@"trackDataReadyNotification" object:nil];
        [nc addObserver:self selector:@selector(devConnStatusChange) name:@"devConnectionNotification" object:nil];
    }
    else {
        [nc removeObserver:self];
    }
}


- (void)trackDataReady:(NSNotification *)notification
{
    NSNumber *status = [[notification userInfo] valueForKey:@"status"];
    
    [self performSelectorOnMainThread:@selector(onDataEvent:)
                           withObject:status
                        waitUntilDone:NO];
}

- (void)onDataEvent:(id)status
{
    switch ([status intValue]) {
        case TRANS_STATUS_OK:
            NSLog(@"TRANS_STATUS_OK");
            self.encryptedSwipeData = [[EncryptedSwipeData alloc] init];
            self.encryptedSwipeData.track1Masked = self.magTek.getTrack1Masked;
            self.encryptedSwipeData.track2Masked = self.magTek.getTrack2Masked;
            self.encryptedSwipeData.track1Encrypted = self.magTek.getTrack1;
            self.encryptedSwipeData.track2Encrypted = self.magTek.getTrack2;
            self.encryptedSwipeData.ksn = self.magTek.getKSN;
            [self determineNextStep];
            break;
        case TRANS_STATUS_ERROR:
            NSLog(@"TRANS_STATUS_ERROR");
            break;
        default:
            break;
    }
}

- (void)devConnStatusChange
{
    [self displayDeviceStatus];
}

#pragma mark connection task

//-----------------------------------------------------------------------------
#pragma mark - Methods -
//-----------------------------------------------------------------------------

- (IBAction)disconnected {
    
    self.imageCardState.image = [UIImage imageNamed:@"ccStaticState.png"];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade; // there are other types but this is the nicest
    transition.duration = 0.34; // set the duration that you like
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.imageCardState.layer addAnimation:transition forKey:nil];
}

- (IBAction)connected {
    self.imageCardState.image = [UIImage imageNamed:@"ccSwipeState.png"];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade; // there are other types but this is the nicest
    transition.duration = 0.34; // set the duration that you like
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.imageCardState.layer addAnimation:transition forKey:nil];
}

- (void)displayDeviceStatus
{
    BOOL isMagTekDeviceConnected = [self.magTek isDeviceConnected];
    BOOL isMagTekDeviceOpen = [self.magTek isDeviceOpened];
    
    if ((self.magTek && isMagTekDeviceConnected && isMagTekDeviceOpen)){
        [self connected];
    }
    else {
        [self disconnected];
    }
}

- (int) encryptedLengthFromMasked: (int)maskedLength {
    int value = maskedLength;
    
    if (value > 0) {
        value = abs(8-(maskedLength % 8)) + maskedLength;
    }
    
    return value;
}

- (NSString*) hexFromData:(NSData*) data
{
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger dataLength  = data.length;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02x", (unsigned int)dataBuffer[i]]];
    }
    
    return [NSString stringWithString:hexString];
}

- (void)determineNextStep {
    
    [self magTek_deactivate];
    
    if (self.encryptedSwipeData != nil
        && self.encryptedSwipeData.track2Masked != nil
        && [self.encryptedSwipeData.track2Masked rangeOfString:@"="].location != NSNotFound)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.encryptedSwipeData = self.encryptedSwipeData;
        [self performSegueWithIdentifier:@"segueSwipeResults" sender:self];
    }
    else if (self.simSwipeiDynamoSwitch.on) {
        [self magtek_activateWithDeviceType: MAGTEKIDYNAMO];
    }
    else if(self.simSwipeuDynamoSwitch.on) {
        [self magtek_activateWithDeviceType: MAGTEKAUDIOREADER];
    }
}

@end
