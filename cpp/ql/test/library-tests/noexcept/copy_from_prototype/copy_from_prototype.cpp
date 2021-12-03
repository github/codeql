// An example that causes copy_from_prototype to be TRUE.
template <typename>
class a {
  template <typename...> a() noexcept(123);
};

class b : a<int> {
};

// A similar example that would be an error if processing of exception
// specifications weren't delayed until they're actually needed.
template <typename T>
class c {
  template <typename...> c() noexcept(T::X);
};

class d : c<int> {
};

// Example where copy_from_prototype is FALSE.
template <typename T>
struct e {
  template <typename...> e() noexcept(456);
};

template<> template<typename ...> e<int>::e()
  noexcept(789);
