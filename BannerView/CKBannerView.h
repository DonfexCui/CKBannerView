//
//  CKBannerView.h
//  ckditu
//
//  Created by cjker on 2018/11/9.
//  Copyright © 2018年 ckditu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKBannerView;
@protocol CKBannerViewDelegate <NSObject>

@required
- (NSInteger)totalPagesForBannerView:(CKBannerView *)bannerView;

@optional
- (void)clickedBannerViewItem:(NSInteger)pageIndex;
- (id)itemDataForBannerView:(CKBannerView *)bannerView pageIndex:(NSInteger)pageIndex;
- (CGRect)pageControlViewFrameInBannerView:(CKBannerView *)bannerView;

@end

@interface CKBannerView : UIView

@property (nonatomic, strong) IBInspectable NSString *itemClassName;
@property (nonatomic, strong) IBInspectable NSString *pageControlClassName;
@property (nonatomic, weak) IBOutlet id <CKBannerViewDelegate>delegate;

- (void)reloadData;
- (instancetype)initWithFrame:(CGRect)frame itemClassName:(NSString *)itemClassName;

@end
