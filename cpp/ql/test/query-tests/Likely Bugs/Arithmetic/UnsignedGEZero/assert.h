/***
*
* assert.h
*
****/

#undef assert

#ifdef NDEBUG
	#define assert(_expr) ((void)0)
#else
	int assertFunc(const char *file, int line);

	#define assert(_expr) ((_expr) || assertFunc(__FILE__, __LINE__))
#endif