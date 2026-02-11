// semmle-extractor-options: --clang -std=c++20

namespace cpp20 {

class TestConstexpr {
    constexpr int member_constexpr() { return 0; } // not const in C++ >= 14
    constexpr int member_const_constexpr() const { return 0; }
};

struct TestExplict {
    explicit TestExplict();
};

template<typename T>
struct TestExplicitBool {
    explicit(sizeof(T) == 1)
    TestExplicitBool(const T);
};

explicit TestExplicitBool(const double)  -> TestExplicitBool<int>;

template<typename T>
explicit(sizeof(T) == 4)
TestExplicitBool(const T)  -> TestExplicitBool<int>;

void TestExplicitBoolFun() {
    new TestExplicitBool<char>(0);
    new TestExplicitBool<int>(0);
    new TestExplicitBool(0.0f);
    new TestExplicitBool(0.0);
}

template<typename T>
struct TestExplicitBool2 {
    explicit(sizeof(T) == 1)
    TestExplicitBool2(const T);
};

template<typename T>
TestExplicitBool2<T>::TestExplicitBool2(const T) { }

void TestExplicitBoolFun2() {
    new TestExplicitBool2<char>(0);
    new TestExplicitBool2<int>(0);
}

template<typename T>
struct TestExplicitBool3 {
    template<typename U>
    explicit(sizeof(T) == 1)
    TestExplicitBool3(const T, const U);
};

template<typename T> template<typename U>
TestExplicitBool3<T>::TestExplicitBool3(const T, const U) { }

void TestExplicitBoolFun3() {
    new TestExplicitBool3<char>(0, 0);
    new TestExplicitBool3<int>(0, 0);
}

struct TestExplicitBool4 {
    explicit(sizeof(char) == 1)
    TestExplicitBool4(const char);
};

} // namespace cpp20
