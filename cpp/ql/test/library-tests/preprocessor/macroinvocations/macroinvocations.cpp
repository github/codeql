
#define VAR1 int var1;
#define VAR2() int var2;
#define VAR3 int var3;
#define VAR4() int var4;
#define VAR5 int var5;
#define VAR6() int var6;
#define VAR7 int var7;
#define VAR8() int var8;
#define VAR9 int var9;

// --- simple ----

VAR1
VAR2()

// --- nested using parameter ---

#define WRAPOBJLIKE(x) x
#define WRAPFUNLIKE(x) x()
WRAPOBJLIKE(VAR3)
WRAPFUNLIKE(VAR4)

// --- nested ignoring parameter ---

#define IGNOREOBJLIKE(x) VAR5
#define IGNOREFUNLIKE(x) VAR6()
IGNOREOBJLIKE(VAR5)
IGNOREFUNLIKE(VAR6)

// --- multiple parameters ---

#define SECOND(x, y, z) y
SECOND(X, VAR7, Z)

// --- token pasting ---

#define FIXEDJOIN VAR8##()
FIXEDJOIN

#define JOIN(x,y) x##y
JOIN(VAR,
     9)

// --- example spanning header files ---

#include "header1.h"
#include "header2.h"

// --- check variables were created ---

void use_vars()
{
	var1 = var2 = var3 = var4 = var5 = var6 = var7 = var8 = var9 = var10 = 1;
}

// --- macro accesses ---

#define FOO 1
#define BAR FOO

#if BAR
#endif

#ifdef BAR
#endif

#ifndef BAR
#endif

#if (defined FOO || defined BAR || defined NA)
#endif

#define DEF_BAR defined BAR
#if DEF_BAR
#endif

// --- type define ---

#define MYVOID void
#define MYINT int

MYINT myGlobalVariable;

MYVOID myFunction(MYINT myParam) {
	MYINT myLocalVariable;
}

class myClass
{
public:
	MYINT myMember;
};

// --- macro invocations in files included in context ---

void function_context()
{
	#define CONTEXTTYPE int
		#include "in_function.h"
	#undef CONTEXTTYPE
}

template <class T>
class template_class_context
{
public:
	#define CONTEXTTYPE short
		#include "in_class.h"
	#undef CONTEXTTYPE
};

template_class_context<int> tcci;

// --- macro expr --

#define MACRO_EXPR ((2 + 3) * 4)

void myFunction()
{
	int x;

	x = 1 - MACRO_EXPR / 5;
}
