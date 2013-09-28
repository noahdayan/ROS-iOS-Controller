//
//  ROSViewController.m
//  ROSGUIController
//
//  Created by Noah Dayan on 8/17/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "ROSViewController.h"

@interface ROSViewController ()

@end

@implementation ROSViewController
{
    BOOL isOpen;
    BOOL isConnected;
    BOOL isEditing;
    SRWebSocket *socketRocket;
    NSMutableArray *buttons;
    NSMutableArray *controls;
    NSInteger buttonCount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isOpen = NO;
    isConnected = NO;
    isEditing = NO;
    buttons = [[NSMutableArray alloc] init];
    controls = [[NSMutableArray alloc] init];
    buttonCount = 0;
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

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        ROSAddControlViewController *viewController = [segue sourceViewController];
        
        if(viewController.addedButton)
        {
            [buttons addObject:viewController.addedButton];
            UIButton *control = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            control.tag = buttonCount;
            [control setTitle:viewController.addedButton.title forState:UIControlStateNormal];
            [control addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [control addTarget:self action:@selector(dragAction:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            [control addTarget:self action:@selector(doubleTapAction:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
            control.frame = CGRectMake(120.0, 200.0, 80.0, 40.0);
            [controls addObject:control];
            [self.view addSubview:control];
            
            buttonCount++;
            
            if(!isConnected)
            {
                [self disableButtons];
            }
        }
        //[self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"CancelInput"])
    {
        //[self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)editAction:(id)sender
{
    if(!isEditing)
    {
        [self.editButton setStyle:UIBarButtonItemStyleDone];
        [self.editButton setTitle:@"Done"];
        if(!isConnected)
        {
            [self enableButtons];
        }
        isEditing = YES;
    }
    else
    {
        [self.editButton setStyle:UIBarButtonItemStyleBordered];
        [self.editButton setTitle:@"Edit"];
        if(!isConnected)
        {
            [self disableButtons];
        }
        isEditing = NO;
    }
}

- (void)buttonAction:(UIButton *)sender
{
    if(!isEditing)
    {
        NSLog(@"Button Pressed: %d", sender.tag);
        NSLog(@"%@", [[buttons objectAtIndex:sender.tag] getButtonMessage]);
        [socketRocket send:[[buttons objectAtIndex:sender.tag] getButtonMessage]];
    }
}

- (void)dragAction:(UIButton *)sender withEvent:(UIEvent *)event
{
    if(isEditing)
    {
        NSLog(@"Button Dragged: %d", sender.tag);
        CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
        NSLog(@"Button Center: x: %f, y: %f", point.x, point.y);
        if(point.y > 180.0)
        {
            sender.center = point;
        }
    }
}

- (void)doubleTapAction:(UIButton *)sender withEvent:(UIEvent *)event
{
    if(isEditing)
    {
        UITouch *touch = [[event allTouches] anyObject];
        if(touch.tapCount == 2)
        {
            [sender setHidden:YES];
        }
    }
}

@end
