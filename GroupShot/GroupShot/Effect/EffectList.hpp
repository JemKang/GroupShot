//
//  EffectList.hpp
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#ifndef EffectList_hpp
#define EffectList_hpp

#include <stdio.h>
#include "GSDefine.hpp"
#include "BaseEffect.hpp"
#include <vector>
class EffectList{
public:
    EffectList();
    ~EffectList();
    std::vector<BaseEffect *> effects;
    GSDefine *GSGlobal;
    void render(unsigned char *pData,int &width,int &height);
    void release();
    void pushBack(BaseEffect *effect);
};
#endif /* EffectList_hpp */
