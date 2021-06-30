// Semmle test case for rule ExecTainted.ql (Uncontrolled data used in OS command)
// Associated with CWE-078: OS Command Injection. http://cwe.mitre.org/data/definitions/78.html

///// Library routines /////

int sprintf(char *s, const char *format, ...);
int system(const char *string);

char *getenv(char *var);

extern void encodeShellString(char *shellStr, int maxChars, const char* cStr);
#include "../../../../../../include/string.h"
///// Test code /////

int main(int argc, char** argv) {
  char *userName = argv[2];
  
  {
    // BAD: a string from the user is injected directly into
    // a command.
    char command1[1000] = {0};
    sprintf(command1, "userinfo -v \"%s\"", userName);
    system(command1);
  }

  {  
    // GOOD: the user string is encoded by a library routine.
    char userNameQuoted[1000] = {0};
    encodeShellString(userNameQuoted, 1000, userName); 
    char command2[1000] = {0};
    sprintf(command2, "userinfo -v %s", userNameQuoted);
    system(command2);
  }
}

void test2(char* arg2) {
  // GOOD?: the user string is the *first* part of the command, like $CC in many environments
  char *envCC = getenv("CC");
  
  char command[1000];
  sprintf("%s %s", envCC, arg2);
  system(command);
}

void test3(char* arg1) {
  // GOOD?: the user string is a `$CFLAGS` environment variable
  char *envCflags = getenv("CFLAGS");
  
  char command[1000];
  sprintf(command, "%s %s", arg1, envCflags);
  system(command);
}

typedef unsigned long size_t;
typedef void FILE;
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
char *strncat(char *s1, const char *s2, size_t n);

void test4(FILE *f) {
  // BAD: the user string is injected directly into a command
  char command[1000] = "mv ", filename[1000];
  fread(filename, 1, 1000, f);

  strncat(command, filename, 1000);
  system(command);
}

void test5(FILE *f) {
  // GOOD?: the user string is the start of a command
  char command[1000], filename[1000] = " test.txt";
  fread(command, 1, 1000, f);

  strncat(command, filename, 1000);
  system(command);
}

int execl(char *path, char *arg1, ...);

void test6(FILE *f) {
  // BAD: the user string is injected directly into a command
  char command[1000] = "mv ", filename[1000];
  fread(filename, 1, 1000, f);

  strncat(command, filename, 1000);
  execl("/bin/sh", "sh", "-c", command);
}

void test7(FILE *f) {
  // GOOD [FALSE POSITIVE]: the user string is a positional argument to a shell script
  char path[1000] = "/home/me/", filename[1000];
  fread(filename, 1, 1000, f);

  strncat(path, filename, 1000);
  execl("/bin/sh", "sh", "-c", "script.sh", path);
}

// TODO: concatenations via operator+, more sinks, test for call context sensitivity at
// concatenation site

// open question: do we want to report certain sources even when they're the start of the string?
