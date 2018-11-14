//
//  CustomBannerItemView.m
//  ckditu
//
//  Created by cjker on 2018/11/9.
//  Copyright © 2018年 ckditu. All rights reserved.
//

#import "CustomBannerItemView.h"

@interface CustomBannerItemView()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

@end

@implementation CustomBannerItemView

- (void)updateWithItemData:(id)itemData {
    if (![itemData isKindOfClass:[NSDictionary class]]) return;
    NSDictionary *item = (NSDictionary *)itemData;
    
    self.itemImageView.image = [UIImage imageNamed:item[@"image"]];
    self.itemTitleLabel.text = item[@"title"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.maskView layoutIfNeeded];
    [self setShadowForView:self.maskView StartColor:[UIColor colorWithWhite:0 alpha:1] shadowEndColor:[UIColor colorWithWhite:0 alpha:0] layerName:@"bottom_maskView"];
}

- (void)setShadowForView:(UIView *)view StartColor:(UIColor *)startColor shadowEndColor:(UIColor *)endColor layerName:(NSString *)layerName{
    layerName = [NSString stringWithFormat:@"shadow_%@",layerName];
    CAGradientLayer *gradient;
    for (CAGradientLayer *layer in view.layer.sublayers) {
        if ([layer.name isEqualToString:layerName]) {
            gradient = layer;
            break;
        }
    }
    if (!gradient) {
        gradient = [CAGradientLayer layer];
        gradient.name = layerName;
        [view.layer insertSublayer:gradient atIndex:0];
    }
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor.CGColor,(id)endColor.CGColor, nil];
    gradient.startPoint = CGPointMake(0, 1);
    gradient.endPoint = CGPointMake(0, 0);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
}

@end
