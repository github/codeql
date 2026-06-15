// preprocblock.cpp

#include "header.h"
#define GREEN

#ifdef RED
#elif defined GREEN
	#include "header.h"

	#ifndef BLUE
		#include "header.h"
	#endif

	#if 0
		#include "header.h" // not reached
	#else
		#include "header.h"
	#endif

	#include "header.h"
#else

	// ...

#endif