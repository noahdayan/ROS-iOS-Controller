//
//  ROSButton.m
//  ROSGUIController
//
//  Created by Noah Dayan on 8/22/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "ROSButton.h"

@implementation ROSButton

- (id)initWithTitle:(NSString *)title Op:(NSString *)op Topic:(NSString *)topic Msg:(NSMutableDictionary *)msg
{
    self = [super init];
    if(self)
    {
        _title = title;
        _op = op;
        _topic = topic;
        _msg = msg;
        return self;
    }
    return nil;
}

- (id)getButtonMessage
{
    NSError *error;
    
    return [NSString stringWithFormat:@"{ \"op\":\"%@\", \"topic\":\"%@\", \"msg\":%@ }", self.op, self.topic, [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.msg options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
}

@end
