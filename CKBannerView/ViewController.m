//
//  ViewController.m
//  CKBannerView
//
//  Created by cjker on 2018/11/14.
//  Copyright © 2018年 Cui Donfex. All rights reserved.
//

#import "ViewController.h"
#import "CKBannerView.h"

@interface ViewController ()<CKBannerViewDelegate>

@property (weak, nonatomic) IBOutlet CKBannerView *bannerView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSArray arrayWithObjects:@{@"title" : @"标题1", @"image" : @"banner_image_1.jpg"},
                                               @{@"title" : @"标题2", @"image" : @"banner_image_2.jpg"},
                                               @{@"title" : @"标题3", @"image" : @"banner_image_3.jpg"}, nil];
    [self.bannerView reloadData];
}

#pragma mark - CKBannerViewDelegate
- (NSInteger)totalPagesForBannerView:(CKBannerView *)bannerView {
    return self.dataArray.count;
}

- (id)itemDataForBannerView:(CKBannerView *)bannerView pageIndex:(NSInteger)pageIndex {
    return self.dataArray[pageIndex];
}

- (CGRect)pageControlViewFrameInBannerView:(CKBannerView *)bannerView {
    //可调整自定义的PageControl的位置 可不实现使用默认值
    [self.view layoutIfNeeded];
    return CGRectMake(16, self.bannerView.frame.size.height - 20, self.bannerView.frame.size.width - 16*2, 20);
}

- (void)clickedBannerViewItem:(NSInteger)pageIndex {
    
}

@end
