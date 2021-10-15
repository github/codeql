
struct X {
    template<typename T>
    struct Y { };
};

struct Z : X {
    template <typename T>
    struct S : Y<T> { };
};

