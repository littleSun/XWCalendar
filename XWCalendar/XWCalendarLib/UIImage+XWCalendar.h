//
//  UIImage+XWCalendar.h
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XWCalendar)

+ (UIImage *)getImageFromPath:(UIBezierPath *)path withColor:(UIColor *)color;

+ (UIBezierPath *)getLeftArrowPath;
+ (UIBezierPath *)getRightArrowPath;

@end
