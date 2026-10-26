template <typename... Xs>
struct Foo {
    Foo() {
        f();
    }
    void f(Xs... xs) {}
};

int main() {
    Foo<>();
}

