//
//  XWCalendarViewFlowLayout.m
//  XWCalendar
//
//  Created by zengchao on 16/5/25.
//  Copyright © 2016年 zengchao. All rights reserved.
//

#import "XWCalendarViewFlowLayout.h"

@implementation XWCalendarViewFlowLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = XWCalendarFlowLayoutMinInterItemSpacing;
        self.minimumLineSpacing = XWCalendarFlowLayoutMinLineSpacing;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(XWCalendarFlowLayoutInsetTop,
                                             XWCalendarFlowLayoutInsetLeft,
                                             XWCalendarFlowLayoutInsetBottom,
                                             XWCalendarFlowLayoutInsetRight);
        self.headerReferenceSize = CGSizeMake(0, XWCalendarFlowLayoutHeaderHeight);
    }
    
    return self;
}


@end
