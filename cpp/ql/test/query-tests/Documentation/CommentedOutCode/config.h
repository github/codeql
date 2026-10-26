
/* define if you want setting 1 */
#define SETTING1

// define if you want setting 2
//#define SETTING2

/* define if you want setting 3 */
//#define SETTING3

/* define if you want setting 4 */
/* #define SETTING4 */

#if defined(SETTING3) && defined(SETTING4)
	#error "can't have both SETTING3 and SETTING4"
#endif

/* uncomment if you don't want setting 5 */
/* #undef SETTING5 */
