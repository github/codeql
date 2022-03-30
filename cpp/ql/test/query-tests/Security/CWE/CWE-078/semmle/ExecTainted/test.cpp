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

void test8(char *arg2) {
  // GOOD?: the user string is the *first* part of the command, like $CC in many environments
  std::string envCC(getenv("CC"));
  std::string command = envCC + arg2;
  system(command.c_str());
}

void test9(FILE *f) {
  // BAD: the user string is injected directly into a command
  std::string path(getenv("something"));
  std::string command = "mv " + path;
  system(command.c_str());
}

void test10(FILE *f) {
  // BAD: the user string is injected directly into a command
  std::string path(getenv("something"));
  system(("mv " + path).c_str());
}

void test11(FILE *f) {
  // BAD: the user string is injected directly into a command
  std::string path(getenv("something"));
  system(("mv " + path).data());
}

int atoi(char *);

void test12(FILE *f) {
  char temp[10];
  char command[1000];

  fread(temp, 1, 10, f);

  int x = atoi(temp);
  sprintf(command, "tail -n %d foo.log", x);
  system(command); // GOOD: the user string was converted to an integer and back
}

void test13(FILE *f) {
  char str[1000];
  char command[1000];

  fread(str, 1, 1000, f);

  sprintf(command, "echo %s", str);
  system(command); // BAD: the user string was printed into the command with the %s specifier
}

void test14(FILE *f) {
  char str[1000];
  char command[1000];

  fread(str, 1, 1000, f);

  sprintf(command, "echo %p", str);
  system(command); // GOOD: the user string's address was printed into the command with the %p specifier
}

void test15(FILE *f) {
  char temp[10];
  char command[1000];

  fread(temp, 1, 10, f);

  int x = atoi(temp);
  
  char temp2[10];
  sprintf(temp2, "%d", x);
    sprintf(command, "tail -n %s foo.log", temp2);

  system(command); // GOOD: the user string was converted to an integer and back
}

void test16(FILE *f, bool use_flags) {
  // BAD: the user string is injected directly into a command
  char command[1000] = "mv ", flags[1000] = "-R", filename[1000];
  fread(filename, 1, 1000, f);

  if (use_flags) {
    strncat(flags, filename, 1000);
    strncat(command, flags, 1000);
  } else {
    strncat(command, filename, 1000);
  }

  execl("/bin/sh", "sh", "-c", command);
}

void concat(char *command, char *flags, char *filename) {
  strncat(flags, filename, 1000);
  strncat(command, flags, 1000);
}

void test17(FILE *f) {
  // BAD: the user string is injected directly into a command
  char command[1000] = "mv ", flags[1000] = "-R", filename[1000];
  fread(filename, 1, 1000, f);

  concat(command, flags, filename);

  execl("/bin/sh", "sh", "-c", command);
}

void test18() {
  // GOOD
  char command[1000] = "ls ", flags[1000] = "-l", filename[1000] = ".";

  concat(command, flags, filename);

  execl("/bin/sh", "sh", "-c", command);
}

#define CONCAT(COMMAND, FILENAME)   \
  strncat(COMMAND, FILENAME, 1000); \
  strncat(COMMAND, " ", 1000);      \
  strncat(COMMAND, FILENAME, 1000);

void test19(FILE *f) {
  // BAD: the user string is injected directly into a command
  char command[1000] = "mv ", filename[1000];
  fread(filename, 1, 1000, f);

  CONCAT(command, filename)

  execl("/bin/sh", "sh", "-c", command);
}

// open question: do we want to report certain sources even when they're the start of the string?
