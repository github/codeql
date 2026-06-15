// preprocblock23.cpp
// semmle-extractor-options: -std=c++23

#include "header.h"
#define GREEN

#ifdef RED
#elifdef GREEN
	#include "header.h"

	#if 0
		#include "header.h" // not reached
	#elifndef BLUE
		#include "header.h"
	#endif

	#include "header.h"
#else

	// ...

#endif
