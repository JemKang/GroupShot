//
//  LutEffect.hpp
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#ifndef LutEffect_hpp
#define LutEffect_hpp
#include <string>
#include <stdio.h>
#include "BaseEffect.hpp"
#include "MeituDefine.h"
class LutEffect : public BaseEffect{
public:
    enum{
      SIZE_16 = 16,
      SIZE_32 = 32,
      SIZE_64 = 64
    }LUTSIZE;
    LutEffect();
    virtual ~LutEffect();
    virtual void render(unsigned char *pData,int width,int height);
    int lutSize;
    std::string fs;
    std::string vs;
    std::string imagePath;
};
#endif /* LutEffect_hpp */
