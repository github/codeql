typedef unsigned long size_t;
// These are Microsoft routines for stack allocation
// but should only be treated as such if they are declared
// in the <malloc.h> header (i.e., this file)
void *_alloca(size_t sz);
void *_malloca(size_t sz);
void _freea(void *ptr);
