//
//  EffectBase.m
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import "EffectRender.h"
#import "MeituLog.h"
#include <string>
#include <vector>
#import "LutEffect.hpp"
#include "EffectList.hpp"
@interface EffectRender()
{
    EffectList effectList;
}
@end
@implementation EffectRender

- (void)loadConfig:(const char *)configPath
{
    std::string configuration = configPath;
    auto pos = configuration.find_last_of("/");
    std::string folder = configuration.substr(0,pos);
    effectList.GSGlobal->setFloder(folder);
    effectList.release();
    [self readFromPlist:configPath];
}
- (void)render:(unsigned char *)pData Width:(int)width Height:(int)height{
    effectList.render(pData, width, height);
}

- (bool)readFromPlist:(const char *)configPath
{
    //将plist文件中的步骤读到数组
    NSMutableDictionary* dicts = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithUTF8String:configPath]];
    NSArray * array = [dicts objectForKey:@"FilterPart"];
    if(array == nil){
        LOGE("Error: plist file Load failed");
        return false;
    }

    if(array.count <= 0){
        LOGE("Error: plist root array size <= 0")
        return false;
    }

    //遍历pilst文件步骤，读取到steplist中
    for(int i = 0; i < array.count; i++){
        NSDictionary* dict = [array objectAtIndex:i];
        NSString *sType = [dict objectForKey:@"Type"];
        std::string strType = [sType UTF8String];
        BaseEffect *baseEffect = NULL;
        if(strType == "Lut"){
             LutEffect *lut = new LutEffect();
             lut->imagePath = [[dict objectForKey:@"LutPath"] UTF8String];
             lut->lutSize = [[dict objectForKey:@"SIZE"] intValue];
             baseEffect = lut;
        }
        else if(strType == "Material"){
            
        }
        if(baseEffect != NULL){
            effectList.pushBack(baseEffect);
        }
    }
    return true;
}

@end
