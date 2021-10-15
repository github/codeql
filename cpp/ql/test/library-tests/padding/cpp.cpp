#include "size_asserts.h"

CASSERT_MSVC(sizeof(wchar_t) == 2);
CASSERT_GCC(sizeof(wchar_t) == 4);

struct ReferencesAndPointers {
// 0
    char c1;
// 1
// Pad 7(GCC64, MSVC64); 3(GCC32, MSVC32)
// 8(GCC64, MSVC64); 4(GCC32, MSVC32)
    short& r2;
// 16(GCC64, MSVC64); 8(GCC32, MSVC32)
    wchar_t wc3;
// 18(GCC64, MSVC64); 10(GCC32, MSVC32)
// Pad 6(GCC64, MSVC64); 2(GCC32, MSVC32)
// 24(GCC64, MSVC64); 12(GCC32, MSVC32)
    long long* p4;
// 32(GCC64, MSVC64); 16(GCC32, MSVC32)
};
CASSERT_MSVC64(sizeof(struct ReferencesAndPointers) == 32);
CASSERT_MSVC32(sizeof(struct ReferencesAndPointers) == 16);
CASSERT_GCC64(sizeof(struct ReferencesAndPointers) == 32);
CASSERT_GCC32(sizeof(struct ReferencesAndPointers) == 16);

enum E {
    E_None
};
CASSERT(sizeof(E) == sizeof(int));

enum E_char : char {
    E_char_None
};
CASSERT(sizeof(E_char) == sizeof(char));

enum E_short : short {
    E_short_None
};
CASSERT(sizeof(E_short) == sizeof(short));

enum E_int : int {
    E_int_None
};
CASSERT(sizeof(E_int) == sizeof(int));

enum E_long : long {
    E_long_None
};
CASSERT(sizeof(E_long) == sizeof(long));

enum E_longlong : long long {
    E_longlong_None
};
CASSERT(sizeof(E_longlong) == sizeof(long long));

enum class EC {
    None
};
CASSERT(sizeof(EC) == sizeof(int));

enum class EC_char : char {
    None
};
CASSERT(sizeof(EC_char) == sizeof(char));

enum class EC_short : short {
    None
};
CASSERT(sizeof(EC_short) == sizeof(short));

enum class EC_int : int {
    None
};
CASSERT(sizeof(EC_int) == sizeof(int));

enum class EC_long : long {
    None
};
CASSERT(sizeof(EC_long) == sizeof(long));

enum class EC_longlong : long long {
    None
};
CASSERT(sizeof(EC_longlong) == sizeof(long long));

struct Enums_Packed {
// 0
    E_longlong ell;
// 8
    E_long el;
// 16(GCC64); 12(GCC32, MSVC)
    E_int ei;
// 20(GCC64); 16(GCC32, MSVC)
    E e;
// 24(GCC64); 20(GCC32, MSVC)
    E_short es;
// 26(GCC64); 22(GCC32, MSVC)
    E_char ec;
// 27(GCC64); 23(GCC32, MSVC)
// Pad 5(GCC64); 1(GCC32, MSVC)
// 32(GCC64); 24(GCC32, MSVC)
};
CASSERT_GCC64(sizeof(Enums_Packed) == 32);
CASSERT_GCC32(sizeof(Enums_Packed) == 24);
CASSERT_MSVC(sizeof(Enums_Packed) == 24);

struct Enums_MixedBitfields {
// 0
    E_short ei1 : 8;
// 1
    short s2 : 8;
// 2
};
CASSERT_GCC(sizeof(Enums_MixedBitfields) == 2);
CASSERT_MSVC(sizeof(Enums_MixedBitfields) == 2);

struct Enums_MixedBitfields_Padded {
// 0
    E_short ei1 : 8;
// 1
// Pad 1(MSVC); 0(GCC)
// 2(MSVC); 1(GCC)
    unsigned char uc2 : 8;
// 3(MSVC); 2(GCC)
// Pad 1(MSVC); 0(GCC)
// 4(MSVC); 2(GCC)
};
CASSERT_GCC(sizeof(Enums_MixedBitfields_Padded) == 2);
CASSERT_MSVC(sizeof(Enums_MixedBitfields_Padded) == 4);

struct Base_Empty {
// 0
// Pad 1
// 1
};
CASSERT(sizeof(Base_Empty) == 1);

struct Derived_EmptyBase : Base_Empty {
// 0
// Base class Base_Empty (Empty Base Optimization)
// 0
    int n1;
// 4
};
CASSERT(sizeof(Derived_EmptyBase) == 4);

struct Base_NoPadding {
// 0
    int n1;
// 4
};
CASSERT(sizeof(Base_NoPadding) == 4);

struct Derived_NoBasePadding : Base_NoPadding {
// 0
// Base class Base_NoPadding
// 4
    int n2;
// 8
};
CASSERT(sizeof(Derived_NoBasePadding) == 8);

struct Base_Padding {
// 0
    float f1;
// 4
    short s1;
// 6
// Pad 2
// 8
};
CASSERT(sizeof(Base_Padding) == 8);

struct Derived_BasePadding : Base_Padding {
// 0
// Base class Base_Padding
// 8
    short s2;
// 10
// Pad 2
// 12
};
CASSERT(sizeof(Derived_BasePadding) == 12);

struct Intermediate_NoFields : Base_NoPadding {
// 0
// Base class Base_NoPadding
// 4
};
CASSERT(sizeof(Intermediate_NoFields) == 4);

struct Derived_NonEmptyBaseWithNoFields : Intermediate_NoFields {
// 0
// Base class Intermediate_NoFields
// 4
    int n2;
// 8
};
CASSERT(sizeof(Derived_NonEmptyBaseWithNoFields) == 8);

struct MultipleInheritance : Base_NoPadding, Base_Padding {
    int n3;
};
CASSERT(sizeof(MultipleInheritance) == 16);

struct StaticMemberVariables {
// 0
    static int s_n1;
// 0
    float f1;
// 4
    static int s_n2;
// 4
};
CASSERT(sizeof(StaticMemberVariables) == 4);

struct VirtualInheritance : virtual Base_NoPadding {
    int n3;
};

struct Derived_EmptyBase_Conflict1 : Base_Empty {
// 0
// Base class Base_Empty (GCC Only: no Empty Base Optimization due to conflict with m1)
// 1(GCC); 0(MSVC)
    Base_Empty m1;
// 2(GCC); 1(MSVC)
};
CASSERT_GCC(sizeof(Derived_EmptyBase_Conflict1) == 2);
CASSERT_MSVC(sizeof(Derived_EmptyBase_Conflict1) == 1);

struct Derived_EmptyBase_Conflict2 : Base_Empty {
// 0
// Base class Base_Empty (GCC Only: no Empty Base Optimization due to conflict with m1)
// 1(GCC); 0(MSVC)
// Pad 3(GCC); 0(MSVC)
// 4(GCC); 0(MSVC)
    Derived_EmptyBase m1;
// 8(GCC); 4(MSVC)
};
CASSERT_GCC(sizeof(Derived_EmptyBase_Conflict2) == 8);
CASSERT_MSVC(sizeof(Derived_EmptyBase_Conflict2) == 4);

struct Base_Empty2 : Base_Empty {
// 0
// Base class Base_Empty (Empty Base Optimization)
// 0
// Pad 1
// 1
};
CASSERT(sizeof(Base_Empty2) == 1);

struct Derived_EmptyBase_Conflict3 : Base_Empty2 {
// 0
// Base class Base_Empty2 (GCC Only: no Empty Base Optimization due to conflict with m1)
// 1(GCC); 0(MSVC)
    Base_Empty m1;
// 2(GCC); 1(MSVC)
};
CASSERT_GCC(sizeof(Derived_EmptyBase_Conflict3) == 2);
CASSERT_MSVC(sizeof(Derived_EmptyBase_Conflict3) == 1);

struct Base_NoPaddingButSmallAlignment {
// 0
    short s1;
// 2
};
CASSERT(sizeof(Base_NoPaddingButSmallAlignment) == 2);

struct Derived_NoBasePaddingButNeedsAlignmentPadding : Base_NoPaddingButSmallAlignment {
// 0
// Base class Base_NoPaddingButSmallAlignment
// 2
// Pad 2
// 4
    int n1;
// 8
};
CASSERT(sizeof(Derived_NoBasePaddingButNeedsAlignmentPadding) == 8);
