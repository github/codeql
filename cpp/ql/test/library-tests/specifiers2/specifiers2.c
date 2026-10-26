// Compilable with:
// gcc -c specifiers2.c

int i;
extern int i;
extern int i;

extern int j;
extern int j;

void f(void);
extern void f(void);
extern void f(void);

extern void g(void);
extern void g(void);

static volatile int svi;
const int ci;

void somefun(char * __restrict__ p);

__thread int ti;

inline int add(int x, int y) { return x + y; }

typedef const int constInt;

