//
//  XWCalendarConfig.h
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#ifndef XWCalendarConfig_h
#define XWCalendarConfig_h

#import <UIKit/UIKit.h>

static const CGFloat XWCalendarFlowLayoutMinInterItemSpacing = 0.0f;
static const CGFloat XWCalendarFlowLayoutMinLineSpacing = 0.0f;
static const CGFloat XWCalendarFlowLayoutInsetTop = 5.0f;
static const CGFloat XWCalendarFlowLayoutInsetLeft = 0.0f;
static const CGFloat XWCalendarFlowLayoutInsetBottom = 5.0f;
static const CGFloat XWCalendarFlowLayoutInsetRight = 0.0f;
static const CGFloat XWCalendarFlowLayoutHeaderHeight = 5.0f;

static const CGFloat XWCalendarCircleSize = 32.0f;

static const CGFloat XWCalendarWeekdayHeaderSize = 13.0f;
static const CGFloat XWCalendarWeekdayHeaderHeight = 25.0f;

static const NSCalendarUnit kCalendarUnitYMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

static const CGFloat XWCalendarTitleHeight = 40.0f;

static const NSUInteger kDaysPerWeek = 7;

static const CGFloat ArrowsWidth = 40.0f;

static inline CGFloat XWCalendarViewGetHeight(CGFloat width)
{
    return XWCalendarWeekdayHeaderHeight+XWCalendarTitleHeight+10+floor(width*6.0/kDaysPerWeek);
}

typedef NS_ENUM (NSInteger, XWCalendarViewWeekdayTextType) {
    XWCalendarViewWeekdayTextTypeVeryShort = 0,
    XWCalendarViewWeekdayTextTypeShort,
    XWCalendarViewWeekdayTextTypeStandAlone
};


#endif /* XWCalendarConfig_h */
