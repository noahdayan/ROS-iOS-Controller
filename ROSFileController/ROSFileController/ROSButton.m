//
//  ROSButton.m
//  ROSFileController
//
//  Created by Noah Dayan on 8/18/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "ROSButton.h"

@implementation ROSButton

- (id)getButtonMessage
{
    NSError *error;
    
    return [NSString stringWithFormat:@"{ \"op\":\"%@\", \"topic\":\"%@\", \"msg\":%@ }", self.op, self.topic, [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.msg options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]];
}

@end
