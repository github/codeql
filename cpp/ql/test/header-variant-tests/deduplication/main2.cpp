#include "foo.h"
#include "bar.h"

// This will cause multiple, incompatible definitions of C since the member
// variable in foo.h has different names depending on whether or not FOO is
// defined.
class C
{
#include "foo.h"
#include "bar.h"
};

// All definitions of D should be merged, since all members have the same name
// and type.
class D
{
#include "bar.h"
};
