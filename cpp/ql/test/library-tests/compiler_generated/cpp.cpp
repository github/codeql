
int x;

class MySuperClass {
    public:
        MySuperClass() { x = 1; }
        ~MySuperClass() { x = 2; }
};

class MyClass : MySuperClass {
};

void g1(void) {
    MyClass *m = new MyClass();
    delete m;
}

