//
//  ViewController.m
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import "ViewController.h"
#import "XWCalendar.h"

@interface ViewController ()<XWCalendarViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    XWCalendarView *haha = [[XWCalendarView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, XWCalendarViewGetHeight(self.view.frame.size.width))];
    haha.themeColor = [UIColor blueColor];
    [self.view addSubview:haha];
    haha.delegate = self;

}

- (BOOL)calendarView:(XWCalendarView *)target isEnabledDate:(NSDate *)date
{
    NSDate *today = [target clampDate:[NSDate date] toComponents:kCalendarUnitYMD];

    if ([today compare:date] == NSOrderedAscending) {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
