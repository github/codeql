#include "size_asserts.h"

CASSERT_MSVC(sizeof(long) == 4);
CASSERT_GCC(sizeof(long) == sizeof(void*));

struct Integers_Packed
{
// 0
    unsigned long long ull;
// 8
    long long ll;
// 16
    unsigned long ul;
// 24(GCC64); 20(GCC32, MSVC)
    long l;
// 32(GCC64); 24(GCC32, MSVC)
    unsigned int ui;
// 36(GCC64); 28(GCC32, MSVC)
    int i;
// 40(GCC64); 32(GCC32, MSVC)
    unsigned short us;
// 42(GCC64); 34(GCC32, MSVC)
    short s;
// 44(GCC64); 36(GCC32, MSVC)
    unsigned char uc;
// 45(GCC64); 37(GCC32, MSVC)
    signed char sc;
// 46(GCC64); 38(GCC32, MSVC)
    char c;
// 47(GCC64); 39(GCC32, MSVC)
// Pad 1
// 48(GCC64); 40(GCC32, MSVC)
};
CASSERT_MSVC(sizeof(struct Integers_Packed) == 40);
CASSERT_GCC32(sizeof(struct Integers_Packed) == 40);
CASSERT_GCC64(sizeof(struct Integers_Packed) == 48);

struct Integers_Assorted
{
// 0
    char c1;
// Pad 7(GCC64, MSVC); 3(GCC32)
// 8(GCC64, MSVC); 4(GCC32)
    long long ll1;
// 16(GCC64, MSVC); 12(GCC32)
    char c2;
// 17(GCC64, MSVC); 13(GCC32)
//  Pad 7(GCC64); 3(GCC32, MSVC)
// 24(GCC64); 20(MSVC); 16(GCC32)
    long l2;
// 32(GCC64); 24(MSVC); 20(GCC32)
    char c3;
// 33(GCC64); 25(MSVC); 21(GCC32)
// Pad 3
// 36(GCC64); 28(MSVC); 24(GCC32)
    int i3;
// 40(GCC64); 32( MSVC); 28(GCC32)
    char c4;
// 41(GCC64); 33(MSVC); 29(GCC32)
// Pad 1
// 42(GCC64); 34(MSVC); 30(GCC32)
    short s4;
// 44(GCC64); 36(MSVC); 32(GCC32)
    char c5;
// 45(GCC64); 37(MSVC); 33(GCC32)
    unsigned char uc5;
// 46(GCC64); 38(MSVC); 34(GCC32)
// Pad 2
// 48(GCC64); 40(MSVC); 36(GCC32)
};
CASSERT_MSVC(sizeof(struct Integers_Assorted) == 40);
CASSERT_GCC32(sizeof(struct Integers_Assorted) == 36);
CASSERT_GCC64(sizeof(struct Integers_Assorted) == 48);

struct Floats_Packed
{
// 0
    long double ld;
// 16(GCC64); 12(GCC32); 8(MSVC)
    double d;
// Pad 4(GCC32); 0(GCC64, MSVC)
// 24(GCC64); 16(GCC32, MSVC)
    float f;
// 28(GCC); 20(GCC32, MSVC)
// Pad 4
// 32(GCC64); 24(GCC32, MSVC)
};
CASSERT_MSVC(sizeof(struct Floats_Packed) == 24);
CASSERT_GCC32(sizeof(struct Floats_Packed) == 24);
CASSERT_GCC64(sizeof(struct Floats_Packed) == 32);

struct Arrays_Packed
{
// 0
    char ac[12];
// 12
};
CASSERT(sizeof(struct Arrays_Packed) == 12);

struct Arrays_Mixed
{
// 0
    int a;
// 4
// Pad 4(GCC64, MSVC); 0(GCC32)
// 8 (GCC64, MSVC); 4(GCC32)
    double b;
// 16 (GCC64, MSVC); 12(GCC32)
    int c;
// 20 (GCC64, MSVC); 16(GCC32)
    char d[6];
// 26 (GCC64, MSVC); 22(GCC32)
// Pad 6(GCC64, MSVC); 2(GCC32)
// 32 (GCC64, MSVC); 24(GCC32)
};
CASSERT_MSVC(sizeof(struct Arrays_Mixed) == 32);
CASSERT_GCC64(sizeof(struct Arrays_Mixed) == 32);
CASSERT_GCC32(sizeof(struct Arrays_Mixed) == 24);

struct Pointers_Mixed {
// 0
    int a;
// 4
// Pad 4(GCC64, MSVC64); 0(GCC32, MSVC32)
// 8 (GCC64, MSVC64); 4(GCC32, MSVC32)
    float* p;
// 16 (GCC64, MSVC64); 8(GCC32, MSVC32)
};
CASSERT_MSVC64(sizeof(struct Pointers_Mixed) == 16);
CASSERT_MSVC32(sizeof(struct Pointers_Mixed) == 8);
CASSERT_GCC64(sizeof(struct Pointers_Mixed) == 16);
CASSERT_GCC32(sizeof(struct Pointers_Mixed) == 8);
