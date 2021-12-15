#include "size_asserts.h"

// Bitfield packing:
// (1) A struct containing a bitfield with declared type T (e.g. T bf : 7) will be aligned as if it
//     contained an actual member variable of type T. Thus, a struct containing a bitfield 'unsigned int bf : 8'
//     will have an alignment of at least alignof(unsigned int), even though the bitfield was only 8 bits.
// (2) If a bitfield with declared type T would straddle a sizeof(T) boundary, padding is inserted
//     before the bitfield to align it on an alignof(T) boundary. Note the subtle distinction between alignof
//     and sizeof. This matters for 32-bit Linux, where sizeof(long long) == 8, but alignof(long long) == 4.
// (3) [MSVC only!] If a bitfield with declared type T immediately follows another bitfield with declared type P,
//     and sizeof(P) != sizeof(T), padding will be inserted to align the new bitfield to a boundary of
//     max(alignof(P), alignof(T)).

struct Bitfield_Straddle {
// 0
    unsigned int bf0 : 24;
// 3
// Pad 1
// 4
    unsigned int bf1 : 24;
// 7
// Pad 1
// 8
    unsigned int bf2 : 16;
// 10
// Pad 2
// 12
};
CASSERT(sizeof(struct Bitfield_Straddle) == 12);

struct Bitfield_longlong_25 {
// 0
    char c;
// 1
// Pad 7(MSVC); 0(GCC)
// 8(MSVC); 1(GCC)
    unsigned long long bf : 25;
// 11.1(MSVC); 4.1(GCC)
// Pad 4.7(MSVC); 3.7(GCC)
// 16(MSVC); 8(GCC)
};
CASSERT_MSVC(sizeof(struct Bitfield_longlong_25) == 16);
CASSERT_GCC(sizeof(struct Bitfield_longlong_25) == 8);

struct Bitfield_longlong_57 {
// 0
    char c;
// 1
// Pad 7(MSVC, GCC64); 3(GCC32)
// 8(MSVC, GCC64); 4(GCC32)
    unsigned long long bf : 57;
// 15.1(MSVC, GCC64); 11.1(GCC32)
// Padd 0.7
// 16(MSVC, GCC64); 12(GCC32)
};
CASSERT_MSVC(sizeof(struct Bitfield_longlong_57) == 16);
CASSERT_GCC64(sizeof(struct Bitfield_longlong_57) == 16);
CASSERT_GCC32(sizeof(struct Bitfield_longlong_57) == 12);

struct Bitfield_Int7 {
// 0
    char c;
// 1
// Pad 3(MSVC); 0(GCC)
// 4(MSVC); 1(GCC)
    unsigned int bf : 7;
// 4.7(MSVC); 1.7(GCC)
// Pad 3.1(MSVC); 2.1(GCC)
// 8(MSVC); 4(GCC)
};
CASSERT_MSVC(sizeof(struct Bitfield_Int7) == 8);
CASSERT_GCC(sizeof(struct Bitfield_Int7) == 4);

struct Bitfield_Int8 {
// 0
    char c;
// 1
// Pad 3(MSVC); 0(GCC)
// 4(MSVC); 1(GCC)
    unsigned int bf : 8;
// 5(MSVC); 2(GCC)
// Pad 3(MSVC); 2(GCC)
// 8(MSVC); 4(GCC)
};
CASSERT_MSVC(sizeof(struct Bitfield_Int8) == 8);
CASSERT_GCC(sizeof(struct Bitfield_Int8) == 4);

struct Bitfield_Int9 {
// 0
char c;
// 1
// Pad 3(MSVC); 0(GCC)
// 4(MSVC); 1(GCC)
    unsigned int bf : 9;
// 5.1(MSVC); 2.1(GCC)
// Pad 2.7(MSVC); 1.7(GCC)
// 8(MSVC); 4(GCC)
};
CASSERT_MSVC(sizeof(struct Bitfield_Int9) == 8);
CASSERT_GCC(sizeof(struct Bitfield_Int9) == 4);

struct Bitfield_Short7 {
// 0
    char c;
// 1
// Pad 1(MSVC); 0(GCC)
// 2(MSVC); 1(GCC)
    unsigned short bf : 7;
// 2.7(MSVC); 1.7(GCC)
// Pad 1.1(MSVC); 0.1(GCC)
// 4(MSVC); 2(GCC)
};
CASSERT_MSVC(sizeof(struct Bitfield_Short7) == 4);
CASSERT_GCC(sizeof(struct Bitfield_Short7) == 2);

struct Bitfield_Short8 {
// 0
    char c;
// 1
// Pad 1(MSVC); 0(GCC)
// 2(MSVC); 1(GCC)
    unsigned short bf : 8;
// 3(MSVC); 2(GCC)
// Pad 1(MSVC); 0(GCC)
// 4(MSVC); 2(GCC)
};
CASSERT_MSVC(sizeof(struct Bitfield_Short8) == 4);
CASSERT_GCC(sizeof(struct Bitfield_Short8) == 2);

struct Bitfield_Short9 {
// 0
    char c;
// 1
// Pad 1
// 2
    unsigned short bf : 9;
// 3.1
// Pad 0.7(MSVC)
// 4
};
CASSERT_MSVC(sizeof(struct Bitfield_Short9) == 4);
CASSERT_GCC(sizeof(struct Bitfield_Short9) == 4);

struct Bitfield_Mixed {
// 0
    unsigned char bfc : 2;
// 0.2
// Pad 3.6(MSVC); 0(GCC)
// 4(MSVC); 0.2(GCC)
    unsigned int bfi : 7;
// 4.7(MSVC); 1.1(GCC)
// Pad 3.1(MSVC); 0(GCC)
// 8(MSVC); 1.1(GCC)
    unsigned short bfs : 7;
// 8.7(MSVC); 2(GCC)
// Pad 3.1(MSVC); 0(GCC)
};
CASSERT_MSVC(sizeof(struct Bitfield_Mixed) == 12);
CASSERT_GCC(sizeof(struct Bitfield_Mixed) == 4);

typedef char CHAR;
typedef short SHORT;

struct Bitfield_TypeEquality_char {
    char x : 2;
    const char y : 2;
};
CASSERT(sizeof(struct Bitfield_TypeEquality_char) == 1);

struct Bitfield_TypeEquality_char_uchar {
    char x : 2;
    unsigned char y : 2;
};
CASSERT(sizeof(struct Bitfield_TypeEquality_char_uchar) == 1);

struct Bitfield_TypeEquality_char_schar {
    char x : 2;
    signed char y : 2;
};
CASSERT(sizeof(struct Bitfield_TypeEquality_char_schar) == 1);

struct Bitfield_TypeEquality_char_CHAR {
    char x : 2;
    CHAR y : 2;
};
CASSERT(sizeof(struct Bitfield_TypeEquality_char_CHAR) == 1);

struct Bitfield_TypeEquality_short {
    short x : 2;
    short y : 2;
};
CASSERT(sizeof(struct Bitfield_TypeEquality_short) == 2);

struct Bitfield_TypeEquality_short_ushort {
    short x : 2;
    unsigned short y : 2;
};
CASSERT(sizeof(struct Bitfield_TypeEquality_short_ushort) == 2);

struct Bitfield_TypeEquality_int_long {
    int x : 2;
    long y : 2;
};
CASSERT_MSVC(sizeof(struct Bitfield_TypeEquality_int_long) == 4);
CASSERT_GCC32(sizeof(struct Bitfield_TypeEquality_int_long) == 4);
CASSERT_GCC64(sizeof(struct Bitfield_TypeEquality_int_long) == 8);

struct Bitfield_TypeEquality_int_ulong {
    int x : 2;
    unsigned long y : 2;
};
CASSERT_MSVC(sizeof(struct Bitfield_TypeEquality_int_long) == 4);
CASSERT_GCC32(sizeof(struct Bitfield_TypeEquality_int_long) == 4);
CASSERT_GCC64(sizeof(struct Bitfield_TypeEquality_int_long) == 8);
