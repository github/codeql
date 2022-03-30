typedef void *va_list;
#define va_start(ap, parmN)
#define va_end(ap)
#define va_arg(ap, type) ((type)0)
#define NULL 0

extern "C" int printf(const char *fmt, ...);
extern "C" int snprint(char *buf, int len, const char *fmt, ...);
extern "C" int _vsnprintf_s(
   char *buffer,
   int sizeOfBuffer,
   int count,
   const char *fmt,
   va_list argptr
);
extern "C" int snprintf ( char * s, int n, const char * format, ... );

struct A {
  void do_print(const char *fmt0) {
    char buf[32];
    snprintf(buf, 32, fmt0); // GOOD [FALSE POSITIVE]
  }
};

struct B {
  A a;
  void do_printing(const char *fmt) {
    a.do_print(fmt);
  }
};

struct C {
  B b;
  void do_some_printing(const char *fmt) {
    b.do_printing(fmt);
  }
  const char *ext_fmt_str(void);
};

void foo(void) {
  C c;
  c.do_some_printing(c.ext_fmt_str()); // BAD [NOT DETECTED]
}

struct some_class {
    // Retrieve some target specific output strings
    virtual const char * get_fmt() const = 0;
};

struct debug_ {
    int
    out_str(
        const char *fmt,
        va_list args)
    {
        char str[4096];
        int length = _vsnprintf_s(str, sizeof(str), 0, fmt, args); // GOOD
        if (length > 0)
        {
            return 0;
        }
        return 1;
    }
};

some_class* some_instance = NULL;
debug_ *debug_ctrl;

void diagnostic(const char *fmt, ...)
{
    va_list args;

    va_start(args, fmt);
    debug_ctrl->out_str(fmt, args);
    va_end(args);
}

void bar(void) {
    diagnostic (some_instance->get_fmt());  // BAD
}

namespace ns {

  class blab {
    void out1(void) {
      char *fmt = (char *)__builtin_alloca(10);
      diagnostic(fmt);  // BAD
    }
  };
}
