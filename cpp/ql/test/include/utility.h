#if !defined(CODEQL_UTILITY_H)
#define CODEQL_UTILITY_H

#include "type_traits.h"

namespace std {
    template<typename T>
    typename remove_reference<T>::type&& move(T&& src) {
        return static_cast<typename remove_reference<T>::type&&>(src);
    }
}

#endif
