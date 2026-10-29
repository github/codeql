typedef int my_int;

template <typename Ta> void a(Ta t) {}
template <typename Tb> void b(Tb t) {}
template <typename Tc> void c(Tc t) {}
template <typename Td> void d(Td t) {}
template <typename Te> void e(Te t) {}
template <typename Tf> void f(Tf t) {}

void functions() {
  a(static_cast<int>(0));
  b(static_cast<my_int>(0));
  c<int>(0);
  d<my_int>(0);

  e<int>(0);
  e<my_int>(0);

  f<my_int>(0);
  f<int>(0);
}

template <typename TA> struct A {};
template <typename TB> struct B {};
template <typename TC> struct C {};
template <typename TD> struct D {};
template <typename TE> struct E {};
template <typename TF> struct F {};
template <typename TG> struct G {};
template <typename TH> struct H {};

struct S { int x; };
typedef S S_t;

typedef C<int> C1;
typedef D<my_int> D1;

template <typename TZ>
using Z = TZ;

void types() {
  A<int>* a;
  B<my_int>* b;
  C1 c;
  D1 d;

  E<int> e1;
  E<my_int> e2;
  E<Z<int>> e3;

  F<my_int> f1;
  F<int> f2;
  F<Z<int>> f3;

  H<Z<int>> h1;
  H<my_int> h2;
  H<int> h3;

  G<my_int*> g1;
  G<const my_int* const> g2;
  G<my_int**&> g3;
  G<my_int*(*)(my_int)> g4;
  G<my_int(&)[3]> g5;
  G<my_int S_t::*> g6;
  G<my_int __attribute__((vector_size(32)))> g7;
}
