//
//  ROSViewController.m
//  ROSAccelerometer
//
//  Created by Noah Dayan on 8/22/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "ROSViewController.h"

@interface ROSViewController ()

@end

@implementation ROSViewController
{
    BOOL isOpen;
    BOOL isConnected;
    SRWebSocket *socketRocket;
    CMMotionManager *motionManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isOpen = NO;
    isConnected = NO;
    self.tiltLabel.text = @"";
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.2;
    motionManager.gyroUpdateInterval = 0.2;
    [self motionControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    isOpen = YES;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"Websocket Failed With Error %@", error);
    socketRocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    socketRocket = nil;
}

#pragma mark - ROSViewController

- (IBAction)connectAction:(id)sender
{
    if(!isConnected)
    {
        if([[[NSURL URLWithString:self.addressField.text] scheme] isEqualToString:@"ws"])
        {
            socketRocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.addressField.text]]];
            socketRocket.delegate = self;
            [socketRocket open];
        
            //if(isOpen)
            //{
                self.tiltLabel.text = @"Tilt!";
        
                [[self connectButton] setTitle:@"Disconnect" forState:UIControlStateNormal];
                self.statusLabel.text = @"Connected";
                NSLog(@"Connected");
                isConnected = YES;
            //}
        }
    }
    else
    {
        socketRocket.delegate = nil;
        [socketRocket close];
        isOpen = NO;
        
        self.tiltLabel.text = @"";
        
        [[self connectButton] setTitle:@"Connect" forState:UIControlStateNormal];
        self.statusLabel.text = @"Disconnected";
        NSLog(@"Disconnected");
        isConnected = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == self.addressField)
    {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (void)motionControl
{
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error){
        
        if(isConnected)
        {
            [self sendAccelerationData:accelerometerData.acceleration];
        }
        if(error)
        {
            NSLog(@"%@", error);
        }
        
    }];
    
    [motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error){
        
        if(isConnected)
        {
            [self sendRotationData:gyroData.rotationRate];
        }
        if(error)
        {
            NSLog(@"%@", error);
        }
        
    }];
}

- (void)sendAccelerationData:(CMAcceleration)acceleration
{
    NSLog(@"Acc: x: %f, y: %f, z: %f", acceleration.x, acceleration.y, acceleration.z);
    [socketRocket send:[NSString stringWithFormat:@"{ \"op\":\"publish\", \"topic\":\"/turtle1/command_velocity\", \"msg\":{ \"linear\":%f, \"angular\":%f } }", acceleration.y, acceleration.x]];
}

- (void)sendRotationData:(CMRotationRate)rotation
{
    NSLog(@"Rot: x: %f, y: %f, z: %f", rotation.x, rotation.y, rotation.z);
    //[socketRocket send:[NSString stringWithFormat:@"{ \"op\":\"publish\", \"topic\":\"/turtle1/command_velocity\", \"msg\":{ \"linear\":%f, \"angular\":%f } }", rotation.y, rotation.x]];
}

@end
