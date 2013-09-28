//
//  ROSParser.h
//  ROSFileController
//
//  Created by Noah Dayan on 8/17/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ROSButton.h"

@interface ROSParser : NSObject <NSXMLParserDelegate>

- (NSMutableArray *)generateControls:(NSURL *)address;

@end
