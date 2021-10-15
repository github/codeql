// Semmle test case for rule ArithmeticTainted.ql (User-controlled data in arithmetic expression).
// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

int atoi(const char *nptr);
void startServer(int heapSize);

typedef unsigned long size_t;
size_t strlen(const char *s);

int main(int argc, char** argv) {
  int maxConnections = atoi(argv[1]);

  // BAD: arithmetic on a user input without any validation
  startServer(maxConnections * 1000);
  
  // GOOD: check the user input first
  int maxConnections2 = atoi(argv[1]);
  if (maxConnections2 < 100) {
    startServer(maxConnections2 * 1000);
  }

  // GOOD: arithmetic on the pointer itself is OK
  char *ptr = argv[1];
  while (*ptr != 0) {
    ptr++;
  }

  {
    int len1;

    len1 = atoi(argv[1]);
    while (len1 > 0)
    {
      len1--; // GOOD: can't underflow
    }
  }

  {
    int len2;

    len2 = atoi(argv[1]);
    while (len2)
    {
      len2--; // BAD: can underflow, if len2 is initially negative.
    }
  }

  {
    int len3;

    len3 = atoi(argv[1]);
    while (len3 != 0)
    {
      len3--; // BAD: can underflow, if len3 is initially negative.
    }
  }

  {
    size_t len4;

    len4 = strlen(argv[1]);
    while (len4 > 0)
    {
      len4--; // GOOD: can't underflow
    }
  }

  {
    size_t len5;

    len5 = strlen(argv[1]);
    while (len5)
    {
      len5--; // GOOD: can't underflow
    }
  }

  {
    size_t len6;

    len6 = strlen(argv[1]);
    while (len6 != 0)
    {
      len6--; // GOOD: can't underflow
    }
  }

  {
    size_t len7;

    len7 = strlen(argv[1]);
    while ((len7) && (1))
    {
      len7--; // GOOD: can't underflow
    }
  }

  return 0;
}
