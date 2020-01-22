int atoi(const char *nptr);
char *getenv(const char *name);
char *strcat(char * s1, const char * s2);

char *strdup(const char *);
char *_strdup(const char *);
char *unmodeled_function(const char *);

void sink(const char *);
void sink(int);

int main(int argc, char *argv[]) {
  int taintedInt = atoi(getenv("VAR"));
  taintedInt++; // BUG: `taintedInt` isn't marked as tainted. Only `++` is.

  sink(_strdup(getenv("VAR")));
  sink(strdup(getenv("VAR")));
  sink(unmodeled_function(getenv("VAR")));

  char untainted_buf[100] = "";
  char buf[100] = "VAR = ";
  sink(strcat(buf, getenv("VAR")));

  sink(buf);
  sink(untainted_buf); // the two buffers would be conflated if we added flow through all partial chi inputs

  return 0;
}

typedef unsigned int inet_addr_retval;
inet_addr_retval inet_addr(const char *dotted_address);
void sink(inet_addr_retval);

void test_indirect_arg_to_model() {
    // This test is non-sensical but carefully arranged so we get data flow into
    // inet_addr not through the function argument but through its associated
    // read side effect.
    void *env_pointer = getenv("VAR"); // env_pointer is tainted, not its data.
    inet_addr_retval a = inet_addr((const char *)&env_pointer);
    sink(a);
}
