// Semmle test case for rule TaintedPath.ql (User-controlled data in path expression)
// Associated with CWE-022: Improper Limitation of a Pathname to a Restricted Directory. http://cwe.mitre.org/data/definitions/22.html

#include "stdlib.h"

///// Test code /////

int main(int argc, char** argv) {
  char *userAndFile = argv[2];
  
  {
    char fileBuffer[FILENAME_MAX] = "/home/";
    char *fileName = fileBuffer;
    size_t len = strlen(fileName);
    strncat(fileName+len, userAndFile, FILENAME_MAX-len-1);
    // BAD: a string from the user is used in a filename
    fopen(fileName, "wb+");
  }

  {
    char fileBuffer[FILENAME_MAX] = "/home/";
    char *fileName = fileBuffer;
    size_t len = strlen(fileName);
    // GOOD: use a fixed file
    char* fixed = "file.txt";
    strncat(fileName+len, fixed, FILENAME_MAX-len-1);
    fopen(fileName, "wb+");
  }
}

char *use_varargs(int ignored, ...)
{
  char* buf;
  __builtin_va_list ap;

  __builtin_va_start(ap, ignored);
  buf = __builtin_va_arg(ap, const char*);
  __builtin_va_end(ap);
  return buf;
}

void test(const char *filename)
{
  char *config_home, *config_home_copy;
  config_home = getenv("HOME");
  config_home_copy = use_varargs(0, config_home);
  fopen(config_home, "r");  // BAD
  fopen(config_home_copy, "r");  // BAD
}