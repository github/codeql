template<class T>
struct remove_const { typedef T type; };

template<class T>
struct remove_const<const T> { typedef T type; };

// `remove_const_t<T>` removes any `const` specifier from `T`
template<class T>
using remove_const_t = typename remove_const<T>::type;

template<class T>
struct remove_reference { typedef T type; };

template<class T>
struct remove_reference<T &> { typedef T type; };

template<class T>
struct remove_reference<T &&> { typedef T type; };

// `remove_reference_t<T>` removes any `&` from `T`
template<class T>
using remove_reference_t = typename remove_reference<T>::type;

template<class T>
struct decay_impl {
    typedef T type;
};

template<class T, size_t t_size>
struct decay_impl<T[t_size]> {
    typedef T* type;
};

template<class T>
using decay_t = typename decay_impl<remove_reference_t<T>>::type;
