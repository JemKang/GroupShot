//
//  EffectBase.h
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EffectRender : NSObject
- (void)loadConfig:(const char *)configPath;

- (void)render:(unsigned char *)pData Width:(int)width Height:(int)height;
@end

