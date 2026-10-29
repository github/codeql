#include "sal.h"

#define VOID_PTR void *

int sal_strncmp(
  __in_ecount(len1) const char *str1,
  __in int len1,
  __in_ecount(len2) const char str2,
  __in int len2,
  __in_opt VOID_PTR opt_param,
  __reserved VOID_PTR reserved);

_Ret_notnull_
_Must_inspect_result_
_Check_return_
char *f1(_Out_ _Result_zeroonfailure_ int *x);

_Ret_notnull_
// Next line intentionally left blank

_Check_return_
char *f2(
    _Out_
    int
    *x);

// [KNOWN BUG] Because of ODASA-5806, we can't see that the annotation belongs
// on `x`.
void f3(void (*fp)(_In_ int *x), int a);
