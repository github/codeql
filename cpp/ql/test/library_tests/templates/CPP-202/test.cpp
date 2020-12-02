
template <bool>
struct s1 { typedef int type; };
template <typename T>
struct s2 { constexpr operator bool() const noexcept { return true; } };
template <class T, class = typename s1<s2<T>{}>::type>
struct s3 {};

// previously failed compiling with:
//     "test.cpp", line 6: error: expression must have a constant value
//       template <class T, class = typename s1<s2<T>{}>::type>
