
extern void f (int x, int y);

void g(void) { 
   (f)(11, 22);
   f(33, 44);
}

