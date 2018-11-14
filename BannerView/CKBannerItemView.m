//
//  CKBannerItemView.m
//  ckditu
//
//  Created by cjker on 2018/11/9.
//  Copyright © 2018年 ckditu. All rights reserved.
//

#import "CKBannerItemView.h"

@implementation CKBannerItemView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRootView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRootView];
    }
    return self;
}

- (instancetype)init:(CGRect)frame {
    self = [super init];
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

- (void)updateWithItemData:(id)itemData {
    
}

@end
