//
//  ROSViewController.h
//  ROSAccelerometer
//
//  Created by Noah Dayan on 8/22/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#import "SRWebSocket.h"

@interface ROSViewController : UIViewController <SRWebSocketDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectAction:(id)sender;
@property (copy, nonatomic) NSString *websocketAddress;

@property (weak, nonatomic) IBOutlet UILabel *tiltLabel;

@end
