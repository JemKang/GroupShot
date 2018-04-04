//
//  MTCollectionView.h
//  MTEffectDemo
//
//  Created by kjh on 2018/3/15.
//  Copyright © 2018年 MeituTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
@interface MTCollectionView : UICollectionViewCell
- (UIImageView *)imageView;
- (UILabel *)titleLabel;
@property (nonatomic, strong) UIImageView *imageView;//显示图片
@property (nonatomic,retain)UILabel *titleLabel; // 显示文字
@end
