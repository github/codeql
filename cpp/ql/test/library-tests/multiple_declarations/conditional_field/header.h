// When this header is included both with and without `S_HAS_A` defined, the
// struct ends up with three fields: one copy of `a` at position 0, a copy of
// `b` at position 0, and a copy of `b` at position 1.

struct S {
#ifdef S_HAS_A
    int a;
#endif
    int b;
};
