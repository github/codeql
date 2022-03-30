// These typedefs are all _compatible_ (see
// https://en.cppreference.com/w/c/language/type#Compatible_types) with their
// siblings in file2.c. It varies whether they have a canonical form that's
// common to them both.
typedef int localInt;
typedef localInt intAlias; // has common `getUnderlyingType()` and `getUnspecifiedType()`
typedef int qualifiedIntAlias; // only has common `getUnspecifiedType()`
typedef struct emptyStruct1 { } structAlias; // has no common type

#include "extracted_once.h"
struct UnifiableOnce uOnce;

#include "extracted_twice.h"
struct UnifiableTwice uTwice;
struct NotUnifiableTwice nTwice; // BUG: this variable has two types
