char *malloc(int size);

void test1(int size) {
    char* p = malloc(size);
    char* q = p + size; // $ alloc=L4
    char a = *q; // $ deref=L6 // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ deref=L8+1 // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test2(int size) {
    char* p = malloc(size);
    char* q = p + size - 1; // $ alloc=L16
    char a = *q; // GOOD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ deref=L20 // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test3(int size) {
    char* p = malloc(size + 1);
    char* q = p + (size + 1); // $ alloc=L28+1
    char a = *q; // $ deref=L30 // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ deref=L32+1 // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test4(int size) {
    char* p = malloc(size - 1);
    char* q = p + (size - 1); // $ alloc=L40-1
    char a = *q; // $ deref=L42 // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ deref=L44+1 // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

char* mk_array(int size, char** end) {
    char* begin = malloc(size);
    *end = begin + size; // $ alloc=L52

    return begin;
}

void test5(int size) {
    char* end;
    char* begin = mk_array(size, &end);

    for (char* p = begin; p != end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = begin; p <= end; ++p) {
        *p = 0; // $ deref=L53->L62->L67 deref=L53->L66->L67 // BAD
    }

    for (char* p = begin; p < end; ++p) {
        *p = 0; // GOOD
    }
}

struct array_t {
    char* begin;
    char* end;
};

array_t mk_array(int size) {
    array_t arr;
    arr.begin = malloc(size);
    arr.end = arr.begin + size; // $ alloc=L82

    return arr;
}

void test6(int size) {
    array_t arr = mk_array(size);

    for (char* p = arr.begin; p != arr.end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr.begin; p <= arr.end; ++p) {
        *p = 0; // $ deref=L83->L91->L96 deref=L83->L95->L96 // BAD
    }

    for (char* p = arr.begin; p < arr.end; ++p) {
        *p = 0; // GOOD
    }
}

void test7_callee(array_t arr) {
    for (char* p = arr.begin; p != arr.end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr.begin; p <= arr.end; ++p) {
        *p = 0; // $ deref=L83->L105->L110 deref=L83->L109->L110 // BAD
    }

    for (char* p = arr.begin; p < arr.end; ++p) {
        *p = 0; // GOOD
    }
}

void test7(int size) {
    test7_callee(mk_array(size));
}

void test8(int size) {
    array_t arr;
    char* p = malloc(size);
    arr.begin = p;
    arr.end = p + size; // $ alloc=L124

    for (int i = 0; i < arr.end - arr.begin; i++) {
        *(arr.begin + i) = 0; // GOOD
    }

    for (int i = 0; i != arr.end - arr.begin; i++) {
        *(arr.begin + i) = 0; // GOOD
    }

    for (int i = 0; i <= arr.end - arr.begin; i++) {
        *(arr.begin + i) = 0; // BAD [NOT DETECTED]
    }
}

array_t *mk_array_p(int size) {
    array_t *arr = (array_t*) malloc(sizeof(array_t));
    arr->begin = malloc(size);
    arr->end = arr->begin + size; // $ alloc=L143

    return arr;
}

void test9(int size) {
    array_t *arr = mk_array_p(size);

    for (char* p = arr->begin; p != arr->end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr->begin; p <= arr->end; ++p) {
        *p = 0; // $ deref=L144->L156->L157 // BAD
    }

    for (char* p = arr->begin; p < arr->end; ++p) {
        *p = 0; // GOOD
    }
}

void test10_callee(array_t *arr) {
    for (char* p = arr->begin; p != arr->end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr->begin; p <= arr->end; ++p) {
        *p = 0; // $ deref=L144->L166->L171 deref=L144->L170->L171 // BAD
    }

    for (char* p = arr->begin; p < arr->end; ++p) {
        *p = 0; // GOOD
    }
}

void test10(int size) {
    test10_callee(mk_array_p(size));
}

void deref_plus_one(char* q) {
    char a = *(q + 1); // BAD [NOT DETECTED]
}

void test11(unsigned size) {
    char *p = malloc(size);
    char *q = p + size - 1; // $ alloc=L188
    deref_plus_one(q);
}

void test12(unsigned len, unsigned index) {
    char* p = (char *)malloc(len);
    char* end = p + len; // $ alloc=L194
    
    if(p + index > end) {
        return;
    }
    
    p[index] = '\0'; // $ deref=L201 // BAD
}

void test13(unsigned len, unsigned index) {
    char* p = (char *)malloc(len);
    char* end = p + len; // $ alloc=L205
    
    char* q = p + index;
    if(q > end) {
        return;
    }
    
    *q = '\0'; // $ deref=L213 // BAD
}

bool unknown();

void test14(unsigned long n, char *p) {
  while (unknown()) {
    n++;
    p = (char *)malloc(n);
    p[n - 1] = 'a'; // GOOD
  }
}

void test15(unsigned index) {
  unsigned size = index + 13;
  if(size < index) {
    return;
  }
  int* newname = new int[size];
  newname[index] = 0; // $ alloc=L231 deref=L232 // GOOD [FALSE POSITIVE]
}

void test16(unsigned index) {
  unsigned size = index + 13;
  if(size >= index) {
    int* newname = new int[size];
    newname[index] = 0; // $ alloc=L238 deref=L239 // GOOD [FALSE POSITIVE]
  }
}

void *realloc(void *, unsigned);

void test17(unsigned *p, unsigned x, unsigned k) {
    if(k > 0 && p[1] <= p[0]){
        unsigned n = 3*p[0] + k;
        p = (unsigned*)realloc(p, n);
        p[0] = n;
        unsigned i = p[1];
        // The following access is okay because:
        // n = 3*p[0] + k >= p[0] + k >= p[1] + k > p[1] = i
        // (where p[0] denotes the original value for p[0])
        p[i] = x; // $ alloc=L248 deref=L254 // GOOD [FALSE POSITIVE]
    }
}

void test17(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len; // $ alloc=L260
  for (int *x = xs; x <= end; x++)
  {
    int i = *x; // $ deref=L264 // BAD
  }
}

void test18(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len; // $ alloc=L270
  for (int *x = xs; x <= end; x++)
  {
    *x = 0; // $ deref=L274 // BAD
  }
}

void test19(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len; // $ alloc=L280
  for (int *x = xs; x < end; x++)
  {
    int i = *x; // GOOD
  }
}

void test20(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len; // $ alloc=L290
  for (int *x = xs; x < end; x++)
  {
    *x = 0; // GOOD
  }
}

void* test21_get(int n);

void test21() {
  int n = 0;
  while (test21_get(n)) n+=2;

  void** xs = new void*[n];

  for (int i = 0; i < n; i += 2) {
    xs[i] = test21_get(i); // GOOD
    xs[i+1] = test21_get(i+1); // $ alloc=L304 alloc=L304-1 deref=L308 // GOOD [FALSE POSITIVE]
  }
}

void test22(unsigned size, int val) {
  char *xs = new char[size];
  char *end = xs + size; // $ alloc=L313 // GOOD
  char **current = &end;
  do {
    if (*current - xs < 1) // GOOD
      return;
    *--(*current) = 0; // GOOD
      val >>= 8;
  } while (val > 0);
}

void test23(unsigned size, int val) {
  char *xs = new char[size];
  char *end = xs + size; // $ alloc=L325
  char **current = &end;

  if (val < 1) {
    if(*current - xs < 1)
      return;

    *--(*current) = 0; // GOOD
    return;
  }

  if (val < 2) {
    if(*current - xs < 2)
      return;

    *--(*current) = 0; // GOOD
    *--(*current) = 0; // GOOD
  }
}

void test24(unsigned size) {
  char *xs = new char[size];
  char *end = xs + size; // $ alloc=L347
  if (xs < end) {
    int val = *xs++; // GOOD
  }
}

void test25(unsigned size) {
  char *xs = new char[size];
  char *end = xs + size; // $ alloc=L355
  char *end_plus_one = end + 1;
  int val1 = *end_plus_one; // $ deref=L358+1 // BAD
  int val2 = *(end_plus_one + 1); // $ deref=L359+2 // BAD
}

void test26(unsigned size) {
  char *xs = new char[size];
  char *p = xs;
  char *end = p + size; // $ alloc=L363

  if (p + 4 <= end) {
    p += 4;
  }

  if (p < end) {
    int val = *p; // GOOD
  }
}

void test27(unsigned size, bool b) {
  char *xs = new char[size];
  char *end = xs + size; // $ alloc=L377

  if (b) {
    end++;
  }

  int val = *end; // $ deref=L384+1 // BAD
}

void test28(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L388
  if (xs >= end)
    return;
  xs++;
  if (xs >= end)
    return;
  xs[0] = 0;  // GOOD
}

void test28_simple(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L399
  if (xs < end) {
    xs++;
    if (xs < end) {
      xs[0] = 0;  // GOOD
    }
  }
}

void test28_simple2(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L410
  if (xs < end) {
    xs++;
    if (xs < end + 1) {
      xs[0] = 0; // $ deref=L415 // BAD
    }
  }
}

void test28_simple3(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L421
  if (xs < end) {
    xs++;
    if (xs - 1 < end) {
      xs[0] = 0; // $ deref=L426 // BAD
    }
  }
}

void test28_simple4(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L432
  if (xs < end) {
    end++;
    xs++;
    if (xs < end) {
      xs[0] = 0; // $ deref=L438 // BAD
    }
  }
}

void test28_simple5(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L444
  end++;
  if (xs < end) {
    xs++;
    if (xs < end) {
      xs[0] = 0; // $ deref=L450 // BAD
    }
  }
}

void test28_simple6(unsigned size) {
  char *xs = new char[size + 1];
  char *end = &xs[size];
  end++;
  if (xs < end) {
    xs++;
    if (xs < end) {
      xs[0] = 0;  // GOOD
    }
  }
}

void test28_simple7(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L468
  end++;
  if (xs < end) {
    xs++;
    if (xs < end - 1) {
      xs[0] = 0;  // GOOD
    }
  }
}

void test28_simple8(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L480
  end += 500;
  if (xs < end) {
    xs++;
    if (xs < end - 1) {
      xs[0] = 0; // $ deref=L486+498 // BAD
    }
  }
}

struct test29_struct {
  char* xs;
};

void test29(unsigned size) {
  test29_struct val;
  val.xs = new char[size];
  size++;
  val.xs = new char[size];
  val.xs[size - 1] = 0; // GOOD
}

void test30(int *size)
{
  int new_size = 0, tmp_size = 0;

  test30(&tmp_size);
  if (tmp_size + 1 > new_size) {
    new_size = tmp_size + 1;
    char *xs = new char[new_size];
    for (int i = 0; i < new_size; i++) {
      xs[i] = 0;  // GOOD
    }
  }
  *size = new_size;
}

void test31(unsigned size, unsigned src_pos)
{
  char *xs = new char[size];
  if (src_pos > size) {
    src_pos = size;
  }
  unsigned dst_pos = src_pos;
  if (dst_pos < size - 3) {
    xs[dst_pos++] = 0; // GOOD
  }
}

void test31_simple1(unsigned size, unsigned src_pos)
{
  char *xs = new char[size];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos < size) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple2(unsigned size, unsigned src_pos)
{
  char *xs = new char[size];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos < size + 1) {
    xs[src_pos] = 0; // $ alloc=L543 deref=L548 // BAD
  }
}

void test31_simple3(unsigned size, unsigned src_pos)
{
  char *xs = new char[size];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos - 1 < size) {
    xs[src_pos] = 0; // $ alloc=L554 deref=L559 // BAD
  }
}

void test31_simple4(unsigned size, unsigned src_pos)
{
  char *xs = new char[size];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos < size - 1) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple5(unsigned size, unsigned src_pos)
{
  char *xs = new char[size];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos + 1 < size) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple1_plus1(unsigned size, unsigned src_pos)
{
  char *xs = new char[size + 1];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos < size) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple2_plus1(unsigned size, unsigned src_pos)
{
  char *xs = new char[size + 1];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos < size + 1) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple3_plus1(unsigned size, unsigned src_pos)
{
  char *xs = new char[size + 1];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos - 1 < size) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple4_plus1(unsigned size, unsigned src_pos)
{
  char *xs = new char[size + 1];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos < size - 1) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple5_plus1(unsigned size, unsigned src_pos)
{
  char *xs = new char[size + 1];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos + 1 < size) {
    xs[src_pos] = 0; // GOOD
  }
}

void test31_simple1_sub1(unsigned size, unsigned src_pos)
{
  char *xs = new char[size - 1];
  if (src_pos > size) {
    src_pos = size;
  }
  if (src_pos < size) {
    xs[src_pos] = 0; // $ alloc=L642-1 deref=L647 // BAD
  }
}

void test32(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L652
  if (xs >= end)
    return;
  xs++;
  if (xs >= end)
    return;
  xs++;
  if (xs >= end)
    return;
  xs[0] = 0; // $ deref=L656->L662+1 deref=L657->L662+1 GOOD [FALSE POSITIVE]
}

void test33(unsigned size, unsigned src_pos)
{
  char *xs = new char[size + 1];
  if (src_pos > size) {
    src_pos = size;
  }
  unsigned dst_pos = src_pos;
  while (dst_pos < size - 1) {
    dst_pos++;
    if (true)
      xs[dst_pos++] = 0; // $ alloc=L667+1 deref=L675 // GOOD [FALSE POSITIVE]
  }
}

int* pointer_arithmetic(int *p, int offset) {
  return p + offset; // $ alloc=L684
}

void test_missing_call_context_1(unsigned size) {
  int* p = new int[size];
  int* end = pointer_arithmetic(p, size);
}

void test_missing_call_context_2(unsigned size) {
  int* p = new int[size];
  int* end_minus_one = pointer_arithmetic(p, size - 1);
  *end_minus_one = '0'; // $ deref=L680->L690->L691 // GOOD
}

void test34(unsigned size) {
  char *p = new char[size];
  char *end = p + size + 1; // $ alloc=L695
  if (p + 1 < end) {
    p += 1;
  }
  if (p + 1 < end) {
    int val = *p; // $ deref=L698->L700->L701 // GOOD [FALSE POSITIVE]
  }
}

void deref(char* q) {
  char x = *q; // $ deref=L714->L705->L706 // BAD
}

void test35(unsigned long size, char* q)
{
  char* p = new char[size];
  char* end = p + size; // $ alloc=L711
  if(q <= end) {
    deref(q);
  }
}
