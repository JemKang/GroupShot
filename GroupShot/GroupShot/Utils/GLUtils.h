#ifndef _FILTERONLINE_GLUTILS_H_
#define _FILTERONLINE_GLUTILS_H_

#include <stdio.h>
#include <stdlib.h>
#if defined(ANDROID) || defined(__ANDROID__)
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#endif

#if defined(TARGET_OS_IPHONE) || defined(TARGET_OS_MAC) || defined(__APPLE__)
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#endif

#if defined(_WIN32) || defined(_WIN32_) || defined(WIN32) || defined(_WIN64_) || defined(WIN64) || defined(_WIN64)
#include "../glsrc/GL/glut.h"
#endif

#define GL_CHECK() \
{ \
GLenum glError = glGetError(); \
if (glError != GL_NO_ERROR) {\
LOGE("glGetError() = %i (0x%.8x) in filename = %s, line  = %i\n", glError, glError, __FILE__ , __LINE__); \
} \
}

#define GL_DELETE_TEXTURE(x) if(x) { glDeleteTextures(1,&x); x = 0; }

#define GL_DELETE_PROGRAM(x) if(x) { glDeleteProgram(x); x = 0;}

#define GL_DELETE_FRAMEBUFFER(x) if(x) { glDeleteFramebuffers(1,&x); x = 0;}

#define GL_DELETE_RENDERBUFFER(x) if(x) { glDeleteRenderbuffers(1,&x); x = 0;}


#define INVALID_GLVALUE -1

#define INVALID_TEXTURE 0


namespace FilterOnline {
 
    GLuint LoadShader_Source(GLenum shaderType, const char* pSource);
    
    GLuint CreateTexture_WH(int width, int height);
    
    GLuint CreateProgram_Source(const char* pVertexSource, const char* pFragmentSource);
    
    GLuint CreateProgram_File(const char * vertex_file_path, const char * fragment_file_path, bool decode = false);
    
    GLuint LoadTexture_BYTE(GLubyte*  pdata, int width, int height, GLenum glFormat = GL_RGBA);
    
    GLuint LoadTexture_File(const char * imagepath, int *OutWidth = NULL, int *OutHeight = NULL);
    
    GLuint LoadTexture_Bitmap(GLubyte* pData,int& OutWidth, int& OutHeight);
    GLuint LoadTexture_Bitmap_Alpha(GLubyte* pData,int& OutWidth, int& OutHeight);
    
}
#endif
