// semmle-extractor-options: -std=c++17

template<typename T, typename U>
struct Pair {
    Pair(T t, U u) {}
};

// TODO: accepted by GCC 7.1, rejected by the extractor
//template<typename... Args>
//bool all(Args... args) { return (... && args); }
//
//bool b = all(true, true, true, false);

namespace Foo::Bar {
    static_assert(true);
}

int main() {
    static_assert(true);
    // Pair p(5.0, false); // TODO: accepted by GCC 7.1, rejected by the extractor
    return 0;
}
