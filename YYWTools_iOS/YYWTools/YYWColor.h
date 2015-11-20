//
//  YYWColor.h
//  YYWTools
//
//  Created by yoever on 15/11/16.
//  Copyright © 2015年 yoever. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static inline UIColor *yywColorFromHexColorWithAlpha(NSString *hexColor, CGFloat alpha)
{
    alpha = alpha > 1 ? 1 : alpha;
    UIColor *resultColor = nil;
    float   red = 255, green = 255, blue = 255;
    NSRange range = NSMakeRange(1, 2);
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexFloat:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexFloat:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexFloat:&blue];
    resultColor = [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
    return resultColor;
}
/**
 *  HexColor like "#FFFFFF" to UIColor
 */
static inline UIColor *yywColorFromHexColor(NSString *hexColor)
{
    return yywColorFromHexColorWithAlpha(hexColor,1);
}
/**
 *  UIColor to HexColor like "#FFFFFF"
 */
static inline NSString *yywHexColorFromColor(UIColor *color)
{
    NSString    *stringColor = nil;
    CGColorRef  cgColor = [color CGColor];
    const CGFloat *colors = CGColorGetComponents(cgColor);//RGB
    int red     = colors[0] * 255.f;
    int green   = colors[1] * 255.f;
    int blue    = colors[2] * 255.f;
    stringColor = [NSString stringWithFormat:@"#%02X%02X%02X", red, green, blue];//RGB
    return stringColor;
}
