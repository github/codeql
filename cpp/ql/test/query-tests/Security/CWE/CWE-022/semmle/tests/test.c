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

  {
    char *fileName = argv[1];
    fopen(fileName, "wb+"); // BAD
  }

  {
    char fileName[20];
    scanf("%s", fileName);
    fopen(fileName, "wb+"); // BAD
  }

  {
    char *fileName = (char*)malloc(20 * sizeof(char));
    scanf("%s", fileName);
    fopen(fileName, "wb+"); // BAD
  }

  {
    char *aNumber = getenv("A_NUMBER");
    double number = strtod(aNumber, 0);
    char fileName[20];
    sprintf(fileName, "/foo/%f", number);
    fopen(fileName, "wb+"); // GOOD
  }

  {
    void read(const char *fileName);
    read(argv[1]); // BAD
  }
}

void read(char *fileName) {
  fopen(fileName, "wb+");
}
