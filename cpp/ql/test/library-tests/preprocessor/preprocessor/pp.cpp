#if defined(FOO)
#error "This shouldn't happen"
#elif !defined(BAR)
#define BAR // I'm not a stool
#define BAR_val 1 /* I'm not a function */
#define BAR_fn() BAR_val
#else
#warning "This shouldn't happen either"
#endif
// semmle-extractor-options: -I${testdir}/more_headers/ "-U SOME_SYM"
#undef BAR
#define SCARY(a,aa,aaah) /* we ignore a */ (aa /* but we take aa */) /* and we ignore aaa */
#define LOG(fmt, ...)  printf("Warning: %s", fmt, __VA__ARGS__)  
#include "pp.h"

#if 0
#else
#endif

#if 1
#else
#endif

#import "a.h"

// --- contexts and templates ---

void functionContext()
{
	#define MACRO_FUNCTIONCONTEXT 1
}

class classContext
{
public:
	#define MACRO_CLASSCONTEXT 2
};

template <class T>
void templateFunctionContext()
{
	#define MACRO_TEMPLATEFUNCTIONCONTEXT 3
}

template <class T>
class templateClassContext
{
public:
	#define MACRO_TEMPLATECLASSCONTEXT 4
	#define MACRO_TEMPLATECLASSCONTEXT_REFERENCED 5

	template <class U>
	void templateMethodContext() {
		#define MACRO_TEMPLATEMETHODCONTEXT 6
	}

	#ifdef INSTANTIATION
		#define IN_INSTANTIATION
	#else
		#define IN_TEMPLATE
	#endif
	
	static int val;
};

template <class T>
int templateClassContext<T> :: val = MACRO_TEMPLATECLASSCONTEXT_REFERENCED;

#define INSTANTIATION
templateClassContext<int> tcci;

#define BAR

#if defined(BAR) && \
  defined(BAR)
#warning BAR defined
#endif
