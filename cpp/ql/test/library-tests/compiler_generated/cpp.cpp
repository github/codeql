
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

void uses_pretty_function() {
    const char* pretty = __PRETTY_FUNCTION__;
}

template <typename... Args>
void parameter_pack(Args... args) { }

void test_parameter_pack() {
  parameter_pack();
}

void ranged_for() {
    int vs[] = {1, 2, 3};
    for(int i : vs) {

    }
}