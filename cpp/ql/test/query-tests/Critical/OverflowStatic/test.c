
char xs[5];
struct {
    char ys[5];
    char zs[0];
} stru;

void f(void) {
    char c;

    c = xs[-1]; // BAD [NOT DETECTED]
    c = xs[0]; // GOOD
    c = xs[4]; // GOOD
    c = xs[5]; // BAD
    c = xs[6]; // BAD

    c = stru.ys[-1]; // BAD [NOT DETECTED]
    c = stru.ys[0]; // GOOD
    c = stru.ys[4]; // GOOD
    c = stru.ys[5]; // BAD
    c = stru.ys[6]; // BAD

    c = stru.zs[-1]; // BAD [NOT DETECTED]
    c = stru.zs[0]; // GOOD (zs is variable size)
    c = stru.zs[4]; // GOOD (zs is variable size)
    c = stru.zs[5]; // GOOD (zs is variable size)
    c = stru.zs[6]; // GOOD (zs is variable size)
}

void* malloc(long unsigned int);
void test_buffer_sentinal() {
  struct { char len; char buf[1]; } *b = malloc(10); // len(buf.buffer) effectively 8
  b->buf[0] = 0; // GOOD
  b->buf[7] = 0; // GOOD
  b->buf[8] = 0; // BAD [NOT DETECTED]
}

union u {
  unsigned long value;
  char ptr[1];
};

void union_test() {
  union u u;
  u.ptr[0] = 0; // GOOD
  u.ptr[sizeof(u)-1] = 0; // GOOD
  u.ptr[sizeof(u)] = 0; // BAD [NOT DETECTED]
}

void test_struct_union() {
  struct { union u u; } v;
  v.u.ptr[0] = 0; // GOOD
  v.u.ptr[sizeof(union u)-1] = 0; // GOOD
  v.u.ptr[sizeof(union u)] = 0; // BAD [NOT DETECTED]
}

void union_test2() {
  union { char ptr[1]; unsigned long value; } u;
  u.ptr[0] = 0; // GOOD
  u.ptr[sizeof(u)-1] = 0; // GOOD
  u.ptr[sizeof(u)] = 0; // BAD [NOT DETECTED]
}

typedef struct {
    char len;
    char buf[1];
} var_buf;

void test_alloc() {
  // Special case of taking sizeof without any addition or multiplications
  var_buf *b = malloc(sizeof(var_buf));
  b->buf[1] = 0; // BAD [NOT DETECTED]
}
