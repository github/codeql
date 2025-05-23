void sink(char);
void sink(char*);
void sink(char**);

char* GetCommandLineA();
char** CommandLineToArgvA(char*, int*);
char* GetEnvironmentStringsA();
int GetEnvironmentVariableA(const char*, char*, int);

void getCommandLine() {
  char* cmd = GetCommandLineA();
  sink(cmd);
  sink(*cmd); // $ MISSING: ir

  int argc;
  char** argv = CommandLineToArgvA(cmd, &argc);
  sink(argv);
  sink(argv[1]);
  sink(*argv[1]); // $ MISSING: ir
}

void getEnvironment() {
    char* env = GetEnvironmentStringsA();
    sink(env);
    sink(*env); // $ MISSING: ir

    char buf[1024];
    GetEnvironmentVariableA("FOO", buf, sizeof(buf));
    sink(buf);
    sink(*buf); // $ MISSING: ir
}
