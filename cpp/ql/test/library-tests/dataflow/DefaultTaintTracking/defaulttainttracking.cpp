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

  sink(buf); // BUG: no taint
  sink(untainted_buf); // the two buffers would be conflated if we added flow through partial chi inputs

  return 0;
}
