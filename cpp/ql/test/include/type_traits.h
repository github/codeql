#if !defined(CODEQL_TYPE_TRAITS_H)
#define CODEQL_TYPE_TRAITS_H

namespace std {
    template<typename T>
    struct remove_reference {
        typedef T type;
    };

    template<typename T>
    struct remove_reference<T&> {
        typedef T type;
    };

    template<typename T>
    struct remove_reference<T&&> {
        typedef T type;
    };
}

#endif
