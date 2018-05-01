//
//  PublicFunction.h
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#ifndef PublicFunction_h
#define PublicFunction_h
const char *getEffectBundle();
unsigned char*loadImageData(const char *filePath,int &width,int &height);
bool setContext();
void loadRGBADataToUIImage(unsigned char*pData,int width,int height);
#endif /* PublicFunction_h */
