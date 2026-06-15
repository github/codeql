using size_t = decltype(sizeof 0); void* malloc(size_t size);

void test1(int size) {
    char* p = (char*)malloc(size);
    char* q = p + size; // $ alloc=L4
    char a = *q; // $ deref=L5->L6 // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ deref=L5->L8+1 // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test2(int size) {
    char* p = (char*)malloc(size);
    char* q = p + size - 1; // $ alloc=L16
    char a = *q; // GOOD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ deref=L17->L20 // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test3(int size) {
    char* p = (char*)malloc(size + 1);
    char* q = p + (size + 1); // $ alloc=L28+1
    char a = *q; // $ deref=L29->L30 // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ deref=L29->L32+1 // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test4(int size) {
    char* p = (char*)malloc(size - 1);
    char* q = p + (size - 1); // $ MISSING: alloc=L40-1
    char a = *q; // $ MISSING: deref=L42 // BAD [NOT DETECTED]
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // $ MISSING: deref=L44+1 // BAD [NOT DETECTED]
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

char* mk_array(int size, char** end) {
    char* begin = (char*)malloc(size);
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
    arr.begin = (char*)malloc(size);
    arr.end = arr.begin + size; // $ MISSING: alloc=L82

    return arr;
}

void test6(int size) {
    array_t arr = mk_array(size);

    for (char* p = arr.begin; p != arr.end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr.begin; p <= arr.end; ++p) {
        *p = 0; // $ MISSING: deref=L83->L91->L96 deref=L83->L95->L96 // BAD [NOT DETECTED]
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
        *p = 0; // $ MISSING: deref=L83->L105->L110 deref=L83->L109->L110 // BAD [NOT DETECTED]
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
    char* p = (char*)malloc(size);
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
    arr->begin = (char*)malloc(size);
    arr->end = arr->begin + size; // $ MISSING: alloc=L143

    return arr;
}

void test9(int size) {
    array_t *arr = mk_array_p(size);

    for (char* p = arr->begin; p != arr->end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr->begin; p <= arr->end; ++p) {
        *p = 0; // $ MISSING: deref=L144->L156->L157 // BAD [NOT DETECTED]
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
        *p = 0; // $ MISSING: deref=L144->L166->L171 deref=L144->L170->L171 // BAD [NOT DETECTED]
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
    char *p = (char*)malloc(size);
    char *q = p + size - 1; // $ alloc=L188
    deref_plus_one(q);
}

void test12(unsigned len, unsigned index) {
    char* p = (char *)malloc(len);
    char* end = p + len; // $ alloc=L194
    
    if(p + index > end) {
        return;
    }
    
    p[index] = '\0'; // $ MISSING: deref=L195->L201 // BAD [NOT DETECTED]
}

void test13(unsigned len, unsigned index) {
    char* p = (char *)malloc(len);
    char* end = p + len; // $ alloc=L205
    
    char* q = p + index;
    if(q > end) {
        return;
    }
    
    *q = '\0'; // $ deref=L206->L213 // BAD
}

bool unknown();

void test14(size_t n, char *p) {
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
  newname[index] = 0; // GOOD
}

void test16(unsigned index) {
  unsigned size = index + 13;
  if(size >= index) {
    int* newname = new int[size];
    newname[index] = 0; // GOOD
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
        p[i] = x; // GOOD
    }
}

void test17(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len; // $ alloc=L260
  for (int *x = xs; x <= end; x++)
  {
    int i = *x; // $ deref=L261->L264 // BAD
  }
}

void test18(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len; // $ alloc=L270
  for (int *x = xs; x <= end; x++)
  {
    *x = 0; // $ deref=L271->L274 // BAD
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
    xs[i+1] = test21_get(i+1); // GOOD
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
  int val1 = *end_plus_one; // $ deref=L356->L358+1 // BAD
  int val2 = *(end_plus_one + 1); // $ deref=L356->L359+2 // BAD
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

  int val = *end; // $ deref=L378->L384+1 // BAD
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
      xs[0] = 0; // $ deref=L411->L415 // BAD
    }
  }
}

void test28_simple3(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size]; // $ alloc=L421
  if (xs < end) {
    xs++;
    if (xs - 1 < end) {
      xs[0] = 0; // $ deref=L422->L426 // BAD
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
      xs[0] = 0; // $ deref=L433->L438 // BAD
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
      xs[0] = 0; // $ deref=L445->L450 // BAD
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
      xs[0] = 0; // $ deref=L481->L486+498 // BAD
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
  xs[0] = 0; // GOOD
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
      xs[dst_pos++] = 0; // GOOD
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
    int val = *p; // GOOD
  }
}

void deref(char* q) {
  char x = *q; // $ MISSING: deref=L714->L705->L706 // BAD [NOT DETECTED]
}

void test35(size_t size, char* q)
{
  char* p = new char[size];
  char* end = p + size; // $ alloc=L711
  if(q <= end) {
    deref(q);
  }
}

void test21_simple(bool b) {
  int n = 0;
  if (b) n = 2;

  int* xs = new int[n];

  for (int i = 0; i < n; i += 2) {
    xs[i+1] = 0; // GOOD
  }
}

void test36(unsigned size, unsigned n) {
  int* p = new int[size + 2];
  if(n < size + 1) {
    int* end = p + (n + 2); // $ alloc=L730+2
    *end = 0; // $ deref=L732->L733 // BAD
  }
}

void test37(size_t n)
{
  int *p = new int[n];
  for (size_t i = n; i != 0u; i--)
  {
    p[n - i] = 0; // GOOD
  }
}

unsigned get(char);
void exit(int);

void error(const char * msg) {
  exit(1);
}

void test38(unsigned size) {
  char * alloc = new char[size];

  unsigned pos = 0;
  while (pos < size) {
    char kind = alloc[pos];
    unsigned n = get(alloc[pos]);
    if (pos + n >= size) {
      error("");
    }
    switch (kind) {
    case '0':
      if (n != 1)
        error("");
      char x = alloc[pos + 1]; // $ alloc=L754 deref=L767 // GOOD [FALSE POSITIVE]
      break;
    case '1':
      if (n != 2)
        error("");
      char a = alloc[pos + 1]; // $ alloc=L754 deref=L772 // GOOD [FALSE POSITIVE]
      char b = alloc[pos + 2];
      break;
    }
    pos += 1 + n;
  }
}

void test38_simple(unsigned size, unsigned pos, unsigned numParams) {
  char * p = new char[size];

  if (pos < size) {
    if (pos + numParams < size) {
      if (numParams == 1) {
        char x = p[pos + 1]; // $ alloc=L781 deref=L786 // GOOD [FALSE POSITIVE]
      }
    }
  }
}

void mk_array_no_field_flow(int size, char** begin, char** end) {
    *begin = (char*)malloc(size);
    *end = *begin + size; // $ alloc=L793
}

void test6_no_field_flow(int size) {
  char* begin;
  char* end;
  mk_array_no_field_flow(size, &begin, &end);

  for (char* p = begin; p != end; ++p) {
      *p = 0; // GOOD
  }

  for (char* p = begin; p <= end; ++p) {
      *p = 0; // $ deref=L794->L802->L807 deref=L794->L806->L807 // BAD
  }

  for (char* p = begin; p < end; ++p) {
      *p = 0; // GOOD
  }
}

void test7_callee_no_field_flow(char* begin, char* end) {
  for (char* p = begin; p != end; ++p) {
      *p = 0; // GOOD
  }

  for (char* p = begin; p <= end; ++p) {
      *p = 0; // $ deref=L794->L815->L821 deref=L794->L816->L821 deref=L794->L820->L821 // BAD
  }

  for (char* p = begin; p < end; ++p) {
      *p = 0; // GOOD
  }
}

void test7_no_field_flow(int size) {
  char* begin;
  char* end;
  mk_array_no_field_flow(size, &begin, &end);
  test7_callee_no_field_flow(begin, end);
}

void test15_with_malloc(size_t index) {
  size_t size = index + 13;
  if(size < index) {
    return;
  }
  int* newname = (int*)malloc(size);
  newname[index] = 0; // $ SPURIOUS: alloc=L841 deref=L842 // GOOD [FALSE POSITIVE]
}

void test16_with_malloc(size_t index) {
  size_t size = index + 13;
  if(size >= index) {
    int* newname = (int*)malloc(size);
    newname[index] = 0; // $ SPURIOUS: alloc=L848 deref=L849 // GOOD [FALSE POSITIVE]
  }
}

# define MyMalloc(size) malloc(((size) == 0 ? 1 : (size)))

void test_regression(size_t size) {
  int* p = (int*)MyMalloc(size + 1);
  int* chend = p + (size + 1); // $ alloc=L856+1

  if(p <= chend) {
    *p = 42; // $ deref=L857->L860 // BAD
  }
}


void* g_malloc(size_t size);

void test17(int size) {
    char* p = (char*)g_malloc(size);
    char* q = p + size; // $ alloc=L868
    char a = *q; // $ deref=L869->L870 // BAD
}