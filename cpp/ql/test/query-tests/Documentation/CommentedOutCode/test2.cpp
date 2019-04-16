/*
 * This sentence contains a semicolon;
 * however, this doesn't make it code.
 */

// This sentence contains a semicolon;
// however, this doesn't make it code.

/* Mention a ';' */

/* Mention a '{' */

/* JSON example: {"foo":"bar"} */

/* JSON example in backticks: `{"foo":"bar"}` */

/* JSON example in quotes: '{"foo":"bar"}' */

/*
 * Code example: `return 0;`.
 */

// Code example:
//
//     return 0;

// Code example:
//
// ```
// return 0;
// ```

// { 1, 2, 3, 4 }

// Example: { 1, 2, 3, 4 }

// int myFunction() { return myValue; }

// int myFunction() const { return myValue; }

// int myFunction() const noexcept { return myValue; }

// #define MYMACRO

// #include "include.h"

/*
#ifdef
void myFunction();
#endif
*/

// define some constants

// don't #include anything here

// #hashtag

// #if(defined(MYMACRO))

// #iffy

// #pragma once

//  # pragma once

/*#error"myerror"*/

#ifdef MYMACRO

	// ...

#endif // #ifdef MYMACRO

#if !defined(MYMACRO)

	// ...

#else // #if !defined(MYMACRO)

	// ...

#endif // #else #if !defined(MYMACRO)

#ifdef MYMACRO

	// ...

#endif   //    #ifdef MYMACRO       (comment)

/*
#ifdef MYMACRO
	// ...
#endif // #ifdef MYMACRO
*/


#ifdef MYMACRO1
	#ifdef MYMACRO2

		// ...

		// comment at end of block
	#endif // #ifdef MYMACRO2
#endif // #ifdef MYMACRO1

#include "config.h" // #include "config2.h"

#ifdef MYMACRO

	// ...

#endif /* #ifdef MYMACRO */

#error "error" /* #ifdef MYMACRO */

// commented_out_code();

#if 0
	// commented_out_code();
#endif
