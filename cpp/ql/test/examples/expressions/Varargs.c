typedef __builtin_va_list __gnuc_va_list;
#define va_start(v,l)	__builtin_va_start(v,l)
#define va_end(v)	__builtin_va_end(v)
#define va_arg(v,l)	__builtin_va_arg(v,l)
#define va_copy(d,s)	__builtin_va_copy(d,s)
typedef __gnuc_va_list va_list;

void VarArgs(const char *text, ...) {
  va_list args;
  va_start(args, text);
  va_end (args);
}
