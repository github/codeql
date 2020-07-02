
char *f(void);

void g(void) {
    char *s;
    s = f() ? : "str"; // the 'then' part is implictly the value of the condition (GNU C extension)
    s = f() ? "a" : "b";
}

int x;
long y;

void h() {
  // Another use of the GNU two-operand form. We expect that the condition part
  // and the 'then' part are different exprs, since the latter should have an
  // implicit conversion to `long`.
  y = x ? : y;
}
