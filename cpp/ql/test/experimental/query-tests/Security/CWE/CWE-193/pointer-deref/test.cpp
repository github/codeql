char *malloc(int size);

void test1(int size) {
    char* p = malloc(size);
    char* q = p + size;
    char a = *q; // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test2(int size) {
    char* p = malloc(size);
    char* q = p + size - 1;
    char a = *q; // GOOD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test3(int size) {
    char* p = malloc(size + 1);
    char* q = p + (size + 1);
    char a = *q; // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

void test4(int size) {
    char* p = malloc(size - 1);
    char* q = p + (size - 1);
    char a = *q; // BAD
    char b = *(q - 1); // GOOD
    char c = *(q + 1); // BAD
    char d = *(q + size); // BAD [NOT DETECTED]
    char e = *(q - size); // GOOD
    char f = *(q + size + 1); // BAD [NOT DETECTED]
    char g = *(q - size - 1); // GOOD
}

char* mk_array(int size, char** end) {
    char* begin = malloc(size);
    *end = begin + size;

    return begin;
}

void test5(int size) {
    char* end;
    char* begin = mk_array(size, &end);

    for (char* p = begin; p != end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = begin; p <= end; ++p) {
        *p = 0; // BAD
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
    arr.end = arr.begin + size;

    return arr;
}

void test6(int size) {
    array_t arr = mk_array(size);

    for (char* p = arr.begin; p != arr.end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr.begin; p <= arr.end; ++p) {
        *p = 0; // BAD
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
        *p = 0; // BAD
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
    arr.end = p + size;

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
    arr->end = arr->begin + size;

    return arr;
}

void test9(int size) {
    array_t *arr = mk_array_p(size);

    for (char* p = arr->begin; p != arr->end; ++p) {
        *p = 0; // GOOD
    }

    for (char* p = arr->begin; p <= arr->end; ++p) {
        *p = 0; // BAD
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
        *p = 0; // BAD
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
    char *q = p + size - 1;
    deref_plus_one(q);
}

void test12(unsigned len, unsigned index) {
    char* p = (char *)malloc(len);
    char* end = p + len;
    
    if(p + index > end) {
        return;
    }
    
    p[index] = '\0'; // BAD
}

void test13(unsigned len, unsigned index) {
    char* p = (char *)malloc(len);
    char* end = p + len;
    
    char* q = p + index;
    if(q > end) {
        return;
    }
    
    *q = '\0'; // BAD
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
  newname[index] = 0; // GOOD [FALSE POSITIVE]
}

void test16(unsigned index) {
  unsigned size = index + 13;
  if(size >= index) {
    int* newname = new int[size];
    newname[index] = 0; // GOOD [FALSE POSITIVE]
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
        p[i] = x; // GOOD [FALSE POSITIVE]
    }
}

void test17(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len;
  for (int *x = xs; x <= end; x++)
  {
    int i = *x; // BAD
  }
}

void test18(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len;
  for (int *x = xs; x <= end; x++)
  {
    *x = 0; // BAD
  }
}

void test19(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len;
  for (int *x = xs; x < end; x++)
  {
    int i = *x; // GOOD
  }
}

void test20(unsigned len)
{
  int *xs = new int[len];
  int *end = xs + len;
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
    xs[i+1] = test21_get(i+1); // GOOD [FALSE POSITIVE]
  }
}

void test22(unsigned size, int val) {
  char *xs = new char[size];
  char *end = xs + size; // GOOD
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
  char *end = xs + size;
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
  char *end = xs + size;
  if (xs < end) {
    int val = *xs++; // GOOD
  }
}

void test25(unsigned size) {
  char *xs = new char[size];
  char *end = xs + size;
  char *end_plus_one = end + 1;
  int val1 = *end_plus_one; // BAD
  int val2 = *(end_plus_one + 1); // BAD
}

void test26(unsigned size) {
  char *xs = new char[size];
  char *p = xs;
  char *end = p + size;

  if (p + 4 <= end) {
    p += 4;
  }

  if (p < end) {
    int val = *p; // GOOD [FALSE POSITIVE]
  }
}

void test27(unsigned size, bool b) {
  char *xs = new char[size];
  char *end = xs + size;

  if (b) {
    end++;
  }

  int val = *end; // BAD
}

void test28(unsigned size) {
  char *xs = new char[size];
  char *end = &xs[size];
    if (xs >= end)
      return;
    xs++;
    if (xs >= end)
      return;
    xs[0] = 0;  // GOOD [FALSE POSITIVE]
}

struct test29_struct {
  char* xs;
};

void test29(unsigned size) {
  test29_struct val;
  val.xs = new char[size];
  size++;
  val.xs = new char[size];
  val.xs[size - 1] = 0; // GOOD [FALSE POSITIVE]
}

void test30(int *size)
{
  int new_size = 0, tmp_size = 0;

  test30(&tmp_size);
  if (tmp_size + 1 > new_size) {
    new_size = tmp_size + 1;
    char *xs = new char[new_size];
    for (int i = 0; i < new_size; i++) {
      xs[i] = 0;  // GOOD [FALSE POSITIVE]
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
  if(dst_pos < size - 3) {
    xs[dst_pos++] = 0; // GOOD [FALSE POSITIVE]
  }
}
