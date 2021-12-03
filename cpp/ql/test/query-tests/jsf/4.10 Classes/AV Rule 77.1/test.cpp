class C1 {
    C1(const C1& c); // ok; nothing strange going on here
};

class C2 {
    C2(const C2& c, int i); // ok; no default arguments
};

class C3 {
    C3(const C3& c, int i = 1); // error
};

namespace templates {
    template<typename T>
    class C1 {
        C1(const C1& c); // ok; nothing strange going on here
    };

    template<typename T>
    class C2 {
        C2(const C2& c, int i); // ok; no default arguments
    };

    template<typename T>
    class C3 {
        C3(const C3& c, int i = 1); // error [FALSE NEGATIVE]
    };

    template<typename T>
    class C4 {
        C4(const C4& c, T t = T::v); // error in instantiations where `T::v`
                                     // exists, otherwise ok
    };
}
