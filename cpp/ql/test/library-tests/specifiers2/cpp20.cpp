// semmle-extractor-options: --edg --clang --edg --c++20

namespace cpp20 {

class TestConstexpr {
    constexpr int member_constexpr() { return 0; } // not const in C++ >= 14
    constexpr int member_const_constexpr() const { return 0; }
};

} // namespace cpp20
