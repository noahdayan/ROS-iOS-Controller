//
//  ROSViewController.m
//  ROSFileController
//
//  Created by Noah Dayan on 8/17/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "ROSViewController.h"

@interface ROSViewController ()
- (void)displayButtons;
@end

@implementation ROSViewController
{
    BOOL isOpen;
    BOOL isConnected;
    SRWebSocket *socketRocket;
    ROSParser *parser;
    NSMutableArray *buttons;
    NSMutableArray *controls;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isOpen = NO;
    isConnected = NO;
    parser = [[ROSParser alloc] init];
    buttons = [[NSMutableArray alloc] init];
    controls = [[NSMutableArray alloc] init];
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
    if(theTextField == self.addressField || theTextField == self.filePath)
    {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (void)enableButtons
{
    for(UIButton *control in controls)
    {
        [control setEnabled:YES];
    }
}

- (void)disableButtons
{
    for(UIButton *control in controls)
    {
        [control setEnabled:NO];
    }
}

- (void)displayButtons
{
    CGFloat x = 120.0;
    CGFloat y = 0.0;
    NSInteger tagNum = 0;
    
    for(ROSButton *button in buttons)
    {
        UIButton *control = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        control.tag = tagNum;
        [control setTitle:button.title forState:UIControlStateNormal];
        [control addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        control.frame = CGRectMake(x, y, 80.0, 40.0);
        [controls addObject:control];
        [self.scrollArea addSubview:control];
        
        y += 50.0;
        tagNum++;
    }
    [self.scrollArea setContentSize:CGSizeMake(2 * x, y)];
}

- (IBAction)parseAction:(id)sender
{
    NSURL *url = [[NSURL alloc] initWithString:self.filePath.text];
    buttons = [parser generateControls:url];
    [self displayButtons];
    
    if(!isConnected)
    {
        [self disableButtons];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    NSLog(@"Button Pressed: %d", sender.tag);
    NSLog(@"%@", [[buttons objectAtIndex:sender.tag] getButtonMessage]);
    [socketRocket send:[[buttons objectAtIndex:sender.tag] getButtonMessage]];
}

@end
