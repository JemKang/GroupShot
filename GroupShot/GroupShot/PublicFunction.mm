//
//  PublicFunction.m
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+ImageData.h"
const char *getEffectBundle()
{
    static char path[500] = {0};
    if (path[0] == 0)
    {
        NSString* bundlePath = [[NSBundle mainBundle] resourcePath];
        sprintf(path, "%s/Assert.bundle",[bundlePath UTF8String]);
    }
    
    return path;
}
unsigned char *loadImageData(const char *filePath,int &width,int &height)
{
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithUTF8String:filePath]];
    unsigned char *pData = [image RGBAData];
    width = image.size.width;
    height = image.size.height;
    return pData;
}
bool setContext()
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
    EAGLContext* _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 3.0 context");
        return false;
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        return false;
    }
    return true;
}
void loadRGBADataToUIImage(unsigned char*pData,int width,int height)
{
    UIImage *image = [UIImage imageWithRGBAData:pData withWidth:width withHeight:height];
    if(image){
        return;
    }
}
