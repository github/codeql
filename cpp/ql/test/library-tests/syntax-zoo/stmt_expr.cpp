namespace stmtexpr {

class C {
    public:
        C(int x);
        ~C();
};

void f(int b) {
    int i;

    if (({
             C c(1);
             b;
        }))
        2;
    else
        ;
}

void g(int b) {
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
