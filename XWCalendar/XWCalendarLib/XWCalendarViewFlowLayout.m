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
        
        //Note: Item Size is defined using the delegate to take into account the width of the view and calculate size dynamically
    }
    
    return self;
}


@end
