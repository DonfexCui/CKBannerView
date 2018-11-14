//
//  CKBannerPageControlView.m
//  ckditu
//
//  Created by cjker on 2018/11/9.
//  Copyright © 2018年 ckditu. All rights reserved.
//

#import "CKBannerPageControlView.h"

@implementation CKBannerPageControlView

- (NSInteger)numberOfPages {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPagesForCKBannerPageControlView:)]) {
        return [self.delegate numberOfPagesForCKBannerPageControlView:self];
    }
    return 0;
}

- (void)reloadData {
    
}

@end
