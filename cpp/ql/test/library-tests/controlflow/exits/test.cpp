void exit(int status);
void _exit(int status);
void abort(void);
void error(int status, int errnum, const char *format, ...);
void __assert_fail(const char * assertion, const char * file, unsigned int line, const char * function);
typedef int jmp_buf[4];
void longjmp(jmp_buf env, int value);
void DoesReturn();
void DoesNotReturn() __attribute__((noreturn));

namespace MyStuff
{
  void exit(int status);
  void _exit(int status);
  void abort(void);
  void error(int status, int errnum, const char *format, ...);
  void __assert_fail(const char * assertion, const char * file, unsigned int line, const char * function);
  void longjmp(jmp_buf env, int value);
  void DoesReturn();
  void DoesNotReturn() __attribute__((noreturn));
}

class MyClass
{
  void exit(int status);
  void _exit(int status);
  void abort(void);
  void error(int status, int errnum, const char *format, ...);
  void __assert_fail(const char * assertion, const char * file, unsigned int line, const char * function);
  void longjmp(jmp_buf env, int value);
  void DoesReturn();
  void DoesNotReturn() __attribute__((noreturn));
};
