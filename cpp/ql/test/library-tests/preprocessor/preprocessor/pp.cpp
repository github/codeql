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

#if defined(BAR) &&\
  defined(BAR)
#warning BAR defined
#endif

#if defined MACROTHREE/**hello*/ && /*world*/\
/*hw*/ (defined(MACROONE)) /* macroone */
#endif

#if defined SIMPLE_COMMENT  //this comment \
     (defined(SIMPLE_COMMENT)) spans over multiple lines
#endif

#if defined(FOO) &&\
    defined(BAR)
#define CONDITIONAL_MACRO_1 1
#endif

#if defined(FOO) && \
    defined(BAR) && \
    !defined(BAZ)
#define CONDITIONAL_MACRO_2 2
#endif

#define FOO 8
#define BAR 2
#define BAZ 4
#if ((FOO / BAR) \
   == 4) && ((BAZ \
   * QUX) \
   > 10)
#define CONDITIONAL_MACRO_3 3
#endif

// Testing \t spaced PreprocessorIf
#if defined(FOO)	&&	\
	defined(BAR)	&&	\
	defined(BAZ)
#define CONDITIONAL_MACRO_4 4
#endif


#if defined /* //test */ SIMPLE_COMMENT   //this comment \
     (defined(SIMPLE_COMMENT)) spans over multiple lines
#endif

#warning foo \

#warning foo \
\
/* a comment */

#warning foo \
\

#warning foo \
\
// a comment


#define FOO 8
#define BAR 2
#define BAZ 4
#if ((FOO / BAR) \
   == 4) && ((BAZ \
    /** comment */ \
   * QUX) \
   /** comment */ \
   > 10)
#define CONDITIONAL_MACRO_3 3
#endif

#define X 1
#define Y 2
#if defined(X) && \
    /*this is a comment*/ defined(Y) \
    // another comment
#endif

#warning FOO\
	 \
	 \
	 \
BAR


#warning foo \
\
/* comment */     \
\


#if/** */A/* ... */&&B
#endif


#if/** */  /**/    A
#endif

#if \
\
A && B
#endif


#ifdef /*



*/ FOOBAR
#warning a
#else
#warning b
#endif


#if /*

//test

*/ FOOBAR
#endif

#if/*...*//*...*/A
#endif