#ifndef CODEQL_CANONICALIZE_H
#define CODEQL_CANONICALIZE_H

#ifdef _WIN32

#ifdef CODEQL_CANONICALIZE_EXPORTS
#define CODEQL_API __declspec(dllexport)
#else
#define CODEQL_API __declspec(dllimport)
#endif

#include <wchar.h>

#ifdef __cplusplus
extern "C" {
#endif

// UTF-16 interface (for JNI / Java / Kotlin)
CODEQL_API const wchar_t* canonicalize_path_w(const wchar_t* path);
CODEQL_API void canonicalize_free_w(const wchar_t* path);

// UTF-8 interface (for Go)
CODEQL_API const char* canonicalize_path_u8(const char* path);
CODEQL_API void canonicalize_free_u8(const char* path);

#ifdef __cplusplus
}
#endif

#endif // _WIN32
#endif // CODEQL_CANONICALIZE_H
