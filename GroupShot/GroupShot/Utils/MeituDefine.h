#ifndef _H_MEITUDEFINE_H_
#define _H_MEITUDEFINE_H_
#include <cstdio>
#include <cstring>



//plaform
#if defined(_WIN32) || defined(_WIN32_) || defined(WIN32) || defined(_WIN64_) || defined(WIN64) || defined(_WIN64)
#define PLATFORM_WINDOWS 1
#elif defined(ANDROID) || defined(_ANDROID_)
#define PLATFORM_ANDROID 1
#elif defined(TARGET_OS_IPHONE) || defined(TARGET_OS_MAC)
#define PLATFORM_IOS	 1
#else
#define PLATFORM_UNKNOWN 1
#endif
//安全释放文件
#ifndef SAFE_DELETE
#define SAFE_DELETE(x) { if (x) delete (x); (x) = NULL; }	//定义安全释放函数
#endif

#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(x) { if (x) delete [] (x); (x) = NULL; }	//定义安全释放函数
#endif

#ifndef CLAMP2BYTE
#define CLAMP2BYTE(x) (unsigned char)((((unsigned short)x | ((short)(255 - x) >> 15)) & ~x >> 15));
#endif

//BGRA For PC & Android
#define MT_RED 0
#define MT_GREEN 1
#define MT_BLUE 2
#define MT_ALPHA 3

#ifndef NULL
#define NULL 0
#endif

typedef unsigned char BYTE;
typedef unsigned char byte;

#ifndef MAX
#define MAX(a,b) (((a) > (b)) ? (a) : (b))
#define MIN(a,b) (((a) < (b)) ? (a) : (b))
#endif

//#ifndef max
//#define max(a,b) (((a) > (b)) ? (a) : (b))
//#define min(a,b) (((a) < (b)) ? (a) : (b))
//#endif

#ifndef SC
#define SC(t,x) static_cast<t>(x)
#endif

#ifndef SC_INT
#define SC_INT(x) static_cast<int>(x)
#endif
#ifndef SC_FLOAT
#define SC_FLOAT(x) static_cast<float>(x)
#endif
#ifndef SC_BYTE
#define SC_BYTE(x) static_cast<BYTE>(x)
#endif
#ifndef SC_SHORT
#define SC_SHORT(x) static_cast<short>(x)
#endif

#ifndef NULL
#define NULL 0
#endif
#endif//_H_MEITUDEFINE_H_

#ifdef PLATFORM_ANDROID
//FDFA Hair 接口未定
#define MT_FDFA_HAIR_ANDROID_UNKNOWN 1
#endif
