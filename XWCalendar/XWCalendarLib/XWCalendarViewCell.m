//
//  XWCalendarViewCell.m
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import "XWCalendarViewCell.h"


@interface XWCalendarViewCell ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) NSDate *date;

@end

@implementation XWCalendarViewCell

#pragma mark - Class Methods

+ (NSString *)formatDate:(NSDate *)date withCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
    return [XWCalendarViewCell stringFromDate:date withDateFormatter:dateFormatter withCalendar:calendar];
}

+ (NSString *)formatAccessibilityDate:(NSDate *)date withCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [self accessibilityDateFormatter];
    return [XWCalendarViewCell stringFromDate:date withDateFormatter:dateFormatter withCalendar:calendar];
}


+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"d";
    });
    return dateFormatter;
}

+ (NSDateFormatter *)accessibilityDateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
    });
    return dateFormatter;
}

+ (NSString *)stringFromDate:(NSDate *)date withDateFormatter:(NSDateFormatter *)dateFormatter withCalendar:(NSCalendar *)calendar {
    //Test if the calendar is different than the current dateFormatter calendar property
    if (![dateFormatter.calendar isEqual:calendar]) {
        dateFormatter.calendar = calendar;
    }
    return [dateFormatter stringFromDate:date];
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _date = nil;
        _isToday = NO;
        _dayLabel = [[UILabel alloc] init];
        [self.dayLabel setFont:[self textDefaultFont]];
        [self.dayLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.dayLabel];
        
        //Add the Constraints
        [self.dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.dayLabel setBackgroundColor:[UIColor clearColor]];
        self.dayLabel.layer.cornerRadius = XWCalendarCircleSize/2;
        self.dayLabel.layer.masksToBounds = YES;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:XWCalendarCircleSize]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:XWCalendarCircleSize]];
        
        [self setCircleColor:NO selected:NO];
    }
    
    return self;
}

- (void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar
{
    NSString* day = @"";
    NSString* accessibilityDay = @"";
    if (date && calendar) {
        _date = date;
        day = [XWCalendarViewCell formatDate:date withCalendar:calendar];
        accessibilityDay = [XWCalendarViewCell formatAccessibilityDate:date withCalendar:calendar];
    }
    self.dayLabel.text = day;
    self.dayLabel.accessibilityLabel = accessibilityDay;
}

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    [self setCircleColor:isToday selected:self.selected];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setCircleColor:self.isToday selected:selected];
}


- (void)setCircleColor:(BOOL)today selected:(BOOL)selected
{
    UIColor *circleColor = (today) ? [self circleTodayColor] : [self circleDefaultColor];
    UIColor *labelColor = (today) ? [self textTodayColor] : [self textDefaultColor];
    
    if (self.date && self.delegate) {
        if ([self.delegate respondsToSelector:@selector(calendarViewCell:shouldUseCustomColorsForDate:)] && [self.delegate calendarViewCell:self shouldUseCustomColorsForDate:self.date]) {
            
            if ([self.delegate respondsToSelector:@selector(calendarViewCell:textColorForDate:)] && [self.delegate calendarViewCell:self textColorForDate:self.date]) {
                labelColor = [self.delegate calendarViewCell:self textColorForDate:self.date];
            }
            
            if ([self.delegate respondsToSelector:@selector(calendarViewCell:circleColorForDate:)] && [self.delegate calendarViewCell:self circleColorForDate:self.date]) {
                circleColor = [self.delegate calendarViewCell:self circleColorForDate:self.date];
            }
        }
    }
    
    if (selected) {
        circleColor = [self circleSelectedColor];
        labelColor = [self textSelectedColor];
    }
    
    [self.dayLabel setBackgroundColor:circleColor];
    [self.dayLabel setTextColor:labelColor];
}


- (void)refreshCellColors
{
    [self setCircleColor:self.isToday selected:self.isSelected];
}


#pragma mark - Prepare for Reuse

- (void)prepareForReuse
{
    [super prepareForReuse];
    _date = nil;
    _isToday = NO;
    [self.dayLabel setText:@""];
    [self.dayLabel setBackgroundColor:[self circleDefaultColor]];
    [self.dayLabel setTextColor:[self textDefaultColor]];
}

#pragma mark - Circle Color Customization Methods

- (UIColor *)circleDefaultColor
{
    if(_circleDefaultColor != nil) {
        return _circleDefaultColor;
    }
    
    return [UIColor whiteColor];
}

- (UIColor *)circleTodayColor
{
    if(_circleTodayColor != nil) {
        return _circleTodayColor;
    }
    
    return [UIColor grayColor];
}

- (UIColor *)circleSelectedColor
{
    if(_circleSelectedColor != nil) {
        return _circleSelectedColor;
    }
    
    return [UIColor redColor];
}

#pragma mark - Text Label Customizations Color

- (UIColor *)textDefaultColor
{
    if(_textDefaultColor != nil) {
        return _textDefaultColor;
    }
    
    return [UIColor blackColor];
}

- (UIColor *)textTodayColor
{
    if(_textTodayColor != nil) {
        return _textTodayColor;
    }
    
    return [UIColor whiteColor];
}

- (UIColor *)textSelectedColor
{
    if(_textSelectedColor != nil) {
        return _textSelectedColor;
    }
    
    return [UIColor whiteColor];
}

- (UIColor *)textDisabledColor
{
    if(_textDisabledColor != nil) {
        return _textDisabledColor;
    }
    
    return [UIColor lightGrayColor];
}

#pragma mark - Text Label Customizations Font

- (UIFont *)textDefaultFont
{
    if (_textDefaultFont != nil) {
        return _textDefaultFont;
    }
    
    // default system font
    return [UIFont systemFontOfSize:17.0];
}

@end
