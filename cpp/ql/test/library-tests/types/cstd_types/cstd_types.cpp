typedef signed char        int8_t;
typedef short              int16_t;
typedef int                int32_t;
typedef long long          int64_t;
typedef unsigned char      uint8_t;
typedef unsigned short     uint16_t;
typedef unsigned int       uint32_t;
typedef unsigned long long uint64_t;

typedef signed char        int_least8_t;
typedef short              int_least16_t;
typedef int                int_least32_t;
typedef long long          int_least64_t;
typedef unsigned char      uint_least8_t;
typedef unsigned short     uint_least16_t;
typedef unsigned int       uint_least32_t;
typedef unsigned long long uint_least64_t;

typedef signed char        int_fast8_t;
typedef int                int_fast16_t;
typedef int                int_fast32_t;
typedef long long          int_fast64_t;
typedef unsigned char      uint_fast8_t;
typedef unsigned int       uint_fast16_t;
typedef unsigned int       uint_fast32_t;
typedef unsigned long long uint_fast64_t;

typedef long long          intmax_t;
typedef unsigned long long uintmax_t;

int8_t i8;
int16_t i16;
int32_t i32;
int64_t i64;
uint8_t ui8;
uint16_t ui16;
uint32_t ui32;
uint64_t ui64;
int_least8_t  l8;
int_least16_t l16;
int_least32_t l32;
int_least64_t l64;
uint_least8_t ul8;
uint_least16_t ul16;
uint_least32_t ul32;
uint_least64_t ul64;
int_fast8_t if8;
int_fast16_t if16;
int_fast32_t if32;
int_fast64_t if64;
uint_fast8_t uf8;
uint_fast16_t uf16;
uint_fast32_t uf32;
uint_fast64_t uf64;
intmax_t im;
uintmax_t uim;

enum E0 : int8_t {
    e0
};

enum class E1 : int8_t {
    e1
};

enum E2 {
    e2
};

enum class E3 {
    e3
};

E0 _e0;
E1 _e1;
E2 _e2;
E3 _e3; 