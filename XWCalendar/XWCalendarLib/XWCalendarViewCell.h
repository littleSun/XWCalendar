//
//  XWCalendarViewCell.h
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCalendarConfig.h"

@class XWCalendarViewCell;

@protocol XWCalendarViewCellDelegate <NSObject>

@optional

- (BOOL)calendarViewCell:(XWCalendarViewCell *)cell shouldUseCustomColorsForDate:(NSDate *)date;


- (UIColor *)calendarViewCell:(XWCalendarViewCell *)cell textColorForDate:(NSDate *)date;

- (UIColor *)calendarViewCell:(XWCalendarViewCell *)cell circleColorForDate:(NSDate *)date;

@end

static NSString *XWCalendarViewCellIdentifier = @"XWCalendarViewCellIdentifier";

@interface XWCalendarViewCell : UICollectionViewCell

@property (nonatomic, weak) id<XWCalendarViewCellDelegate> delegate;

/**
 *  Define if the cell is today in the calendar.
 */
@property (nonatomic, assign) BOOL isToday;

/**
 *  Customize the circle behind the day's number color using.
 */
@property (nonatomic, strong) UIColor *circleDefaultColor;

/**
 *  Customize the color of the circle for today's cell using.
 */
@property (nonatomic, strong) UIColor *circleTodayColor;

/**
 *  Customize the color of the circle when cell is selected using.
 */
@property (nonatomic, strong) UIColor *circleSelectedColor;

/**
 *  Customize the day's number using.
 */
@property (nonatomic, strong) UIColor *textDefaultColor;

/**
 *  Customize today's number color using.
 */
@property (nonatomic, strong) UIColor *textTodayColor;

/**
 *  Customize the day's number color when cell is selected using.
 */
@property (nonatomic, strong) UIColor *textSelectedColor;

/**
 *  Customize the day's number color when cell is disabled using.
 */
@property (nonatomic, strong) UIColor *textDisabledColor;

/**
 *  Customize the day's number font using.
 */
@property (nonatomic, strong) UIFont *textDefaultFont;


- (void)setDate:(NSDate*)date calendar:(NSCalendar*)calendar;

- (void)refreshCellColors;

@end
