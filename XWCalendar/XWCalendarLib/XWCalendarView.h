//
//  XWCalendarView.h
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCalendarViewWeekdayHeader.h"
#import "XWCalendarViewCell.h"
#import "XWCalendarViewFlowLayout.h"

@class XWCalendarView;

@protocol XWCalendarViewDelegate <NSObject>

@optional

- (BOOL)calendarView:(XWCalendarView *)target isEnabledDate:(NSDate *)date;
- (void)calendarView:(XWCalendarView *)target didSelected:(NSDate *)date;

@end

@interface XWCalendarView : UIView

/**
 *  回调
 */
@property (nonatomic ,assign) id <XWCalendarViewDelegate> delegate;

/**
 *  日历
 */
@property (nonatomic, strong) NSCalendar *calendar;

/**
 * 第一天
 */
@property (nonatomic, strong) NSDate *firstDate;

/**
 * 最后一天
 */
@property (nonatomic, strong) NSDate *lastDate;

/**
 * 选择的日期
 */
@property (nonatomic, strong) NSDate *selectedDate;

/**
 *  主题色
 */
@property (nonatomic, strong) UIColor *themeColor;

/**
 *  标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  Setting Text type of weekday
 */
@property (nonatomic, assign) XWCalendarViewWeekdayTextType weekdayTextType;


- (NSDate *)clampDate:(NSDate *)date toComponents:(NSUInteger)unitFlags;

@end
