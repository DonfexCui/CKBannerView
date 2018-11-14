//
//  CKBannerPageControlView.h
//  ckditu
//
//  Created by cjker on 2018/11/9.
//  Copyright © 2018年 ckditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKBannerPageControlView;
@protocol CKBannerPageControlViewDelegate <NSObject>

@optional
- (NSInteger)numberOfPagesForCKBannerPageControlView:(CKBannerPageControlView *)view;

@end

@interface CKBannerPageControlView : UIView

@property (nonatomic, weak) id <CKBannerPageControlViewDelegate>delegate;
@property (nonatomic, assign) NSInteger currentPageIndex;

- (NSInteger)numberOfPages;
- (void)reloadData;

@end
