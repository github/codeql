// Semmle test case for rule ExecTainted.ql (Uncontrolled data used in OS command)
// Associated with CWE-078: OS Command Injection. http://cwe.mitre.org/data/definitions/78.html

///// Library routines /////

int sprintf(char *s, const char *format, ...);
int system(const char *string);

extern void encodeShellString(char *shellStr, int maxChars, const char* cStr);

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

