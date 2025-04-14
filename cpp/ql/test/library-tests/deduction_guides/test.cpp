// semmle-extractor-options: -std=c++20

template<typename T>
struct C {
    C(const T);
    C(char, char);
};

C(const double)  -> C<int>;

template<typename T>
C(const T)  -> C<int>;

C(char, char) -> C<char>;

void test() {
    new C<char>(0);
    new C<int>(0);
    new C(0.0f);
    new C(0.0);
}
