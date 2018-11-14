//
//  CKBannerView.m
//  ckditu
//
//  Created by cjker on 2018/11/9.
//  Copyright © 2018年 ckditu. All rights reserved.
//

#import "CKBannerView.h"
#import "CKBannerItemView.h"
#import "CKBannerPageControlView.h"

#define NSStringIsNullOrEmpty(str) (str==nil || str.length==0)

@interface CKBannerView ()<UIScrollViewDelegate, CKBannerPageControlViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CKBannerPageControlView *pageControl;
@property (nonatomic, strong) CKBannerItemView *currentItem;
@property (nonatomic, strong) CKBannerItemView *previousItem;
@property (nonatomic, strong) CKBannerItemView *nextItem;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL hasCreated;

@end

@implementation CKBannerView

- (instancetype)initWithFrame:(CGRect)frame itemClassName:(NSString *)itemClassName {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRootView];
        [self initialize:itemClassName];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRootView];
    }
    return self;
}

- (void)initRootView {
    NSString*nibPath = [[NSBundle mainBundle]pathForResource:NSStringFromClass([self class]) ofType:@"nib"];
    if (nibPath == nil) return;
    
    UIView *rootView = (UIView *)[[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    rootView.frame = self.bounds;
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:rootView];
}

- (void)setItemClassName:(NSString *)itemClassName {
    _itemClassName = itemClassName;
    [self initialize:itemClassName];
}

- (void)initialize:(NSString *)itemClassName {
    if (self.hasCreated) return;
    
    if (NSStringIsNullOrEmpty(itemClassName)) {
#if DEBUG
        NSException *excp = [NSException exceptionWithName:@"Need an item class name!" reason:@"Need an item class name that inherits 'CKBannerView'!!!" userInfo:nil];
        [excp raise];
#endif
        return;
    }
    
    Class c = NSClassFromString(itemClassName);
    if (![c isSubclassOfClass:[CKBannerItemView class]]) return;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.pageIndex = 0;
    self.currentItem = [[c alloc]initWithFrame:[self getCurrentImageFrame]];
    self.currentItem.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(currentItemClicked:)];
    [self.currentItem addGestureRecognizer:tap];
    
    self.previousItem = [[c alloc]initWithFrame:[self getPreviousImageFrame]];
    self.nextItem = [[c alloc]initWithFrame:[self getNextImageFrame]];
    [self.scrollView addSubview:self.previousItem];
    [self.scrollView addSubview:self.currentItem];
    [self.scrollView addSubview:self.nextItem];
    [self reloadData];
    [self resetTimer];
    
    self.hasCreated = YES;
}

- (void)setPageControlClassName:(NSString *)pageControlClassName {
    _pageControlClassName = pageControlClassName;
    
    if (NSStringIsNullOrEmpty(pageControlClassName)) return;
    
    Class c = NSClassFromString(pageControlClassName);
    if (![c isSubclassOfClass:[CKBannerPageControlView class]]) return;
    
    if (self.pageControl == nil) {
        self.pageControl = [[c alloc]initWithFrame:[self pageControlViewFrame]];
        self.pageControl.delegate = self;
    }
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
    [self updateFrame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        [self cancelTimer];
    }
}

- (NSInteger)totalPages {
    return [self.delegate totalPagesForBannerView:self];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    
    self.pageControl.currentPageIndex = pageIndex;
}

- (void)reloadData {
    if (self.totalPages != 0) {
        self.pageIndex = 0;
        [self updateFrame];
        [self updateBannerView];
        [self.pageControl reloadData];
    }else {
        self.scrollView.contentSize = CGSizeMake(0, 0);
        self.pageControl.hidden = YES;
    }
    
}

- (void)resetTimer {
    [self cancelTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerLooper) userInfo:nil repeats:YES];
}

- (void)timerLooper {
    [self resetBannerImageLocation];
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.nextItem.frame.origin.x, self.nextItem.frame.origin.y);
    }completion:^(BOOL finished) {
        self.pageIndex = self.pageIndex+1 > self.totalPages-1 ? 0 : self.pageIndex+1;
        [self resetBannerImageLocation];
        [self updateBannerView];
    }];
}

- (void)cancelTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateFrame {
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    self.previousItem.frame = [self getPreviousImageFrame];
    self.currentItem.frame = [self getCurrentImageFrame];
    self.nextItem.frame = [self getNextImageFrame];
    self.pageControl.frame = [self pageControlViewFrame];
    [self resetBannerImageLocation];
}

- (CGRect)pageControlViewFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageControlViewFrameInBannerView:)]) {
        return [self.delegate pageControlViewFrameInBannerView:self];
    }
    return CGRectMake(16, self.frame.size.height - 20, self.frame.size.width - 16*2, 20);
}

- (CGRect)getCurrentImageFrame {
    return CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}

- (CGRect)getPreviousImageFrame {
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (CGRect)getNextImageFrame {
    return CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
}

- (void)resetBannerImageLocation {
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

- (void)updateBannerView {
    if (self.totalPages == 0 || self.pageIndex > self.totalPages - 1) return;
    
    NSInteger currentPageIndex = self.pageIndex;
    NSInteger previousPageIndex = self.pageIndex-1 < 0 ? self.totalPages-1 : self.pageIndex-1;
    NSInteger nextPageIndex = self.pageIndex+1 > self.totalPages-1 ? 0 : self.pageIndex+1;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemDataForBannerView:pageIndex:)]) {
        [self.currentItem updateWithItemData:[self.delegate itemDataForBannerView:self pageIndex:currentPageIndex]];
        [self.previousItem updateWithItemData:[self.delegate itemDataForBannerView:self pageIndex:previousPageIndex]];
        [self.nextItem updateWithItemData:[self.delegate itemDataForBannerView:self pageIndex:nextPageIndex]];
    }
}

- (void)currentItemClicked:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedBannerViewItem:)]) {
        [self.delegate clickedBannerViewItem:self.pageIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
        if (page == 1) return;
        
        if (page > 1) {
            self.pageIndex = self.pageIndex+1 > self.totalPages-1 ? 0 : self.pageIndex+1;
        }else {
            self.pageIndex = self.pageIndex-1 < 0 ? self.totalPages-1 : self.pageIndex-1;
        }
        [self resetBannerImageLocation];
        [self updateBannerView];
        [self resetTimer];
    }
}

#pragma mark - CKBannerPageControlViewDelegate
- (NSInteger)numberOfPagesForCKBannerPageControlView:(CKBannerPageControlView *)view {
    return [self totalPages];
}

@end
