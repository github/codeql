struct Base {};

template <typename T>
struct Derived {friend class T;};

int main() { return sizeof(Derived<Base>); }
// semmle-extractor-options: --microsoft
