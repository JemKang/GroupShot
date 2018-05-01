#ifndef _H_MEITULOG_H_
#define _H_MEITULOG_H_

#define LOGI(format, ...) printf (format, ##__VA_ARGS__);printf ("\n");
#define LOGD(format, ...) printf (format, ##__VA_ARGS__);printf ("\n");
#define LOGE(format, ...) printf (format, ##__VA_ARGS__);printf ("\n");
//
//////////////////////////Android platform//////////////////////////////////////////////
//#if defined(ANDROID) || defined(__ANDROID__)
//#include <android/log.h>
//#define ENABLE_DEBUG
//#ifdef ENABLE_DEBUG
////Jni log tag
//#ifndef LOG_TAG
//#define LOG_TAG "glCaffe"
//#define LOG_GL(...) __android_log_print(ANDROID_LOG_INFO, "GL", __VA_ARGS__);
//#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__);
//#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__);
//#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__);
//#endif
//#else
//#ifndef LOGI
//#define LOG_GL(...)
//#define LOGI(...)
//#define LOGD(...)
//#define LOGE(...)
//#endif
//#endif //ENABLE_DEBUG
//
//#else
//////////////////////////////////Windows//////////////////////////////////////
////#include <windows.h>
//#include <stdio.h>
//#include <ctime>
////#ifdef _DEBUG
//#define LOGI(...) printf
//#define LOGD(...) printf
//#define LOGE(...) printf
//
////#define LOGI(...) SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY); \
////											fprintf(stderr,"%08d : ",clock());fprintf(stderr,__VA_ARGS__);fprintf(stderr,"\r\n");
////
////#define LOGD(...) SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_GREEN | FOREGROUND_BLUE |  FOREGROUND_INTENSITY); \
////											fprintf(stderr,"%08d : ",clock());fprintf(stderr,__VA_ARGS__);fprintf(stderr,"\r\n");
////
////#define LOGE(...) SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),FOREGROUND_RED |  FOREGROUND_INTENSITY); \
////										 fprintf(stderr,"%08d : ",clock());fprintf(stderr,__VA_ARGS__);fprintf(stderr,"\r\n%s(%d)\r\n",__FILE__,__LINE__);
////#else
////#define LOGI(...)
////#define LOGD(...)
////#define LOGE(...)
////#endif//_DEBUG
//
//#endif//defined(ANDROID) || defined(__ANDROID__)

#define LOG_START_FUNC() LOGD("++(%s)++",__FUNCTION__)

#define LOG_END_FUNC() LOGD("--(%s)--",__FUNCTION__)

#endif//_H_MEITULOG_H_
