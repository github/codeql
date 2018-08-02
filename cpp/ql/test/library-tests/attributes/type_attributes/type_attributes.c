// Compilable with
// gcc   -c type_attributes.c
// clang -c type_attributes.c

struct __attribute__((__packed__)) my_packed_struct {
    char c;
    int i;
};

typedef union __attribute__((__transparent_union__)) {
    int i;
    int j;
} tu;

// This union can't be made transparent, as the types aren't the same size
typedef union __attribute__((__transparent_union__)) {
    char c;
    long long int j;
} notTransparent;

typedef __attribute__((unused)) int unusedInt;

typedef int depInt __attribute__ ((deprecated));

typedef short __attribute__((__may_alias__)) short_a;

