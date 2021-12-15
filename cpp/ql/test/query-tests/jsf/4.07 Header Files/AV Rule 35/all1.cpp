#include "unmatched.h"
#include "matched_wrap.H"
int xs[] = {
#include "data.h"
};

#include "one_time.h"
#include "x.h"
#include "y.h"
#include "z.h"
#import "imported.h"
#include "preproc.h"
#include "preproc2.h"
#include "preproc3.h"
#include "functionlike.h"
#include "multipleguards.h"
#include "notcondition.h"
#include "complexcondition.h"
#include "complexcondition2.h"
#include "includefirst.h"
#include "vardecl.h"
#include "fundecl.h"
#include "pragma.h"
#include "namespace1.h"
#include "namespace2.h"

#undef X
#undef Y
#undef Z
#include "allCpp.h"
#undef X
#undef Y
#undef Z
#include "allCpp.h"
#undef X
#undef Y
#undef Z
#include "allCppWithRepeats.h"
#undef X
#undef Y
#undef Z
#include "allCppWithRepeats.h"
#undef X
#undef Y
#undef Z

#define XMACRO(id,desc) id,
enum Items {
	#include "items.h"
};
#undef XMACRO

#define XMACRO2(id,desc) void use_##();
	#include "items2.h"
#undef XMACRO2


#define XMACRO3(id,desc) static const char * id##_item = "The " desc " item";
	#include "items3.h"
// No #undef of XMACRO3. That's handled in items3.h.
