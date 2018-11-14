//
//  CustomBannerPageControlView.m
//  ckditu
//
//  Created by cjker on 2018/11/9.
//  Copyright © 2018年 ckditu. All rights reserved.
//

#import "CustomBannerPageControlView.h"

#define ITEM_SPACING 3

@interface CustomBannerPageControlView()

@property (nonatomic, strong) NSMutableArray *viewsArray;

@end

@implementation CustomBannerPageControlView

- (void)reloadData {
    NSInteger pages = [self numberOfPages];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewsArray removeAllObjects];
    
    CGFloat viewW = (self.frame.size.width - (pages - 1) * ITEM_SPACING) / pages;
    CGFloat viewH = 2;
    CGFloat viewX = 0;
    CGFloat viewY = (self.frame.size.height - viewH) / 2;
    for (int i=0; i<pages; i++) {
        viewX = (viewW + ITEM_SPACING) * i;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        if (i == 0) {
            view.backgroundColor = [UIColor whiteColor];
        }else {
            view.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5];
        }
        view.layer.cornerRadius = 1;
        [self addSubview:view];
        [self.viewsArray addObject:view];
    }
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    for (int i=0; i<self.viewsArray.count; i++) {
        UIView *view = self.viewsArray[i];
        if (i == currentPageIndex) {
            view.backgroundColor = [UIColor whiteColor];
        }else {
            view.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.5];
        }
    }
}

- (NSMutableArray *)viewsArray {
    if (_viewsArray == nil) {
        _viewsArray = [NSMutableArray arrayWithCapacity:[self numberOfPages]];
    }
    return _viewsArray;
}

@end
