
class someClass {
public:
    void f(void);
    int g(int i, int j);
};

void fun3(someClass *sc) {
    int i;
    sc->f();
    i = sc->g(1, 2);
}

