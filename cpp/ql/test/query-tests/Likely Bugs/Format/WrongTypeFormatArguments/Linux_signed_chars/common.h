
struct _IO_FILE
{
	// ...
};
typedef struct _IO_FILE FILE;

#define va_list void *
#define va_start(x, y)
#define va_end(x)
#define va_arg(ap, type) ((type)0)

extern int printf(const char *fmt, ...);
extern int vprintf(const char *fmt, va_list ap);
extern int vfprintf(FILE *stream, const char *format, va_list ap);
extern int vsnprintf(char *s, size_t n, const char *format, va_list arg);

#include "printf1.h"
#include "real_world.h"
#include "wide_string.h"
#include "format.h"
#include "pri_macros.h"
