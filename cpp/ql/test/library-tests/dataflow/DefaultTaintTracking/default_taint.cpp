void alias_taint(const char *a, const char** pa, const char* alias_a)
{
    pa = &a; // IR, AST: a -> pa
    alias_a = *pa; //IR, AST: a -> alias_a
                   //IR, AST: pa -> alias_a
}

int global;

void global_taint(int n, int* pn)
{
    pn = &global;
    *pn = n; // AST: n -> *pn = n
}

void side_effect_taint(int a, int b, int c, int d, int d1, int d2)
{
    a = (b = c); // IR: c -> (b = c)
    a = d1++; // IR: d1 -> d1
    d = ++d2; // IR: d2 -> d2
}

void unary_taint(int a, int d) {
    a = -d;
    a = +d;
}

extern bool b;

void conditional_taint(int a, int b1, int b2) {
    a = b ? b1 : b2;

    a = *(b ? &b1 : &b2); // IR: (b1 -> b ? &b1 : &b2)
                          // IR: (b2 -> b ? &b1 : &b2)
    a = b / 0;
}

struct S {
    int s;

    void set(int p) {
        s = p; // AST: p -> s = p
               // AST: p -> b (in 'void struct_taint(int a, int b, S s)')
               // AST: p -> get (in 'void struct_taint(int a, int b, S s)')
    }

    int get() {
        return s;
    }
};

void struct_taint(int a, int b, S s) {
    s.set(a); // AST: s -> set
              // AST: s -> s
              // AST: a -> s = p (in 'void set(int p)')
              // AST: a -> p (in 'void set(int p)')
              // AST: a -> s (in 'int get()')
              // AST: a -> b = s.get()
              // AST: a -> get
    b = s.get(); // AST: s -> get
                 // AST: s -> s (in 'int get()')
}