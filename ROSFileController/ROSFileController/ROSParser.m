//
//  ROSParser.m
//  ROSFileController
//
//  Created by Noah Dayan on 8/17/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "ROSParser.h"

@interface ROSParser () {
    NSMutableString *currentString;
    NSMutableArray *elementsArray;
    ROSButton *button;
}

@end

@implementation ROSParser
{
    BOOL inMsg;
}

- (NSMutableArray *)generateControls:(NSURL *)address
{
    inMsg = NO;
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:address];
    [xmlParser setDelegate:self];
    
    clock_t time = clock();
    
    [xmlParser parse];
    
    NSLog(@"Parse Time: %lu clock ticks", clock() - time);
    
    return elementsArray;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"Parsing Started");
    elementsArray = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"Parsing Ended");
    for(ROSButton *element in elementsArray)
    {
        NSError *error;
        
        NSLog(@"%@, %@, %@, %@\n", element.title, element.op, element.topic, [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:element.msg options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding]);
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!currentString)
    {
        currentString = [[NSMutableString alloc] init];
    }
    [currentString appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSLog(@"Parsing String: %@", currentString);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"button"])
    {
        button = [[ROSButton alloc] init];
    }
    else if([elementName isEqualToString:@"msg"])
    {
        inMsg = YES;
        button.msg = [[NSMutableDictionary alloc] init];
    }
    NSLog(@"Parsing Element Start: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
{
    if([elementName isEqualToString:@"button"])
    {
        [elementsArray addObject:button];
        button = nil;
    }
    else if([elementName isEqualToString:@"msg"])
    {
        inMsg = NO;
    }
    else if(inMsg)
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [formatter numberFromString:currentString];
        
        if(number)
        {
            [button.msg setObject:number forKey:elementName];
        }
        else
        {
            [button.msg setObject:currentString forKey:elementName];
        }
    }
    else
    {
        [button setValue:currentString forKey:elementName];
    }
    currentString = nil;
    NSLog(@"Parsing Element End: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Parsing Failed With Error %@", parseError);
}

@end
