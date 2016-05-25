//
//  UIImage+XWCalendar.m
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import "UIImage+XWCalendar.h"

@implementation UIImage (XWCalendar)

+ (UIImage *)getImageFromPath:(UIBezierPath *)path withColor:(UIColor *)color
{
    //开启位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(9, 14), NO, 1);
//    UIRectFrame(CGRectMake(0, 0, 13, 20));
    [color setStroke];

    [path stroke];
 
    //设置超出的内容不显示，
    [path addClip];
    
    //获取上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭位图上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIBezierPath *)getLeftArrowPath
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2.5;
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineJoinRound;
//    aPath.miterLimit = 5;
    [aPath moveToPoint:CGPointMake(8, 1)];
    [aPath addLineToPoint:CGPointMake(1, 7)];
    [aPath addLineToPoint:CGPointMake(8, 13)];
    return aPath;
    
    
}

+ (UIBezierPath *)getRightArrowPath
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2.5;
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineJoinRound;

    [aPath moveToPoint:CGPointMake(1, 1)];
    [aPath addLineToPoint:CGPointMake(8, 7)];
    [aPath addLineToPoint:CGPointMake(1, 13)];
    
    return aPath;
}

@end
