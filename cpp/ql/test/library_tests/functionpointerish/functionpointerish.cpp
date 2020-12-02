
int fun(int x) {};
int (*funptr)(int x);
int (&funref)(int x) = fun;
auto blockPtr = ^ int (int x, int y) {return x + y;};

