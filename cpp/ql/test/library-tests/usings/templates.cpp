namespace std {
    template <typename> struct a;
    typedef a<bool> b;
}
namespace d {
    enum { c };
}
namespace std {
    using d::c;
}
