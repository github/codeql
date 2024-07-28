struct _GUID {
    char a[16];
};

struct __declspec(uuid("{01234567-89ab-cdef-0123-456789ABCDEF}")) S {};
struct __declspec(uuid("FEDCBA98-7654-3210-fedc-ba9876543210")) T {};
template<typename U> struct Templ {};
S ReturnS();

void GetUUID() {
    _GUID uuid = __uuidof(S);
    const _GUID& r = __uuidof(T);
    const _GUID* p = &__uuidof(S);
    uuid = __uuidof(ReturnS());
    uuid = __uuidof(Templ<S>);
    S s;
    uuid = __uuidof(s);
    uuid = __uuidof(0);
}

template <typename Placeholder, typename ...>
auto Wrapper = __uuidof(Placeholder);
auto inst = Wrapper<S>;

// semmle-extractor-options: --microsoft
