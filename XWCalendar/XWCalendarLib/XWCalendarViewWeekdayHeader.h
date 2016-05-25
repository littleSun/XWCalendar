//
//  XWCalendarViewWeekdayHeader.h
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCalendarConfig.h"

@interface XWCalendarViewWeekdayHeader : UIView

@property (nonatomic, strong) NSCalendar *calendar;

/**
 *  Customize the text color.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  Customize the text font.
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 *  Customize the header background color.
 */
@property (nonatomic, strong) UIColor *headerBackgroundColor;

/**
 *  Setting Text type of weekday
 *
 *  Default value is Short.
 */
@property (nonatomic, assign) XWCalendarViewWeekdayTextType weekdayTextType;


@end
