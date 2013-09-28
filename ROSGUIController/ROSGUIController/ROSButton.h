//
//  ROSButton.h
//  ROSGUIController
//
//  Created by Noah Dayan on 8/22/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROSButton : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *op;
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, strong) NSMutableDictionary *msg;

- (id)initWithTitle:(NSString *)title Op:(NSString *)op Topic:(NSString *)topic Msg:(NSMutableDictionary *)msg;
- (id)getButtonMessage;

@end
