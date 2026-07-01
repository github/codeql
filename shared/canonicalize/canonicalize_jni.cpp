#ifdef _WIN32
#include <jni.h>
#include "canonicalize.h"

extern "C" {

JNIEXPORT jstring JNICALL
Java_com_semmle_util_files_NativeCanonicalizer_nativeCanonicalizePath(
    JNIEnv *env, jclass cls, jstring jpath) {

    const jchar* path = env->GetStringChars(jpath, nullptr);
    const wchar_t* result = canonicalize_path_w(reinterpret_cast<const wchar_t*>(path));
    env->ReleaseStringChars(jpath, path);

    if (result == nullptr) return nullptr;

    jstring jresult = env->NewString(
        reinterpret_cast<const jchar*>(result),
        static_cast<jsize>(wcslen(result)));
    canonicalize_free_w(result);
    return jresult;
}

} // extern "C"
#endif
