// define the preprocessor macro `MYTYPE` before including this file.

typedef MYTYPE mytype_t;

inline MYTYPE myfun() { return 0; }

inline int intfun() {
  MYTYPE localVar = sizeof(MYTYPE);
  return localVar;
}

extern MYTYPE myvar;

// This creates a separate variable named `intvar` for each file that includes
// this header. That's definitely bad practice.
static int intvar = sizeof(MYTYPE);
