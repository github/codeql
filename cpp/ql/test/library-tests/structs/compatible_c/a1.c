// Note: files `a1.c` and `a2.c` are completely identical.

// The structs behind the two `anon_empty_t` types in `a1.c` and `a2.c` are
// extracted as anonymous structs. We should still identify them as the same
// struct, since they are considered compatible types according to the language.
typedef struct { } anon_empty_t;

// This is another anonymous struct - we should identify all instances of
// `anon_nonempty_t` as the same struct, but distinct from `anon_empty_t`.
typedef struct {
  int x;
} anon_nonempty_t;

// We'd like to identify all instances of `another_anon_t` as the same, but
// distinct from `anon_nonempty_t`. The only difference between them is the
// typedef'd name.
typedef struct {
  int x;
} another_anon_t;

// If we incorrectly identify the `anon_empty_t` definitions in `a1.c` and `a2.c`
// as different structs (or for `anon_nonempty_t`), then our analysis will
// overcount the number of fields in `Foo`.
struct Foo {
    anon_empty_t    *empty;
    anon_nonempty_t *nonempty;
    int i;
};

struct Empty { };

struct NonEmpty {
  int x;
};

struct Bar {
    struct Empty *empty;
    struct NonEmpty *nonempty;
    int i;
};
