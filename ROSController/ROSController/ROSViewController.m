//
//  ROSViewController.m
//  ROSController
//
//  Created by Noah Dayan on 7/21/13.
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isOpen = NO;
    isConnected = NO;
    [self disableButtons];
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
                [self enableButtons];
        
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
        
        [self disableButtons];
        
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

- (void)enableButtons
{
    [[self upButton] setEnabled:YES];
    [[self leftButton] setEnabled:YES];
    [[self rightButton] setEnabled:YES];
    [[self downButton] setEnabled:YES];
}

- (void)disableButtons
{
    [[self upButton] setEnabled:NO];
    [[self leftButton] setEnabled:NO];
    [[self rightButton] setEnabled:NO];
    [[self downButton] setEnabled:NO];
}

- (IBAction)upAction:(id)sender
{
    NSLog(@"Up");
    //NSError *jsonParsingError = nil;
    //NSData *json;
    //id data = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&jsonParsingError];
    [socketRocket send:@"{ \"op\":\"publish\", \"topic\":\"/turtle1/command_velocity\", \"msg\":{ \"linear\":2.0, \"angular\":0.0 } }"];
}

- (IBAction)leftAction:(id)sender
{
    NSLog(@"Left");
    //NSError *jsonParsingError = nil;
    //NSData *json;
    //id data = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&jsonParsingError];
    [socketRocket send:@"{ \"op\":\"publish\", \"topic\":\"/turtle1/command_velocity\", \"msg\":{ \"linear\":0.0, \"angular\":1.8 } }"];
}

- (IBAction)rightAction:(id)sender
{
    NSLog(@"Right");
    //NSError *jsonParsingError = nil;
    //NSData *json;
    //id data = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&jsonParsingError];
    [socketRocket send:@"{ \"op\":\"publish\", \"topic\":\"/turtle1/command_velocity\", \"msg\":{ \"linear\":0.0, \"angular\":-1.8 } }"];
}

- (IBAction)downAction:(id)sender
{
    NSLog(@"Down");
    //NSError *jsonParsingError = nil;
    //NSData *json;
    //id data = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&jsonParsingError];
    [socketRocket send:@"{ \"op\":\"publish\", \"topic\":\"/turtle1/command_velocity\", \"msg\":{ \"linear\":-2.0, \"angular\":0.0 } }"];
}

@end
