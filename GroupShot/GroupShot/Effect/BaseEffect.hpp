//
//  BaseEffect.hpp
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#ifndef BaseEffect_hpp
#define BaseEffect_hpp

#include <stdio.h>
#include <string>
#include "GSDefine.hpp"
class BaseEffect{

public:
    BaseEffect();
    virtual ~BaseEffect();
    virtual void render(unsigned char *pData,int width,int height);
};
#endif /* BaseEffect_hpp */
