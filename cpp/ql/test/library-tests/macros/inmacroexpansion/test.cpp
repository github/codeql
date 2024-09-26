
#define FOO class S{int i; void f(void) { int j; return; } };

FOO

#define ID(x) x
#define A(x) ID(x)
int v1 = A(1);
