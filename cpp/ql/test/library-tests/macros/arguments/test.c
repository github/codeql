#include "top_and_nested.h"
#define ID(x) x
// semmle-extractor-options: -DCMD_LINE_MACRO(x,y)=x+y
top(1)

top("\"Hello "
    "world\""
)

top(
    top(2) /* comment here top(3) */ nested(4)
   )

// This code is rejected by any sensible compiler. It is included in this test
// to ensure that it does not crash the extractor.
#include "split1.h"
#include "split2.h"

// macro defined (`#define`) + used inside a macro invocation argument list
#define CONCAT(x, y) x y
#define HELLO "hello"
const char *s = CONCAT(HELLO,
#define WORLD "word"
WORLD);

// preprocessor condition (`#if`) inside a macro invocation argument list
const char *t = CONCAT("hello",
#if defined(NOTDEFINED)
	"world"
#else
	"Semmle"
#endif
);



// Extracting text for object-like macros would just waste space
#define object_like_macro 123
static const int number = object_like_macro;

#define APPLY(M, X) M(X)
APPLY(top, 3)

#define DECLARE_STRING(name) \
  const char *ID(name) = ID(#name);

DECLARE_STRING(string1)
DECLARE_STRING(ID(string2))

#define APPLY_ID(x) ID(x)

// These two invocations are from the documentation in Macro.qll
const int one = ID (ID
                      (1));
const int two = APPLY_ID
                        (2);

#define NOPARAMS()
NOPARAMS()

#define VARARG_ID(...) __VA_ARGS__
VARARG_ID()

// The extractor runs in GCC dialect mode for our unit tests, so here we can
// make use of the non-standard extension to put ## in front of __VA_ARGS__.
#define VARARG_SECOND(fmt, ...) \
  printf(fmt "\n", ##__VA_ARGS__)

void va1(void) {
  VARARG_SECOND("Format string only");
}
void va2(int i, int j) {
  VARARG_SECOND("%d %d", i, j);
}

// Digraphs are preserved in the database. Our default dialect options for unit
// tests do not appear to support trigraphs. The VARARG_ID macro here is used
// to protect the comma from being seen as beginning a second argument to ID.
ID(int myarray <: :> = VARARG_ID(<% 4, 5 %>));

int empty_parentheses_follow APPLY(,) ;
ID()

#if APPLY(ID, ID(1))
int from_cmd_line = CMD_LINE_MACRO(5, 6);
#endif
