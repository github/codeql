// semmle-extractor-options: --clang --edg --c++20

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

} // namespace cpp20
