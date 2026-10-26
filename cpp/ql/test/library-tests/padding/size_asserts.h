// Static assert macro
#define CASSERT(condition) typedef char cassertTypedef[((condition) != 0) ? 1 : -1]

#if defined(_MSC_VER)
#define CASSERT_MSVC(condition) CASSERT(condition)
#define CASSERT_GCC(condition)
#if defined(_WIN64)
#define TARGET_BIT_SIZE 64
#else
#define TARGET_BIT_SIZE 32
#endif
#elif defined(__GNUC__)
#define CASSERT_MSVC(condition)
#define CASSERT_GCC(condition) CASSERT(condition)
#if defined(__x86_64)
#define TARGET_BIT_SIZE 64
#else
#define TARGET_BIT_SIZE 32
#endif
#else
CASSERT(0);
#endif

#if defined(_MSC_VER) && (TARGET_BIT_SIZE == 32)
#define CASSERT_MSVC32(condition) CASSERT(condition)
#else
#define CASSERT_MSVC32(condition)
#endif

#if defined(_MSC_VER) && (TARGET_BIT_SIZE == 64)
#define CASSERT_MSVC64(condition) CASSERT(condition)
#else
#define CASSERT_MSVC64(condition)
#endif

#if defined(__GNUC__) && (TARGET_BIT_SIZE == 32)
#define CASSERT_GCC32(condition) CASSERT(condition)
#else
#define CASSERT_GCC32(condition)
#endif

#if defined(__GNUC__) && (TARGET_BIT_SIZE == 64)
#define CASSERT_GCC64(condition) CASSERT(condition)
#else
#define CASSERT_GCC64(condition)
#endif
