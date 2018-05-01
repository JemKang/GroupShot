
#include "GLUtils.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "MeituDefine.h"
#import "UIImage+ImageData.h"

#ifndef GL_CHANNLE_R
#define GL_CHANNLE_R 0
#endif

#ifndef GL_CHANNLE_G
#define GL_CHANNLE_G 1
#endif

#ifndef GL_CHANNLE_B
#define GL_CHANNLE_B 2
#endif

#ifndef GL_CHANNLE_A
#define GL_CHANNLE_A 3
#endif

//iOS平台使用GLUtils.mm

namespace FilterOnline
{
    GLuint LoadShader_Source(GLenum shaderType, const char* pSource){
        GLuint shader = glCreateShader(shaderType);
        if (shader) {
            glShaderSource(shader, 1, &pSource, NULL);
            glCompileShader(shader);
            GLint compiled = 0;
            glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
            if (!compiled) {
                GLint infoLen = 0;
                glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
                if (infoLen) {
                    char* buf = (char*)malloc(infoLen);
                    if (buf) {
                        glGetShaderInfoLog(shader, infoLen, NULL, buf);
                        NSLog(@"shader erro=%s",buf);
                        free(buf);
                        assert(false);
                    }
                    glDeleteShader(shader);
                    shader = 0;
                }
            }
        }
        return shader;
    }

    GLuint CreateProgram_Source(const char* pVertexSource, const char* pFragmentSource)
    {
        GLuint vertexShader = LoadShader_Source(GL_VERTEX_SHADER, pVertexSource);
        if (!vertexShader)
        {
            return 0;
        }
        GLuint pixelShader = LoadShader_Source(GL_FRAGMENT_SHADER, pFragmentSource);
        if (!pixelShader)
        {
            return 0;
        }
        
        GLuint program = glCreateProgram();
        if (program)
        {
            glAttachShader(program, vertexShader);
            
            glAttachShader(program, pixelShader);
            
            glLinkProgram(program);
            GLint linkStatus = GL_FALSE;
            glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
            if (linkStatus != GL_TRUE)
            {
                GLint bufLength = 0;
                glGetProgramiv(program, GL_INFO_LOG_LENGTH, &bufLength);
                if (bufLength)
                {
                    char* buf = (char*)malloc(bufLength);
                    if (buf)
                    {
                        glGetProgramInfoLog(program, bufLength, NULL, buf);
                        NSLog(@"error=%s",buf);
                        free(buf);
                        assert(false);
                    }
                }
                glDeleteProgram(program);
                program = 0;
            }
        }
        if (vertexShader)
        {
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        if (pixelShader)
        {
            glDeleteShader(pixelShader);
            pixelShader = 0;
        }
        
        return program;
    }

    GLuint LoadTexture_BYTE(GLubyte*  pdata, int width, int height, GLenum glFormat)
    {
        GLuint textures;
        glGenTextures(1, &textures);
        if (textures != 0)
        {
            glBindTexture(GL_TEXTURE_2D, textures);
            
            if(glFormat != GL_LUMINANCE)
            {
                if (glFormat == GL_ALPHA)
                {
                    int noffset = width%4;
                    int w = width;
                    if (noffset !=0)
                    {
                        w = width + 4-noffset;
                    }
                    
                    GLubyte*  pRes = new GLubyte[w*height];
                    GLubyte* pTmp = pRes;
                    for (int j=0; j<height; j++)
                    {
                        for (int i=0; i<width; i++)
                        {
                            pTmp[i] = pdata[i];
                        }
                        pTmp += w;
                        pdata += width;
                    }
                    
                    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, pRes);
                    SAFE_DELETE_ARRAY(pRes);
                }
                else
                {
                    glTexImage2D(GL_TEXTURE_2D, 0, glFormat, width, height, 0, glFormat, GL_UNSIGNED_BYTE, pdata);
                }
            }
            else
            {
                GLubyte*  pRes = new GLubyte[width*height*4];
                GLubyte* pTmp = pRes;
                int nCount = width*height;
                for(int i = 0 ;i < nCount;i++)
                {
                    pTmp[0] = pTmp[1] = pTmp[2] = pdata[i];
                    pTmp[3] = 255;
                    pTmp+=4;
                }
                glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pRes);
                
                SAFE_DELETE_ARRAY(pRes);
            }
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            return textures;
        }
        else
        {
            NSLog(@"ERROR in loadTexture!");
            return 0;
        }
    }

    static char *file2string(const char *path, bool decode = true)
    {
        NSString* fileName = [NSString stringWithUTF8String:path];
        NSString * bundleMain = [[NSBundle mainBundle] resourcePath];
        NSString *fileLocation = [NSString stringWithFormat:@"%@/%@",bundleMain,fileName];
        
        FILE *file = NULL;
        file = fopen([fileLocation UTF8String],"r");
        
        if(file == NULL)
        {
            NSString* tempString = [[NSString alloc] initWithUTF8String:path];
            fileLocation = [[NSBundle mainBundle] pathForResource:tempString ofType:@"" inDirectory:@"MTFilterScript.bundle"];
            file = fopen([fileLocation UTF8String],"r");
        }
        
        if (file == NULL) {
            return nullptr;
        }
        
        fseek(file,0,SEEK_END);
        long len = ftell(file) + 1;
        char* str = new char[len];
        memset(str,0,len);
        if(str == NULL)
        {
            return NULL;
        }
        fseek(file,0,SEEK_SET);
        fread(str,len,1,file);
        fclose(file);
        return str;

    }


    GLuint CreateTexture_WH(int width, int height)
    {
        GLuint textureID;
        glGenTextures(1, &textureID);
        if (textureID == 0)
        {
            return 0;
        }
        glBindTexture(GL_TEXTURE_2D, textureID);
        //unsigned char* pData = (unsigned char*)malloc(width*height*4);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
        //free(pData);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        return textureID;
    }

    GLuint CreateProgram_File(const char * vertex_file_path, const char * fragment_file_path, bool decode){
        
        // Read the Vertex Shader code from the file
        char *VertexShaderCode = file2string(vertex_file_path, decode);
        
        if (NULL == VertexShaderCode) {
            
            return 0;
        }
        // Read the Fragment Shader code from the file
        char *FragmentShaderCode = file2string(fragment_file_path, decode);
        
        if (NULL == FragmentShaderCode) {
            
            free(VertexShaderCode);
            return 0;
        }
        
        GLuint ProgramID = CreateProgram_Source(VertexShaderCode, FragmentShaderCode);
        
        free(FragmentShaderCode);
        free(VertexShaderCode);
        
        return ProgramID;
    }

    GLuint LoadTexture_UIImage(UIImage* image, int *OutWidth, int *OutHeight)
    {
        if (image==nil) {
            return INVALID_TEXTURE;
        }
        GLsizei width       = image.size.width;
        GLsizei height      = image.size.height;
        
        *OutWidth  = image.size.width;
        *OutHeight = image.size.height;
        
        if (width<=0||height<=0) {
            return INVALID_TEXTURE;
        }
        
        CGImageAlphaInfo info = CGImageGetAlphaInfo(image.CGImage);
        BOOL hasAlpha = ((info == kCGImageAlphaPremultipliedLast) ||
                         (info == kCGImageAlphaPremultipliedFirst) ||
                         (info == kCGImageAlphaLast) ||
                         (info == kCGImageAlphaFirst) ? YES : NO);
        
        // allocate memory for the bitmap context we will draw the image into
        GLubyte* textureData = (GLubyte*) calloc(width * height * 4, sizeof(GLubyte));
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        
        // We are going to force the source data to RGB space in the event it was some other color space
        CGContextRef textureContext = CGBitmapContextCreate(textureData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
        if (hasAlpha == YES)
        {
            CGContextSetRGBFillColor(textureContext, 1.0, 1.0, 1.0, 1.0);
            CGContextFillRect(textureContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height));
        }
        // We are going to use pre-multiplied data. Our later processing may need to account for this when manipulating RGB values
        CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), image.CGImage);
        // Draw the image into the bitmap context
        CGContextRelease(textureContext);
        if (hasAlpha == YES)
        {
            BYTE array[256][256] = {0};
            for (int j=1; j<256; j++)
            {
                for (int i=0; i<256; i++)
                {
                    array[j][i] = MIN(MAX(0,(j+i-255)*255.0/i+0.5),255);
                }
            }
            GLubyte* alphaData = (GLubyte*) calloc(width * height, sizeof(GLubyte));
            CGContextRef alphaContext = CGBitmapContextCreate(alphaData, width, height, 8, width, NULL, kCGImageAlphaOnly);
            CGContextDrawImage(alphaContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), image.CGImage);
            // Draw the image into the bitmap context
            CGContextRelease(alphaContext);
            GLubyte* pDest = textureData;
            GLubyte* alphaTemp = alphaData;
            for (int j=0; j<height; j++)
            {
                for (int i=0; i<width; i++)
                {

                    //自己反计算回原来的alpha值
                    pDest[GL_CHANNLE_R] = array[pDest[GL_CHANNLE_R]][alphaTemp[0]];
                    pDest[GL_CHANNLE_G] = array[pDest[GL_CHANNLE_G]][alphaTemp[0]];
                    pDest[GL_CHANNLE_B] = array[pDest[GL_CHANNLE_B]][alphaTemp[0]];
                
                    pDest[GL_CHANNLE_A] = alphaTemp[0];
                    pDest += 4;
                    alphaTemp++;
                }
            }
            
            free(alphaData);
            
            
            
        }
        GLuint textureName;
        glGenTextures(1, &textureName);
        glBindTexture(GL_TEXTURE_2D, textureName);
        // Get a texture name and bind it as the current 2D texture in the GL state
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
        // copy the bitmap data backing the CGBitmapContext over to GL into the texture we have bound
        //    NSLog(@"textureData=%d,%d,%d,%d",textureData[0],textureData[1],textureData[2],textureData[3]);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        // depending on your application, you may want different scaling filters for the source texture
        // for instance you may want scaling to produce a pixelated zoom instead of smoothing
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        // GL_CLAMP_TO_EDGE means that samples beyond the texture bounds will be replicated edge pixels
        // this mode is required to use textures that are not powers for two in size.
        
        CGColorSpaceRelease(colorSpace);
        
        free(textureData);
        
        
        return textureName;
    }
        
    GLuint LoadTexture_File(const char* imagePath, int *OutWidth, int *OutHeight)
    {
        
        NSString* fileName = [NSString stringWithUTF8String:imagePath];
        NSString * bundleMain = [[NSBundle mainBundle] resourcePath];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString *fileLocation = fileName;
        if ([fileManager fileExistsAtPath:fileLocation] == NO) {
            fileLocation = [NSString stringWithFormat:@"%@/%@",bundleMain,fileName];
        }
        
        UIImage* pImage = [[UIImage alloc] initWithContentsOfFile:fileLocation];
        
        GLuint nReturn = LoadTexture_UIImage(pImage, OutWidth, OutHeight);
        
        return nReturn;

    }
        
    GLuint LoadTexture_Bitmap(GLubyte* pData,int& OutWidth, int& OutHeight )
    {
        GLuint res = LoadTexture_BYTE(pData,OutWidth,OutHeight,GL_RGBA);
        return res;
    }
    GLuint LoadTexture_Bitmap_Alpha(GLubyte* pData,int& OutWidth, int& OutHeight)
    {
        GLuint res = LoadTexture_BYTE(pData,OutWidth,OutHeight,GL_ALPHA);
        return res;
    }

}
