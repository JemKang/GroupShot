//
//  EffectList.cpp
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#include "EffectList.hpp"
EffectList::EffectList()
{
    GSGlobal = GSDefine::getGSDefine();
}
EffectList::~EffectList()
{
    release();
}
void EffectList::release()
{
    for(BaseEffect *effect:effects){
        SAFE_DELETE(effect);
    }
    effects.clear();
}
void EffectList::pushBack(BaseEffect *effect)
{
    this->effects.push_back(effect);
}
void EffectList::render(unsigned char *pData,int &width,int &height)
{
    for(BaseEffect *effect : effects){
        effect->render(pData, width, height);
    }
}
