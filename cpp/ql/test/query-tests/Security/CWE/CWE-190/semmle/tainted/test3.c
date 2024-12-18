// semmle-extractor-options: -isystem ${testdir}/../system_header

#include <system_header.h>

#define CAST(c) ((int)(unsigned char)(c))

// Regression test for ODASA-6054: IntegerOverflowTainted should
// not report a result if the overflow happens in a macro expansion
// from a macro that is defined in a system header.
int main3(int argc, char **argv) {
  char *cmd = argv[0];
  int x = (int)(unsigned char)*cmd;  // BAD: overflow
  int y = CAST(*cmd);  // BAD: overflow in macro expansion (macro is not from a system header)
  int z = SYSTEM_CAST(*cmd);  // GOOD: overflow in macro expansion (macro from a system header)
  return x + y + z;
}
