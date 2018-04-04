//
//  MTCollectionView.m
//  MTEffectDemo
//
//  Created by kjh on 2018/3/15.
//  Copyright © 2018年 MeituTu. All rights reserved.
//

#import "MTCollectionView.h"

@implementation MTCollectionView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.frame = self.contentView.bounds;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.viewForFirstBaselineLayout.bounds];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 30, CGRectGetWidth(self.bounds), 30)];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
