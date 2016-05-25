//
//  XWCalendarViewWeekdayHeader.m
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import "XWCalendarViewWeekdayHeader.h"

@implementation XWCalendarViewWeekdayHeader

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        
        self.backgroundColor = self.headerBackgroundColor;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.calendar = self.calendar;
        NSArray *weekdaySymbols = nil;
        
        switch (self.weekdayTextType) {
            case XWCalendarViewWeekdayTextTypeVeryShort:
                weekdaySymbols = [dateFormatter veryShortWeekdaySymbols];
                break;
            case XWCalendarViewWeekdayTextTypeShort:
                weekdaySymbols = [dateFormatter shortWeekdaySymbols];
                break;
            default:
                weekdaySymbols = [dateFormatter standaloneWeekdaySymbols];
                break;
        }
        
        NSMutableArray *adjustedSymbols = [NSMutableArray arrayWithArray:weekdaySymbols];
  
        
        if (adjustedSymbols.count == 0) {
            return;
        }
        
        UILabel *firstWeekdaySymbolLabel = nil;
        
        NSMutableArray *weekdaySymbolLabelNameArr = [NSMutableArray array];
        NSMutableDictionary *weekdaySymbolLabelDict = [NSMutableDictionary dictionary];
        for (NSInteger index = 0; index < adjustedSymbols.count; index++)
        {
            NSString *labelName = [NSString stringWithFormat:@"weekdaySymbolLabel%d", (int)index];
            [weekdaySymbolLabelNameArr addObject:labelName];
            
            UILabel *weekdaySymbolLabel = [[UILabel alloc] init];
            weekdaySymbolLabel.font = self.textFont;
            weekdaySymbolLabel.text = [adjustedSymbols[index] uppercaseString];
            weekdaySymbolLabel.textColor = self.textColor;
            weekdaySymbolLabel.textAlignment = NSTextAlignmentCenter;
            weekdaySymbolLabel.backgroundColor = [UIColor clearColor];
            weekdaySymbolLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self addSubview:weekdaySymbolLabel];
            
            [weekdaySymbolLabelDict setObject:weekdaySymbolLabel forKey:labelName];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[%@]|", labelName] options:0 metrics:nil views:weekdaySymbolLabelDict]];
            
            if (firstWeekdaySymbolLabel == nil) {
                firstWeekdaySymbolLabel = weekdaySymbolLabel;
            } else {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:weekdaySymbolLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstWeekdaySymbolLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            }
        }
        
        NSString *layoutString = [NSString stringWithFormat:@"|[%@(>=0)]|", [weekdaySymbolLabelNameArr componentsJoinedByString:@"]["]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString options:NSLayoutFormatAlignAllCenterY metrics:nil views:weekdaySymbolLabelDict]];

    }
}

- (UIColor *)textColor
{
    if(_textColor != nil) {
        return _textColor;
    }
    
    return [UIColor blackColor];
}

- (UIFont *)textFont
{
    if(_textFont != nil) {
        return _textFont;
    }
    
    return [UIFont systemFontOfSize:XWCalendarWeekdayHeaderSize];
}

- (UIColor *)headerBackgroundColor
{
    if(_headerBackgroundColor != nil) {
        return _headerBackgroundColor;
    }
    
    return [UIColor whiteColor];
}


@end
