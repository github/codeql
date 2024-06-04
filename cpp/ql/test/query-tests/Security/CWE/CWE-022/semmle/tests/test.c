// Semmle test case for rule TaintedPath.ql (User-controlled data in path expression)
// Associated with CWE-022: Improper Limitation of a Pathname to a Restricted Directory. http://cwe.mitre.org/data/definitions/22.html

#include "stdlib.h"
#define PATH_MAX 4096
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
    char *tainted = getenv("A_STRING");
    fopen(tainted, "wb+"); // BAD
  }

  {
    char buffer[1024];
    strncpy(buffer, getenv("A_STRING"), 1024);
    fopen(buffer, "wb+"); // BAD
    fopen(buffer, "wb+"); // (we don't want a duplicate result here)
  }

  {
    char *aNumber = getenv("A_NUMBER");
    double number = strtod(aNumber, 0);
    char fileName[20];
    sprintf(fileName, "/foo/%f", number);
    fopen(fileName, "wb+"); // GOOD
  }

  {
    void readFile(const char *fileName);
    readFile(argv[1]); // BAD
  }

  {
    char buffer[1024];
    read(0, buffer, 1024);
    read(0, buffer, 1024);
    fopen(buffer, "wb+"); // BAD [duplicated with both sources]
  }

  {
    char *userAndFile = argv[2];
    char fileBuffer[PATH_MAX];
    snprintf(fileBuffer, sizeof(fileBuffer), "/home/%s", userAndFile);
    // BAD: a string from the user is used in a filename
    fopen(fileBuffer, "wb+");
  }

  {
    char *fileName = argv[2];
    // Check for invalid sequences in the user input
    if (strstr(fileName , "..") || strchr(fileName , '/') || strchr(fileName , '\\')) {
        printf("Invalid filename.\n");
        return 1;
    }

    char fileBuffer[PATH_MAX];
    snprintf(fileBuffer, sizeof(fileBuffer), "/home/user/files/%s", fileName);
    // GOOD: We know that the filename is safe and stays within the public folder. But we currently get an FP here.
    FILE *file = fopen(fileBuffer, "wb+");
  }

  {
    char *userAndFile = argv[2];
    const char *baseDir = "/home/user/public/";
    char fullPath[PATH_MAX];

    // Attempt to concatenate the base directory and the user-supplied path
    snprintf(fullPath, sizeof(fullPath), "%s%s", baseDir, userAndFile);

    // Resolve the absolute path, normalizing any ".." or "."
    char *resolvedPath = realpath(fullPath, 0); // <- we're using `NULL` in the example, but 0 here to get it to compile. Same for next line.
    if (resolvedPath == 0) {
        perror("Error resolving path");
        return 1;
    }

    // Check if the resolved path starts with the base directory
    if (strncmp(baseDir, resolvedPath, strlen(baseDir)) != 0) {
        free(resolvedPath);
        return 1;
    }

    // GOOD: Path is within the intended directory
    FILE *file = fopen(resolvedPath, "wb+");
    free(resolvedPath);
    
  }
}

void readFile(char *fileName) {
  fopen(fileName, "wb+");
}
