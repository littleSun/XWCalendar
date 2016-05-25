//
//  XWCalendarView.m
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import "XWCalendarView.h"
#import "UIImage+XWCalendar.h"


@interface XWCalendarView ()<XWCalendarViewCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *leftArrow;
@property (nonatomic, strong) UIButton *rightArrow;

@property (nonatomic, strong) NSDate *firstDateMonth;
@property (nonatomic, strong) NSDate *lastDateMonth;

@property (nonatomic, strong) NSDateFormatter *headerDateFormatter;

@property (nonatomic ,strong) XWCalendarViewWeekdayHeader *weekdayHeader;
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation XWCalendarView

@synthesize calendar = _calendar;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self commonInit];
    }
}

- (void)commonInit
{

    self.backgroundColor = [UIColor whiteColor];
    self.themeColor = [UIColor blackColor];

    self.weekdayTextType = XWCalendarViewWeekdayTextTypeVeryShort;
    
//    self.leftArrow.backgroundColor = [UIColor redColor];
//    self.rightArrow.backgroundColor = [UIColor redColor];
 
    self.leftArrow.tag = 100;
    self.rightArrow.tag = 101;
    
    [self.leftArrow addTarget:self action:@selector(changeMonthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightArrow addTarget:self action:@selector(changeMonthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    [self addSubview:self.titleLb];
    [self addSubview:self.leftArrow];
    [self addSubview:self.rightArrow];
    [self addSubview:self.weekdayHeader];
    [self addSubview:self.collectionView];
    
    self.titleLb.text = [self.headerDateFormatter stringFromDate:[self firstOfMonthForSection:0]];
}

- (void)changeMonthBtnClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        NSDateComponents *adcomps = [self.calendar components:kCalendarUnitYMD fromDate:self.firstDate];
        
        [adcomps setMonth:adcomps.month-1];
        [adcomps setDay:1];
        
        NSDate  *firstDate = [self.calendar dateFromComponents:adcomps];
        
        NSDateComponents *adcomps2 = [[NSDateComponents alloc] init];
        [adcomps2 setMonth:1];
        [adcomps2 setDay:-1];
        
        self.firstDate = firstDate;
        self.lastDate = [self.calendar dateByAddingComponents:adcomps2 toDate:firstDate options:0];
    }
    else if (sender.tag == 101) {
        NSDateComponents *adcomps = [self.calendar components:kCalendarUnitYMD fromDate:self.firstDate];
        
        [adcomps setMonth:adcomps.month+1];
        [adcomps setDay:1];
        
        NSDate  *firstDate = [self.calendar dateFromComponents:adcomps];
        
        NSDateComponents *adcomps2 = [[NSDateComponents alloc] init];
        [adcomps2 setMonth:1];
        [adcomps2 setDay:-1];
        
        self.firstDate = firstDate;
        self.lastDate = [self.calendar dateByAddingComponents:adcomps2 toDate:firstDate options:0];
        
        
    }
    
    self.firstDateMonth = nil;
    self.lastDateMonth = nil;
    
    if (_collectionView) {
        [self.collectionView reloadData];
        
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        if (sender.tag == 101) {
            transition.subtype = kCATransitionFromRight;
        }
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.removedOnCompletion = YES;
        [self.collectionView.layer addAnimation:transition forKey:@"transition"];
        
        self.titleLb.text = [self.headerDateFormatter stringFromDate:[self firstOfMonthForSection:0]];
    }
}

#pragma mark -- SubViews

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(ArrowsWidth, 0, self.frame.size.width-ArrowsWidth*2, XWCalendarTitleHeight)];
        _titleLb.textColor = self.themeColor;
        _titleLb.backgroundColor = self.backgroundColor;
        _titleLb.font = self.titleFont;
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

- (UIButton *)leftArrow
{
    if (!_leftArrow) {
        _leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftArrow.frame = CGRectMake(0, 0, ArrowsWidth, XWCalendarTitleHeight);
        
        UIImage *image = [UIImage getImageFromPath:[UIImage getLeftArrowPath]  withColor:self.themeColor];
        
        [_leftArrow setImage:image forState:UIControlStateNormal];
    }
    return _leftArrow;
}

- (UIButton *)rightArrow
{
    if (!_rightArrow) {
        _rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightArrow.frame = CGRectMake(self.frame.size.width-ArrowsWidth, 0, ArrowsWidth, XWCalendarTitleHeight);
        
        UIImage *image = [UIImage getImageFromPath:[UIImage getRightArrowPath] withColor:self.themeColor];
        
        [_rightArrow setImage:image forState:UIControlStateNormal];
    }
    return _rightArrow;
}

- (XWCalendarViewWeekdayHeader *)weekdayHeader
{
    if (!_weekdayHeader) {
        _weekdayHeader = [[XWCalendarViewWeekdayHeader alloc] initWithFrame:CGRectMake(0, XWCalendarTitleHeight, self.frame.size.width, XWCalendarWeekdayHeaderHeight)];
        _weekdayHeader.calendar = self.calendar;
        _weekdayHeader.weekdayTextType = self.weekdayTextType;
    }
    return _weekdayHeader;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        XWCalendarViewFlowLayout *layout = [[XWCalendarViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, XWCalendarTitleHeight+XWCalendarWeekdayHeaderHeight, self.frame.size.width, self.frame.size.height-XWCalendarTitleHeight-XWCalendarWeekdayHeaderHeight) collectionViewLayout:layout];
        
        [_collectionView registerClass:[XWCalendarViewCell class] forCellWithReuseIdentifier:XWCalendarViewCellIdentifier];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:self.backgroundColor];

    }
    return _collectionView;
}

#pragma mark - Accessors

- (NSDateFormatter *)headerDateFormatter;
{
    if (!_headerDateFormatter) {
        _headerDateFormatter = [[NSDateFormatter alloc] init];
        _headerDateFormatter.calendar = self.calendar;
        _headerDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy LLLL" options:0 locale:self.calendar.locale];
    }
    return _headerDateFormatter;
}

- (NSCalendar *)calendar
{
    if (!_calendar) {
       
        if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
             [self setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
        }
        else {
            [self setCalendar:[NSCalendar currentCalendar]];
        }
    }
    return _calendar;
}

-(void)setCalendar:(NSCalendar*)calendar
{
    _calendar = calendar;
    self.headerDateFormatter.calendar = calendar;
}

- (NSDate *)firstDate
{
    if (!_firstDate) {
        NSDateComponents *components = [self.calendar components:kCalendarUnitYMD
                                                        fromDate:[NSDate date]];
        components.day = 1;
        _firstDate = [self.calendar dateFromComponents:components];
    }
    
    return _firstDate;
}

- (NSDate *)firstDateMonth
{
    if (_firstDateMonth) { return _firstDateMonth; }
    
    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD
                                                    fromDate:self.firstDate];
    components.day = 1;
    
    _firstDateMonth = [self.calendar dateFromComponents:components];
    
    return _firstDateMonth;
}

- (NSDate *)lastDate
{
    if (!_lastDate) {
        
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        offsetComponents.month = 1;
        offsetComponents.day = -1;
        [self setLastDate:[self.calendar dateByAddingComponents:offsetComponents toDate:self.firstDateMonth options:0]];
    }
    
    return _lastDate;
}

- (NSDate *)lastDateMonth
{
    if (_lastDateMonth) { return _lastDateMonth; }
    
    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD
                                                    fromDate:self.lastDate];
    components.month++;
    components.day = 0;
    
    _lastDateMonth = [self.calendar dateFromComponents:components];
    
    return _lastDateMonth;
}

- (void)setSelectedDate:(NSDate *)newSelectedDate
{
    if (!newSelectedDate) {
        [[self cellForItemAtDate:_selectedDate] setSelected:NO];
        _selectedDate = newSelectedDate;
        
        return;
    }
    
    NSDate *startOfDay = [self clampDate:newSelectedDate toComponents:kCalendarUnitYMD];
    if (([startOfDay compare:self.firstDateMonth] == NSOrderedAscending) || ([startOfDay compare:self.lastDateMonth] == NSOrderedDescending)) {

        return;
    }
    
    
    [[self cellForItemAtDate:_selectedDate] setSelected:NO];
    [[self cellForItemAtDate:startOfDay] setSelected:YES];
    
    _selectedDate = startOfDay;
    
    NSIndexPath *indexPath = [self indexPathForCellAtDate:_selectedDate];
    [self.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
    
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:section];
    NSCalendarUnit weekCalendarUnit = [self weekCalendarUnitDependingOniOSVersion];
    NSRange rangeOfWeeks = [self.calendar rangeOfUnit:weekCalendarUnit inUnit:NSCalendarUnitMonth forDate:firstOfMonth];

    return (rangeOfWeeks.length * kDaysPerWeek);
}


- (NSCalendarUnit)weekCalendarUnitDependingOniOSVersion {

    if ([self.calendar respondsToSelector:@selector(isDateInToday:)]) {
        return NSCalendarUnitWeekOfMonth;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return NSWeekCalendarUnit;
#pragma clang diagnostic pop
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XWCalendarViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:XWCalendarViewCellIdentifier
                                                                                     forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];
    
    NSDateComponents *cellDateComponents = [self.calendar components:kCalendarUnitYMD fromDate:cellDate];
    NSDateComponents *firstOfMonthsComponents = [self.calendar components:kCalendarUnitYMD fromDate:firstOfMonth];
    
    BOOL isToday = NO;
    BOOL isSelected = NO;
    BOOL isCustomDate = NO;
    
    if (cellDateComponents.month == firstOfMonthsComponents.month) {
        isSelected = ([self isSelectedDate:cellDate] && (indexPath.section == [self sectionForDate:cellDate]));
        isToday = [self isTodayDate:cellDate];
        [cell setDate:cellDate calendar:self.calendar];

        
    } else {
        [cell setDate:nil calendar:nil];
    }
    
    if (isToday) {
        [cell setIsToday:isToday];
    }
    
    if (isSelected) {
        [cell setSelected:isSelected];
    }
    
    //If the current Date is not enabled, or if the delegate explicitely specify custom colors
    if (![self isEnabledDate:cellDate] || isCustomDate) {
        [cell refreshCellColors];
        cell.userInteractionEnabled = NO;
    }
    else {
        cell.userInteractionEnabled = YES;
    }
    
//    cell.layer.shouldRasterize = YES;
//    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];
    
    //We don't want to select Dates that are "disabled"
    if (![self isEnabledDate:cellDate]) {
        return NO;
    }
    
    NSDateComponents *cellDateComponents = [self.calendar components:NSCalendarUnitDay|NSCalendarUnitMonth fromDate:cellDate];
    NSDateComponents *firstOfMonthsComponents = [self.calendar components:NSCalendarUnitMonth fromDate:firstOfMonth];
    
    return (cellDateComponents.month == firstOfMonthsComponents.month);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDate = [self dateForCellAtIndexPath:indexPath];
    
    if (_delegate && [_delegate respondsToSelector:@selector(calendarView:didSelected:)]) {
        [_delegate calendarView:self didSelected:self.selectedDate];
    }
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = floorf(CGRectGetWidth(self.collectionView.bounds) / kDaysPerWeek);
    
    return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark -
#pragma mark - Calendar calculations

- (NSDate *)clampDate:(NSDate *)date toComponents:(NSUInteger)unitFlags
{
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:date];
    return [self.calendar dateFromComponents:components];
}

- (BOOL)isTodayDate:(NSDate *)date
{
    return [self clampAndCompareDate:date withReferenceDate:[NSDate date]];
}

- (BOOL)isSelectedDate:(NSDate *)date
{
    if (!self.selectedDate) {
        return NO;
    }
    return [self clampAndCompareDate:date withReferenceDate:self.selectedDate];
}

- (BOOL)isEnabledDate:(NSDate *)date
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendarView:isEnabledDate:)]) {
        return [_delegate calendarView:self isEnabledDate:date];
    }
    
    NSDate *clampedDate = [self clampDate:date toComponents:kCalendarUnitYMD];
    if (([clampedDate compare:self.firstDate] == NSOrderedAscending) || ([clampedDate compare:self.lastDate] == NSOrderedDescending)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)clampAndCompareDate:(NSDate *)date withReferenceDate:(NSDate *)referenceDate
{
    NSDate *refDate = [self clampDate:referenceDate toComponents:kCalendarUnitYMD];
    NSDate *clampedDate = [self clampDate:date toComponents:kCalendarUnitYMD];
    
    return [refDate isEqualToDate:clampedDate];
}

#pragma mark - Collection View / Calendar Methods

- (NSDate *)firstOfMonthForSection:(NSInteger)section
{
    NSDateComponents *offset = [NSDateComponents new];
    offset.month = section;
    
    return [self.calendar dateByAddingComponents:offset toDate:self.firstDateMonth options:0];
}

- (NSInteger)sectionForDate:(NSDate *)date
{
    return [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDateMonth toDate:date options:0].month;
}


- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    
    NSUInteger weekday = [[self.calendar components: NSCalendarUnitWeekday fromDate: firstOfMonth] weekday];
    NSInteger startOffset = weekday - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : kDaysPerWeek;
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = indexPath.item - startOffset;
    
    return [self.calendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
}


static const NSInteger kFirstDay = 1;
- (NSIndexPath *)indexPathForCellAtDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    NSInteger section = [self sectionForDate:date];
    NSDate *firstOfMonth = [self firstOfMonthForSection:section];
    
    NSInteger weekday = [[self.calendar components: NSCalendarUnitWeekday fromDate: firstOfMonth] weekday];
    NSInteger startOffset = weekday - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : kDaysPerWeek;
    
    NSInteger day = [[self.calendar components:kCalendarUnitYMD fromDate:date] day];
    
    NSInteger item = (day - kFirstDay + startOffset);
    
    return [NSIndexPath indexPathForItem:item inSection:section];
}

- (XWCalendarViewCell *)cellForItemAtDate:(NSDate *)date
{
    return (XWCalendarViewCell *)[self.collectionView cellForItemAtIndexPath:[self indexPathForCellAtDate:date]];
}

#pragma mark - PDTSimpleCalendarViewCellDelegate

- (BOOL)calendarViewCell:(XWCalendarViewCell *)cell shouldUseCustomColorsForDate:(NSDate *)date
{
    //If the date is not enabled (aka outside the first/lastDate) return YES
    if (![self isEnabledDate:date]) {
        return YES;
    }
    
    return NO;
}

- (UIColor *)calendarViewCell:(XWCalendarViewCell *)cell circleColorForDate:(NSDate *)date
{
    if (![self isEnabledDate:date]) {
        return cell.circleDefaultColor;
    }
    
 
    return nil;
}

- (UIColor *)calendarViewCell:(XWCalendarViewCell *)cell textColorForDate:(NSDate *)date
{
    if (![self isEnabledDate:date]) {
        return cell.textDisabledColor;
    }
    
    return nil;
}

- (UIFont *)titleFont
{
    if (_titleFont) return _titleFont;
    
    _titleFont = [UIFont systemFontOfSize:18];
    return _titleFont;
}

@end
