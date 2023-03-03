namespace stmtexpr {

class C {
    public:
        C(int x);
        ~C();
};

static void f(int b) {
    int i;

    if (({
             C c(1);
             b;
        }))
        2;
    else
        ;
}

static void g(int b) {
    void *ptr;
    int i;

lab:

    ptr = &&lab;

    goto *({
               C c(3);
               ptr;
         });
}
}
