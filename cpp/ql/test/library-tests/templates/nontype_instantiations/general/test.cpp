// semmle-extractor-options: --edg --trap_container=folder --edg --trap-compression=none
template<int x>
struct C { };

static const int one1 = 1, one2 = 1;
C<one1> c = C<one2>();
C<one1 + one2> e;

template<typename T, T X>
struct D { };

D<int, 2> a;
D<long, 2> b;

template<typename T, T* X>
struct E { };

E<int, nullptr> z;

