//
//  NSDictionary+JsonString.m
//  YYWTools
//
//  Created by yoever on 15/11/16.
//  Copyright © 2015年 yoever. All rights reserved.
//

#import "NSDictionary+JsonString.h"

@implementation NSDictionary (JsonString)

- (NSString *)jsonString
{
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&jsonError];
    if (jsonError) {
        return nil;
    }
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
