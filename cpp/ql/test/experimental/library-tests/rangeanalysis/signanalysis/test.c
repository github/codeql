struct List {
  struct List* next;
};

int test1(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count = count+1;
  }
  return count;
}

int test2(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count = (count+1) % 10;
  }
  return count;
}

int test3(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count++;
    count = count % 10;
  }
  return count;
}

int test4() {
  int i = 0;
  int total = 0;
  for (i = 0; i < 2; i = i+1) {
    total += i;
  }
  return total + i;
}

int test5() {
  int i = 0;
  int total = 0;
  for (i = 0; i < 2; i++) {
    total += i;
  }
  return total + i;
}

int test6() {
  int i = 0;
  int total = 0;
  for (i = 0; i+2 < 4; i = i+1) {
    total += i;
  }
  return total + i;
}

int test7(int i) {
  if (i < 4) {
    if (i < 5) {
      return i;
    }
  }
  return 1;
}

int test8(int x, int y) {
  if (-1000 < y && y < 10) {
    if (x < y-2) {
      return x;
    }
  }
  return y;
}

int test9(int x, int y) {
  if (y == 0) {
    if (x < 4) {
      return 0;
    }
  } else {
    if (x < 4) {
      return 1;
    }
  }
  return x;
}

int test10(int x, int y) {
  if (y > 7) {
    if (x < y) {
      return 0;
    }
    return x;
  }
  return 1;
}

int test11(char *p) {
  char c;
  c = *p;
  if (c != '\0')
    *p++ = '\0';

  if (c == ':') {
    c = *p;
    if (c != '\0')
      *p++ = '\0';

    if (c != ',')
      return 1;
  }
  return 0;
}

typedef unsigned long long size_type;

size_type test12_helper() {
  static size_type n = 0;
  return n++;
}

int test12() {
   size_type Start = 0;
   while (Start <= test12_helper()-1)
   {
     const size_type Length = test12_helper();
     Start += Length + 1;
   }

   return 1;
}

// Tests for overflow conditions.
int test13(char c, int i) {
  unsigned char uc = c;
  unsigned int x = 0;
  unsigned int y = x-1;
  int z = i+1;
  return (double)(c + i + uc + x + y + z);
}

// Regression test for ODASA-6013.
int test14(int x) {
  int x0 = (int)(char)x;
  int x1 = (int)(unsigned char)x;
  int x2 = (int)(unsigned short)x;
  int x3 = (int)(unsigned int)x;
  char c0 = x;
  unsigned short s0 = x;
  return x0 + x1 + x2 + x3 + c0 + s0;
}

long long test15(long long x) {
  return (x > 0 && x == (int)x) ? x : -1;
}

// Tests for unary operators.
int test_unary(int a) {
  int total = 0;

  if (3 <= a && a <= 11) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (0 <= a && a <= 11) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= 11) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= 1) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= 0) {
    int b = +a;
    int c = -a;
    total += b+c;
  }
  if (-7 <= a && a <= -2) {
    int b = +a;
    int c = -a;
    total += b+c;
  }

  return total;
}


// Tests for multiplication.
int test_mult01(int a, int b) {
  int total = 0;

  if (3 <= a && a <= 11 && 5 <= b && b <= 23) {
    int r = a*b;  // 15 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && 0 <= b && b <= 23) {
    int r = a*b;  // 0 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= 23) {
    int r = a*b;  // -143 .. 253
    total += r;
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= 0) {
    int r = a*b;  // -143 .. 0
    total += r;
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= -7) {
    int r = a*b;  // -143 .. -21
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult02(int a, int b) {
  int total = 0;

  if (0 <= a && a <= 11 && 5 <= b && b <= 23) {
    int r = a*b;  // 0 .. 253
    total += r;
  }
  if (0 <= a && a <= 11 && 0 <= b && b <= 23) {
    int r = a*b;  // 0 .. 253
    total += r;
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= 23) {
    int r = a*b;  // -143 .. 253
    total += r;
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= 0) {
    int r = a*b;  // -143 .. 0
    total += r;
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= -7) {
    int r = a*b;  // -143 .. 0
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult03(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= 11 && 5 <= b && b <= 23) {
    int r = a*b;  // -391 .. 253
    total += r;
  }
  if (-17 <= a && a <= 11 && 0 <= b && b <= 23) {
    int r = a*b;  // -391 .. 253
    total += r;
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= 23) {
    int r = a*b;  // -391 .. 253
    total += r;
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= 0) {
    int r = a*b;  // -143 .. 221
    total += r;
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= -7) {
    int r = a*b;  // -143 .. 221
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult04(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= 0 && 5 <= b && b <= 23) {
    int r = a*b;  // -391 .. 0
    total += r;
  }
  if (-17 <= a && a <= 0 && 0 <= b && b <= 23) {
    int r = a*b;  // -391 .. 0
    total += r;
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= 23) {
    int r = a*b;  // -391 .. 221
    total += r;
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= 0) {
    int r = a*b;  // 0 .. 221
    total += r;
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= -7) {
    int r = a*b;  // 0 .. 221
    total += r;
  }

  return total;
}

// Tests for multiplication.
int test_mult05(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= -2 && 5 <= b && b <= 23) {
    int r = a*b;  // -391 .. -10
    total += r;
  }
  if (-17 <= a && a <= -2 && 0 <= b && b <= 23) {
    int r = a*b;  // -391 .. 0
    total += r;
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= 23) {
    int r = a*b;  // -391 .. 221
    total += r;
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= 0) {
    int r = a*b;  // 0 .. 221
    total += r;
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= -7) {
    int r = a*b;  // 14 .. 221
    total += r;
  }

  return total;
}

int test16(int x) {
  int d, i = 0;
  if (x < 0) {
    return -1;
  }

  while (i < 3) {
    i++;
  }
  d = i;
  if (x < 0) {  // Comparison is always false.
    if (d > -x) {  // Unreachable code.
      return 1;
    }
  }
  return 0;
}

// Test ternary expression upper bounds.
unsigned int test_ternary01(unsigned int x) {
  unsigned int y1, y2, y3, y4, y5, y6, y7, y8;
  y1 = x < 100 ? x : 10;  // y1 < 100
  y2 = x >= 100 ? 10 : x;  // y2 < 100
  y3 = 0;
  y4 = 0;
  y5 = 0;
  y6 = 0;
  y7 = 0;
  y8 = 0;
  if (x < 300) {
    y3 = x ?: 5; // y3 < 300
    y4 = x ?: 500; // y4 <= 500
    y5 = (x+1) ?: 500; // y5 <= 300
    y6 = ((unsigned char)(x+1)) ?: 5; // y6 < 256
    y7 = ((unsigned char)(x+1)) ?: 500; // y7 <= 500
    y8 = ((unsigned short)(x+1)) ?: 500; // y8 <= 300
  }
  return y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8;
}

// Test ternary expression lower bounds.
unsigned int test_ternary02(unsigned int x) {
  unsigned int y1, y2, y3, y4, y5;
  y1 = x > 100 ? x : 110;  // y1 > 100
  y2 = x <= 100 ? 110 : x;  // y2 > 100
  y3 = 1000;
  y4 = 1000;
  y5 = 1000;
  if (x >= 300) {
    y3 = (x-300) ?: 5; // y3 >= 0
    y4 = (x-200) ?: 5; // y4 >= 100
    y5 = ((unsigned char)(x-200)) ?: 5; // y6 >= 0
  }
  return y1 + y2 + y3 + y4 + y5;
}

// Test the comma expression.
unsigned int test_comma01(unsigned int x) {
  unsigned int y = x < 100 ? x : 100;
  unsigned int y1;
  unsigned int y2;
  y1 = (++y, y);
  y2 = (y++, y += 3, y);
  return y1 + y2;
}
