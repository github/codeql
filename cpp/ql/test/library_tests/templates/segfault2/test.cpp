
typedef void (*ft)(void *);
int f(ft fp);

class C {};

template <typename T>
struct S {
    static void m(void *t) {
        static_cast<T*>(t)->~T();
    }
};

void g() {
    int i = f(S<C>::m);
}

