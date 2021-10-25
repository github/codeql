// Wrong: floating point bit implementation exposed by union with bit field.
// Endianness and different floating-point implementations across architectures
// as well as different packing methods across compilers could make this behave
// incorrectly.
typedef union {
    float float_num;
    struct {
        unsigned sign : 1;
        unsigned exp : 8;
        unsigned fraction : 23;
    } bits;
} floatbits;
