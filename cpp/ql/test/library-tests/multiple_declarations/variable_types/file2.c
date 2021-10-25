typedef int intAlias;
typedef const int qualifiedIntAlias;
typedef struct emptyStruct2 { } structAlias;

#include "extracted_once.h"
struct UnifiableOnce uOnce;

#include "extracted_twice.h"
struct UnifiableTwice uTwice;
struct NotUnifiableTwice nTwice; // BUG: this variable has two types
