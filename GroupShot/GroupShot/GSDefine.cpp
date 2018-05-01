//
//  GSDefine.cpp
//  GroupShot
//
//  Created by kjh on 2018/4/3.
//  Copyright © 2018年 kjh. All rights reserved.
//

#include "GSDefine.hpp"
GSDefine* GSDefine::GSGlobal = new GSDefine();
GSDefine::GSDefine(){
    
}
GSDefine::~GSDefine()
{
    SAFE_DELETE(GSGlobal);
}
GSDefine* GSDefine::getGSDefine()
{
    if(GSGlobal == NULL){
        GSGlobal = new GSDefine();
    }
    return GSGlobal;
}
void GSDefine::setFloder(std::string folder)
{
    this->_folder = folder;
}
std::string& GSDefine::getFloder()
{
    return this->_folder;
}
