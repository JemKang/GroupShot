//
//  LutEffect.cpp
//  GroupShot
//
//  Created by kjh on 2018/4/27.
//  Copyright © 2018年 kjh. All rights reserved.
//

#include "LutEffect.hpp"
#include "GLUtils.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#include "MeituLog.h"
#include "PublicFunction.h"
#include "GSDefine.hpp"
LutEffect::LutEffect()
{
    lutSize = SIZE_16;
    fs = "";
    vs = "resource/shader/shader.vs";
    imagePath = "";
}
LutEffect::~LutEffect()
{

}
void LutEffect::render(unsigned char *pData,int width,int height)
{

    if(!setContext()){
        LOGE("Failed to set current OpenGL context");
        return;
    }
    if(lutSize == SIZE_16){
        fs = "resource/shader/lut_16.fs";
    }
    else if(lutSize == SIZE_32){
        fs = "resource/shader/lut_32.fs";
    }
    else if(lutSize == SIZE_64){
        fs = "resource/shader/lut_64.fs";
    }
    GLuint m_ProgramHandle = FilterOnline::CreateProgram_File(vs.c_str(),fs.c_str());
    GLuint inputImageTextureID = FilterOnline::LoadTexture_BYTE(pData, width, height);//创建纹理
    
    int m_TextureWidth,m_TextureHeight;
    std::string imagePath_lut = GSDefine::getGSDefine()->getFloder() + "/" + imagePath;
    
    GLuint texture2 = FilterOnline::LoadTexture_File(imagePath_lut.c_str(), &m_TextureWidth, &m_TextureHeight);//基准图创建纹理
    unsigned char*m_PixelBuffer = new unsigned char[width * height << 2];
    
    GLuint frameBuffeTextureID = FilterOnline::CreateTexture_WH(width, height);
    GLuint _framebuffer;
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER,_framebuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, frameBuffeTextureID, 0);
    GLfloat vertexs[8] = {-1.000000,-1.000000,1.000000,-1.000000,-1.000000,1.000000,1.000000,1.000000};
    
    GLfloat texcoords[8] ={ 0.000000,0.000000,1.000000,0.000000,0.000000,1.000000,1.000000,1.000000};
    if(m_ProgramHandle > 0)
    {
        glUseProgram(m_ProgramHandle);
        GLuint position = glGetAttribLocation(m_ProgramHandle, "position");
        GLuint inputTextureCoordinate = glGetAttribLocation(m_ProgramHandle, "inputTextureCoordinate");
        GLuint inputImageTexture =  glGetUniformLocation(m_ProgramHandle,"inputImageTexture");//
        GLuint inputImageTexture2 = glGetUniformLocation(m_ProgramHandle,"mt_tempData1");//
        GLuint alpha =  glGetUniformLocation(m_ProgramHandle,"alpha");//
        glViewport(0,0,width,height);
        glClear(GL_COLOR_BUFFER_BIT);
        glClearColor(0.000000,0.000000,0.000000,1.000000);
        glUniform1f(alpha,1.000000);
        //纹理绑定
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D,inputImageTextureID);
        glUniform1i(inputImageTexture,0);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D,texture2);
        glUniform1i(inputImageTexture2,1);
        glEnableVertexAttribArray(position);
        glVertexAttribPointer(position,2,GL_FLOAT,GL_FALSE,0,vertexs);
        glEnableVertexAttribArray(inputTextureCoordinate);
        glVertexAttribPointer(inputTextureCoordinate,2,GL_FLOAT,GL_FALSE,0,texcoords);
        glDrawArrays(GL_TRIANGLE_STRIP,0,4);
        //获取渲染后的像素
        glReadPixels(0,0,width,height,GL_RGBA,GL_UNSIGNED_BYTE,m_PixelBuffer);
    }
    loadRGBADataToUIImage(m_PixelBuffer,width,height);
    
    memcpy(pData,m_PixelBuffer,width * height * 4);
    SAFE_DELETE_ARRAY(m_PixelBuffer);
}
