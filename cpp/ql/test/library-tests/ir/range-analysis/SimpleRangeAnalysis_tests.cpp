#include "test_util.h"

struct List {
  struct List* next;
};

int test1(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count = count+1;
    range(count); // $ range="==Phi: p | Store: count+1"
  }
  range(count);
  return count;
}

int test2(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    count = (count+1) % 10;
    range(count); // $ range=<=9 range=>=-9
  }
  range(count); // $ range=>=-9 range=<=9
  return count;
}

int test3(struct List* p) {
  int count = 0;
  for (; p; p = p->next) {
    range(count++); // $ range=>=-9 range=<=9
    count = count % 10;
    range(count); // $ range=<=9 range=>=-9
  }
  range(count); // $ range=>=-9 range=<=9
  return count;
}

int test4() {
  int i = 0;
  int total = 0;
  for (i = 0; i < 2; i = i+1) {
    range(i); // $ range=<=1 range=>=0
    range(total);
    total += i;
    range(total); // $ range="<=Phi: i+1" MISSING: range=>=0 range=>=i+0
  }
  range(total); // $ MISSING: range=>=0
  range(i); // $ range===2
  range(total + i); // $ range="<=Phi: i+2" MISSING: range===i+2 range=>=2 range=>=i+0 
  return total + i;
}

int test5() {
  int i = 0;
  int total = 0;
  for (i = 0; i < 2; i++) {
    range(i); // $ range=<=1 range=>=0
    range(total); // $ MISSING: range=>=0
    total += i;
    range(total); // $ range="<=Phi: i+1" MISSING: range=>=0 range=>=i+0
  }
  range(total); // $ MISSING: range=>=0
  range(i); // $ range===2
  range(total + i); // $ range="<=Phi: i+2" MISSING: range===i+2 range=>=2 range=>=i+0
  return total + i;
}

int test6() {
  int i = 0;
  int total = 0;
  for (i = 0; i+2 < 4; i = i+1) {
    range(i); // $ range=<=1 range=>=0
    range(total); // $ MISSING: range=>=0
    total += i;
    range(total); // $ range="<=Phi: i+1" MISSING: range=>=0 range=>=i+0
  }
  return total + i;
}

int test7(int i) {
  if (i < 4) {
    if (i < 5) {
      range(i); // $ range=<=3
      return i;
    }
    range(i); // $ range=<=3 range=>=5
  }
  range(i);
  return 1;
}

int test8(int x, int y) {
  if (-1000 < y && y < 10) {
    range(y); // $ range=<=9 range=>=-999
    if (x < y-2) {
      range(x); // $ range=<=6 range="<=InitializeParameter: y | Store: y-3"
      range(y); // $ range=<=9 range=>=-999 range=">=InitializeParameter: x | Store: x+3"
      return x;
    }
    range(x); // $ range=>=-1001 range=">=InitializeParameter: y | Store: y-2"
    range(y); // $ range=<=9 range="<=InitializeParameter: x | Store: x+2" range=>=-999
  }
  range(x);
  range(y);
  return y;
}

int test9(int x, int y) {
  if (y == 0) {
    if (x < 4) {
      range(x); // $ range=<=3
      return 0;
    }
    range(x); // $ range=>=4
  } else {
    if (x < 4) {
      range(x); // $ range=<=3
      return 1;
    }
    range(x); // $ range=>=4
  }
  range(x); // $ MISSING: range=>=4
  return x;
}

int test10(int x, int y) {
  if (y > 7) {
    range(y); // $ range=>=8
    if (x < y) {
      range(x); // $ range="<=InitializeParameter: y-1"
      range(y); // $ range=>=8 range=">=InitializeParameter: x | Store: x+1"
      return 0;
    }
    range(x); // $ range=>=8 range=">=InitializeParameter: y+0"
    range(y); // $ range="<=InitializeParameter: x | Store: x+0" range=>=8
    return x;
  }
  range(y); // $ range=<=7
  return 1;
}

int test11(char *p) {
  char c;
  c = *p;
  range(*p);
  if (c != '\0') {
    *p++ = '\0';
    range(p); // $ range="==InitializeParameter: p+1"
    range(*p);
  }
  if (c == ':') {
    range(c); // $ range===58
    c = *p;
    range(*p);
    if (c != '\0') {
      range(c);
      *p++ = '\0';
      range(p); // $ range="<=InitializeParameter: p+2" range="==Phi: c+1" range=">=InitializeParameter: p+1"
    }
    if (c != ',') {
      return 1;
    }
  }
  return 0;
}

typedef unsigned long long size_type;

size_type test12_helper() {
  static size_type n = 0;
  return n++; // $ overflow=+
}

int test12() {
   size_type Start = 0;
   while (Start <= test12_helper()-1)
   {
    range(Start); // $ MISSING:range=>=0
    const size_type Length = test12_helper();
    Start += Length + 1; // $ overflow=+
    range(Start); // $ MISSING:range=>=1 MISSING:range=>=Start+1 MISSING:range=">=call to test12_helper+1"
   }
   range(Start); // $ MISSING:range=>=0

   return 1;
}

// Tests for overflow conditions.
int test13(char c, int i) {
  unsigned char uc = c;
  range(uc);
  unsigned int x = 0;
  unsigned int y = x-1;  // $ overflow=-
  range(y); // $ range===-1 overflow=-
  int z = i+1;  // $ overflow=+
  range(z); // $ range="==InitializeParameter: i+1"
  range(c + i + uc + x + y + z); // $ overflow=+- overflow=+ overflow=- MISSING: range=>=1
  range((double)(c + i + uc + x + y + z)); // $ overflow=+ overflow=+- overflow=- MISSING:  range=>=1
  return (double)(c + i + uc + x + y + z);  // $ overflow=+- overflow=+ overflow=-
}

// Regression test for ODASA-6013.
int test14(int x) {
  int x0 = (int)(char)x;
  range(x0);
  int x1 = (int)(unsigned char)x;
  range(x1);
  int x2 = (int)(unsigned short)x;
  range(x2);
  int x3 = (int)(unsigned int)x;
  range(x3);
  char c0 = x;
  range(c0); 
  unsigned short s0 = x;
  range(s0);
  range(x0 + x1 + x2 + x3 + c0 + s0); // $ overflow=+ overflow=+-
  return x0 + x1 + x2 + x3 + c0 + s0; // $ overflow=+ overflow=+-
}

long long test15(long long x) {
  return (x > 0 && (range(x), x == (int)x)) ? // $ range=>=1 
    (range(x), x) : // $ range=>=1
    (range(x), -1);
}

// Tests for unary operators.
int test_unary(int a) {
  int total = 0;

  if (3 <= a && a <= 11) {
    range(a); // $ range=<=11 range=>=3 
    int b = +a;
    range(b); // $ range=<=11 range=>=3
    int c = -a;
    range(c); // $ range=<=-3 range=>=-11
    range(b+c); // $ range=<=8 range=>=-8
    total += b+c;
    range(total); // $ range=<=8 range=>=-8
  }
  if (0 <= a && a <= 11) {
    range(a); // $ range=<=11 range=>=0
    int b = +a;
    range(b); // $ range=<=11 range=>=0
    int c = -a;
    range(c); // $ range=<=0 range=>=-11
    range(b+c); // $ range=<=11 range=>=-11 MISSING:range=">=- ...+0"
    total += b+c;
    range(total); // $ range="<=Phi: 0+11" range=<=19 range=">=Phi: 0-11" range=>=-19
  }
  if (-7 <= a && a <= 11) {
    range(a); // $ range=<=11 range=>=-7
    int b = +a;
    range(b); // $ range=<=11 range=>=-7
    int c = -a;
    range(c); // $ range=<=7 range=>=-11
    range(b+c); // $ range=<=18 range=>=-18
    total += b+c;
    range(total); // $ range="<=Phi: - ...+18" range=">=Phi: - ...-18" range="<=Phi: 0+29" range=<=37 range=">=Phi: 0-29" range=>=-37
  }
  if (-7 <= a && a <= 1) {
    range(a); // $ range=<=1 range=>=-7
    int b = +a;
    range(b); // $ range=<=1 range=>=-7
    int c = -a;
    range(c); // $ range=<=7 range=>=-1
    range(b+c); // $ range=<=8 range=>=-8
    total += b+c;
    range(total); // $ range="<=Phi: - ...+8" range="<=Phi: - ...+26" range=">=Phi: - ...-8" range=">=Phi: - ...-26" range="<=Phi: 0+37" range=<=45 range=">=Phi: 0-37" range=>=-45
  }
  if (-7 <= a && a <= 0) {
    range(a); // $ range=<=0 range=>=-7
    int b = +a;
    range(b); // $ range=<=0 range=>=-7
    int c = -a;
    range(c); // $ range=<=7 range=>=0
    range(b+c); // $ range=>=-7 range=<=7 MISSING:range="<=- ...+0"
    total += b+c;
    range(total); // $ range="<=Phi: - ...+7" range="<=Phi: - ...+15" range="<=Phi: - ...+33" range=">=Phi: - ...-7" range=">=Phi: - ...-15" range=">=Phi: - ...-33" range="<=Phi: 0+44" range=<=52 Unexpected result: range=">=Phi: 0-44" range=>=-52
  }
  if (-7 <= a && a <= -2) {
    range(a); // $ range=<=-2 range=>=-7
    int b = +a;
    range(b); // $ range=<=-2 range=>=-7
    int c = -a;
    range(c); // $ range=<=7 range=>=2
    range(b+c); // $ range=<=5 range=>=-5
    total += b+c;
    range(total); // $ range="<=Phi: - ...+5" range="<=Phi: - ...+12" range="<=Phi: - ...+20" range="<=Phi: - ...+38" range=">=Phi: - ...-5" range=">=Phi: - ...-12" range=">=Phi: - ...-20" range=">=Phi: - ...-38" range="<=Phi: 0+49" range=<=57 range=">=Phi: 0-49" range=>=-57
  }
  range(total); // $ range="<=Phi: - ...+5" range="<=Phi: - ...+12" range="<=Phi: - ...+20" range="<=Phi: - ...+38" range=">=Phi: - ...-5" range=">=Phi: - ...-12" range=">=Phi: - ...-20" range=">=Phi: - ...-38" range="<=Phi: 0+49" range=<=57 range=">=Phi: 0-49" range=>=-57
  return total;
}


// Tests for multiplication.
int test_mult01(int a, int b) {
  int total = 0;

  if (3 <= a && a <= 11 && 5 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=23 range=>=5
    int r = a*b;  // 15 .. 253
    range(r); // $ range=<=253 range=>=15
    total += r;
    range(total); // $ range=<=253 range=>=15
  }
  if (3 <= a && a <= 11 && 0 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=23 range=>=0
    int r = a*b;  // 0 .. 253
    range(r); // $ range=<=253 range=>=0
    total += r;
    range(total); // $ range="<=Phi: 3+253" range=<=506 range=>=0 range=">=Phi: 3+0"
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=23 range=>=-13
    int r = a*b;  // $ overflow=+- -143 .. 253
    range(r);
    total += r; // $ overflow=+-
    range(total); // $ MISSING: range=">=... * ...+0"
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= 0) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=0 range=>=-13
    int r = a*b;  // -143 .. 0
    range(r); // $ range=<=0 range=>=-143
    total += r;
    range(total); // $ range=">=Phi: 3-143"
  }
  if (3 <= a && a <= 11 && -13 <= b && b <= -7) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=-7 range=>=-13
    int r = a*b;  // -143 .. -21
    range(r); // $ range=<=-21 range=>=-143
    total += r;
    range(total); // $ range=">=Phi: 3-143" range=">=Phi: 3-286"
  }
  range(total); // $ range=">=Phi: 3-143" range=">=Phi: 3-286"
  return total;
}

// Tests for multiplication.
int test_mult02(int a, int b) {
  int total = 0;

  if (0 <= a && a <= 11 && 5 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=0
    range(b); // $ range=<=23 range=>=5
    int r = a*b;  // 0 .. 253
    range(r); // $ range=<=253 range=>=0
    total += r;
    range(total); // $ range=>=0 range=<=253
  }
  if (0 <= a && a <= 11 && 0 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=0
    range(b); // $ range=<=23 range=>=0
    int r = a*b;  // 0 .. 253
    range(r); // $ range=<=253 range=>=0
    total += r;
    range(total); // $ range=>=0 range=">=Phi: 0+0" range="<=Phi: 0+253" range=<=506
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=0
    range(b); // $ range=<=23 range=>=-13
    int r = a*b;  // $ overflow=+- -143 .. 253
    range(r);
    total += r; // $ overflow=+-
    range(total); // $ MISSING: range=">=... * ...+0"
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= 0) {
    range(a); // $ range=<=11 range=>=0
    range(b); // $ range=<=0 range=>=-13
    int r = a*b;  // -143 .. 0
    range(r); // $ range=<=0 range=>=-143
    total += r;
    range(total); // $ range=">=Phi: 0-143"
  }
  if (0 <= a && a <= 11 && -13 <= b && b <= -7) {
    range(a); // $ range=<=11 range=>=0
    range(b); // $ range=<=-7 range=>=-13
    int r = a*b;  // -143 .. 0
    range(r); // $ range=<=0 range=>=-143
    total += r;
    range(total); // $ range=">=Phi: 0-143" range=">=Phi: 0-286"
  }
  range(total); // $range=">=Phi: 0-143" range=">=Phi: 0-286"
  return total;
}

// Tests for multiplication.
int test_mult03(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= 11 && 5 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=-17
    range(b); // $ range=<=23 range=>=5
    int r = a*b;  // $ overflow=+- -391 .. 253
    range(r);
    total += r;
    range(total);
  }
  if (-17 <= a && a <= 11 && 0 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=-17
    range(b); // $ range=<=23 range=>=0
    int r = a*b;  // $ overflow=+- -391 .. 253
    range(r);
    total += r; // $ overflow=+-
    range(total);
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=-17
    range(b); // $ range=<=23 range=>=-13
    int r = a*b;  // $ overflow=+- -391 .. 25
    range(r);
    total += r;  // $ overflow=+-
    range(total);
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= 0) {
    range(a); // $ range=<=11 range=>=-17
    range(b); // $ range=<=0 range=>=-13
    int r = a*b;  // $ overflow=+- -143 .. 221
    range(r);
    total += r; // $ overflow=+-
    range(total);
  }
  if (-17 <= a && a <= 11 && -13 <= b && b <= -7) {
    range(a); // $ range=<=11 range=>=-17
    range(b); // $ range=<=-7 range=>=-13
    int r = a*b;  // $ overflow=+- -143 .. 221
    range(r);
    total += r;  // $ overflow=+-
    range(total);
  }
  range(total);
  return total;
}

// Tests for multiplication.
int test_mult04(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= 0 && 5 <= b && b <= 23) {
    range(a); // $ range=<=0 range=>=-17
    range(b); // $ range=<=23 range=>=5
    int r = a*b;  // -391 .. 0
    total += r;
    range(total); // $ range=<=0 range=>=-391
  }
  if (-17 <= a && a <= 0 && 0 <= b && b <= 23) {
    range(a); // $ range=<=0 range=>=-17
    range(b); // $ range=<=23 range=>=0
    int r = a*b;  // -391 .. 0
    range(r); // $ range=<=0 range=>=-391
    total += r;
    range(total); // $ range="<=Phi: - ...+0" range=<=0 range=">=Phi: - ...-391" range=>=-782
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= 23) {
    range(a); // $ range=<=0 range=>=-17
    range(b); // $ range=<=23 range=>=-13
    int r = a*b;  // $ overflow=+- -391 .. 221
    range(r);
    total += r; // $ overflow=+-
    range(total); // $ MISSING: range="<=... * ...+0"
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= 0) {
    range(a); // $ range=<=0 range=>=-17
    range(b); // $ range=<=0 range=>=-13
    int r = a*b;  // 0 .. 221
    range(r); // $ range=<=221 range=>=0 
    total += r;
    range(total); // $ range="<=Phi: - ...+221"
  }
  if (-17 <= a && a <= 0 && -13 <= b && b <= -7) {
    range(a); // $ range=<=0 range=>=-17
    range(b); // $ range=<=-7 range=>=-13
    int r = a*b;  // 0 .. 221
    range(r); // $ range=<=221 range=>=0
    total += r;
    range(total); // $ range="<=Phi: - ...+221" range="<=Phi: - ...+442"
  }
  range(total); // $ range="<=Phi: - ...+221" range="<=Phi: - ...+442"
  return total;
}

// Tests for multiplication.
int test_mult05(int a, int b) {
  int total = 0;

  if (-17 <= a && a <= -2 && 5 <= b && b <= 23) {
    range(a); // $ range=<=-2 range=>=-17
    range(b); // $ range=<=23 range=>=5
    int r = a*b;  // -391 .. -10
    range(r); // $ range=<=-10 range=>=-391
    total += r;
    range(total); // $ range=<=-10 range=>=-391
  }
  if (-17 <= a && a <= -2 && 0 <= b && b <= 23) {
    range(a); // $ range=<=-2 range=>=-17
    range(b); // $ range=<=23 range=>=0
    int r = a*b;  // -391 .. 0
    range(r); // $ range=<=0 range=>=-391
    total += r;
    range(total); // $ range="<=Phi: - ...+0" range=<=0 range=">=Phi: - ...-391" range=>=-782
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= 23) {
    range(a); // $ range=<=-2 range=>=-17
    range(b); // $ range=<=23 range=>=-13
    int r = a*b;  // $ overflow=+- -391 .. 221
    range(r);
    total += r; // $ overflow=+-
    range(total); // $ MISSING: range="<=... * ...+0"
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= 0) {
    range(a); // $ range=<=-2 range=>=-17
    range(b); // $ range=<=0 range=>=-13
    int r = a*b;  // 0 .. 221
    range(r); // $ range=<=221 range=>=0
    total += r;
    range(total); // $ range="<=Phi: - ...+221"
  }
  if (-17 <= a && a <= -2 && -13 <= b && b <= -7) {
    range(a); // $ range=<=-2 range=>=-17
    range(b); // $ range=<=-7 range=>=-13
    int r = a*b;  // 14 .. 221
    range(r); // $ range=<=221 range=>=14
    total += r;
    range(total); // $ range="<=Phi: - ...+221" range="<=Phi: - ...+442"
  }
  range(total); // $ range="<=Phi: - ...+221" range="<=Phi: - ...+442"
  return total;
}

int test16(int x) {
  int d, i = 0;
  if (x < 0) {
    range(x); // $ range=<=-1
    return -1;
  }

  while (i < 3) {
    range(i); // $ range=<=2 range=>=0
    i++;
    range(i); // $ range=<=3 range=>=1 range="==Phi: i | Store: ... = ...+1"
  }
  range(d);
  d = i;
  range(d); // $ range===3
  if (x < 0) {  // Comparison is always false.
    range(x); // $ range=<=-1 range=>=0
    if (d > -x) {  // Unreachable code.
      range(d); // $ range===3
      range(x); // $ range=<=-1 range=>=0
      return 1;
    }
    range(d); // $ range=<=0 range=>=3 // Unreachable code
    range(x); // $ range=<=-1 range=>=0
  }
  range(x); // $ range=>=0
  return 0;
}

// Test ternary expression upper bounds.
unsigned int test_ternary01(unsigned int x) {
  unsigned int y1, y2, y3, y4, y5, y6, y7, y8;
  y1 = x < 100 ?
    (range(x), x) : // $ range=<=99
    (range(x), 10); // $ range=>=100
  range(y1); // $ range=<=99
  y2 = x >= 100 ?
    (range(x), 10) : // $ range=>=100
    (range(x), x);  // $ range=<=99
  range(y2); // $ range=<=99
  y3 = 0;
  y4 = 0;
  y5 = 0;
  y6 = 0;
  y7 = 0;
  y8 = 0;
  if (x < 300) {
    range(x); // $ range=<=299
    y3 = x ?:
      (range(x), 5);
    range(y3); // $ range=<=299
    y4 = x ?:
      (range(x), 500);
    range(y4); // $ range=<=500
    y5 = (x+1) ?:
      (range(x), 500); // $ overflow=- range===-1
    range(y5); // $ range=<=500
    y6 = ((unsigned char)(x+1)) ?:
      (range(x), 5); // $ range=<=299
    range(y6); // y6 < 256
    y7 = ((unsigned char)(x+1)) ?:
      (range(x), 500); // $ range=<=299
    range(y7); // y7 <= 500
    y8 = ((unsigned short)(x+1)) ?:
      (range(x), 500); // $ range=<=299
    range(y8); // y8 <= 300
  }
  range(y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8); // $ overflow=+ MISSING: range=">=... = ...:... ? ... : ...+0" range=">=call to range+0"
  return y1 + y2 + y3 + y4 + y5 + y6 + y7 + y8; // $ overflow=+
}

// Test ternary expression lower bounds.
unsigned int test_ternary02(unsigned int x) {
  unsigned int y1, y2, y3, y4, y5;
  y1 = x > 100 ?
    (range(x), x) : // $ range=>=101
    (range(x), 110); // $ range=<=100
  range(y1); // $ range=>=101
  y2 = x <= 100 ?
    (range(x), 110) : // $ range=<=100
    (range(x), x); // $ range=>=101
  range(y2); // $ range=>=101
  y3 = 1000;
  y4 = 1000;
  y5 = 1000;
  if (x >= 300) {
    range(x); // $ range=>=300
    y3 = (x-300) ?:
      (range(x), 5); // $ range===300
    range(y3); // $ range=>=0
    y4 = (x-200) ?:
      (range(x), 5); // $ range=<=200 range=>=300
    range(y4); // $ SPURIOUS: range=>=5 MISSING: range=>=100
    y5 = ((unsigned char)(x-200)) ?:
      (range(x), 5); // $ range=>=300
    range(y5); // y6 >= 0
  }
  range(y1 + y2 + y3 + y4 + y5); // $ overflow=+ MISSING: range=">=call to range+207"  range=">=... = ...:... ? ... : ...+0" range=">=call to range+0"
  return y1 + y2 + y3 + y4 + y5; // $ overflow=+
}

// Test the comma expression.
unsigned int test_comma01(unsigned int x) {
  unsigned int y = x < 100 ?
    (range(x), x) : // $ range=<=99
    (range(x), 100); // $ range=>=100
  unsigned int y1;
  unsigned int y2;
  y1 = (++y, y);
  range(y1); // $ range=<=101 range="==Phi: ... ? ... : ... | Store: ... ? ... : ...+1"
  y2 = (y++,
        range(y), // $ range=<=102 range="==Store: ++ ... | Store: ... = ...+1" range="==Phi: ... ? ... : ... | Store: ... ? ... : ...+2"
        y += 3,
        range(y), // $ range=<=105 range="==Store: ++ ... | Store: ... = ...+4" range="==Store: ... +++3" range="==Phi: ... ? ... : ... | Store: ... ? ... : ...+5"
        y);
  range(y2); // $ range=<=105 range="==Store: ++ ... | Store: ... = ...+4" range="==Store: ... +++3" Unexpected result: range="==Phi: ... ? ... : ... | Store: ... ? ... : ...+5"
  range(y1 + y2); // $ range=<=206 range="<=Phi: ... ? ... : ... | Store: ... ? ... : ...+106" MISSING: range=">=++ ...:... = ...+5" range=">=... +++4" range=">=... += ...:... = ...+1" range=">=... ? ... : ...+6"
  return y1 + y2;
}

void test17() {
  int i, j;

  i = 10;
  range(i); // $ range===10

  i = 10;
  i += 10;
  range(i); // $ range===20

  i = 40;
  i -= 10;
  range(i); // $ range===30

  i = j = 40;
  range(i); // $ range===40

  i = (j += 10);
  range(i); // $ range===50

  i = 20 + (j -= 10);
  range(i); // $ range="==Store: ... += ... | Store: ... = ...+10" range===60 range="==Store: ... -= ...+20"
}

// Tests for unsigned multiplication.
int test_unsigned_mult01(unsigned int a, unsigned b) {
  int total = 0;

  if (3 <= a && a <= 11 && 5 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=23 range=>=5
    int r = a*b;  // 15 .. 253
    range(r); // $ range=>=15 range=<=253
    total += r;
    range(total); // $ range=>=15 range=<=253
  }
  if (3 <= a && a <= 11 && 0 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=23 range=>=0
    int r = a*b;  // 0 .. 253
    range(r);// $ range=>=0 range=<=253
    total += r;
    range(total); // $ range=">=Phi: (unsigned int)...+0" range=>=0 range=<=506 range="<=Phi: (unsigned int)...+253"
  }
  if (3 <= a && a <= 11 && 13 <= b && b <= 23) {
    range(a); // $ range=<=11 range=>=3
    range(b); // $ range=<=23 range=>=13
    int r = a*b;  // 39 .. 253
    range(r); // $ range=>=39 range=<=253
    total += r;
    range(total); // $ range=>=39 range=<=759 range="<=Phi: (unsigned int)...+253" range="<=Phi: (unsigned int)...+506" range=">=Phi: (unsigned int)...+39"
  }
  range(total); // $ range=>=0 range=<=759 range=">=Phi: (unsigned int)...+0" range="<=Phi: (unsigned int)...+506" range="<=Phi: (unsigned int)...+253"
  return total;
}

int test_unsigned_mult02(unsigned b) {
  int total = 0;

  if (5 <= b && b <= 23) {
    range(b); // $ range=<=23 range=>=5
    int r = 11*b;  // 55 .. 253
    range(r); // $ range=>=55 range=<=253
    total += r;
    range(total); // $ range=>=55 range=<=253
  }
  if (0 <= b && b <= 23) {
    range(b); // $ range=<=23 range=>=0
    int r = 11*b;  // 0 .. 253
    range(r); // $ range=>=0 range=<=253
    total += r;
    range(total); // $ range=">=Phi: (unsigned int)...+0" range=>=0 range="<=Phi: (unsigned int)...+253" range=<=506
  }
  if (13 <= b && b <= 23) {
    range(b); // $ range=<=23 range=>=13
    int r = 11*b;  // 143 .. 253
    range(r); // $ range=>=143 range=<=253
    total += r;
    range(total); // $ range="<=Phi: (unsigned int)...+253" range="<=Phi: (unsigned int)...+506" range=">=Phi: (unsigned int)...+143" range=>=143 range=<=759
  }
  range(total); // $ range=>=0 range=<=759 range=">=Phi: (unsigned int)...+0" range="<=Phi: (unsigned int)...+506" range="<=Phi: (unsigned int)...+253"
  return total;
}

unsigned long mult_rounding() {
  unsigned long x, y, xy;
  x = y = 1000000003UL; // 1e9 + 3
  range(y); // $ range===1000000003
  range(x); // $ range===1000000003
  xy = x * y;
  range(xy); // $ range===1000000006000000000
  return xy; // BUG: upper bound should be >= 1000000006000000009UL
}

unsigned long mult_overflow() {
  unsigned long x, y, xy;
  x = 274177UL;
  range(x); // $ range===274177
  y = 67280421310721UL;
  range(y);
  xy = x * y; // $ overflow=+-
  range(xy);
  return xy; // BUG: upper bound should be >= 18446744073709551617UL
}

unsigned long mult_lower_bound(unsigned int ui, unsigned long ul) {
  if (ui >= 10) {
    range(ui); // $ range=>=10
    range((unsigned long)ui); // $ range=>=10
    unsigned long result = (unsigned long)ui * ui; // $ overflow=+
    range(result); // $ MISSING: range=>=100
    return result; // BUG: upper bound should be >= 18446744065119617025
  }
  if (ul >= 10) {
    range(ul); // $ range=>=10
    unsigned long result = ul * ul; // $ overflow=+
    range(result); // $ MISSING: range=>=100
    return result; // BUG: lower bound should be 0 (overflow is possible)
  }
  return 0;
}

unsigned long mul_assign(unsigned int ui) {
  if (ui <= 10 && ui >= 2) {
    range(ui); // $ range=<=10 range=>=2
    ui *= ui + 0;
    range(ui); // $ range=<=100 range=>=4
    return ui; // 4 .. 100
  }

  unsigned int uiconst = 10;
  range(uiconst); // $ range===10
  uiconst *= 4;
  range(uiconst); // $ range===40

  unsigned long ulconst = 10;
  range(ulconst); // $ range===10
  ulconst *= 4;
  range(ulconst); // $ range===40
  range(uiconst + ulconst); // $ range===80
  return uiconst + ulconst; // 40 .. 40 for both
}

int mul_by_constant(int i, int j) {
  if (i >= -1 && i <= 2) {
    range(i); // $ range=<=2 range=>=-1
    i = 5 * i;
    range(i); // $ range=<=10 range=>=-5

    i = i * -3; // $ overflow=+-
    range(i); // -30 .. 15

    i *= 7; // $ overflow=+-
    range(i); // -210 .. 105

    i *= -11; // $ overflow=+-
    range(i); // -1155 .. 2310
  }
  if (i == -1) {
    range(i); // $ range===-1
    range((int)0xffFFffFF); // $ range===-1
    i = i * (int)0xffFFffFF; // fully converted literal is -1
    range(i); // $ range===1
  }
  i = i * -1; // $ overflow=+-
  range(   i); // -2^31 .. 2^31-1

  signed char sc = 1;
  range(sc); // $ range===1
  i = (*&sc *= 2);
  range(sc); // $ range===2
  range(i); // $ range===2

  return 0;
}


int notequal_type_endpoint(unsigned n) {
  range(n); // 0 ..

  if (n > 0) {
    range(n); // $ range=>=1
  }

  if (n != 0) {
    range(n); // 1 ..
  } else {
    range(n); // 0 .. 0
  }

  if (!n) {
    range(n); // 0 .. 0
  } else {
    range(n); // 1 ..
  }

  while (n != 0) {
    n--; // 1 ..
  }

  range(n); // $ range="<=InitializeParameter: n+0" // 0 .. 0
}

void notequal_refinement(short n) {
  if (n < 0) {
    range(n); // $ range=<=-1
    return;
  }

  if (n == 0) {
    range(n); // 0 .. 0
  } else {
    range(n); // $ range=>=1
  }

  if (n) {
    range(n); // $ range=>=1
  } else {
    range(n); // 0 .. 0
  }

  while (n != 0) {
    range(n); // $ MISSING:range=<=n+0
    n--; // 1 ..
  }

  range(n); // $ MISSING:range=<=n+0 // 0 .. 0
}

void notequal_variations(short n, float f) {
  if (n != 0) {
    if (n >= 0) {
      range(n); // $ range=>=1
    }
  }

  if (n >= 5) {
    if (2 * n - 10 == 0) { // $ overflow=+
      range(n); // $ range=>=5 MISSING: range===5
      return;
    }
    range(n); // $ range=>=5 MISSING: range=>=6
  }

  if (n != -32768 && n != -32767) {
    range(n); // -32766 ..
  }

  if (n >= 0) {
    n  ?
      (range(n), n) // $ range=>=1
    : (range(n), n); // $ MISSING: range===0
    !n ?
      (range(n), n) // $ MISSING: range===0
    : (range(n), n); // $ range=>=1
  }
}

void two_bounds_from_one_test(short ss, unsigned short us) {
  // These tests demonstrate how the range analysis is often able to deduce
  // both an upper bound and a lower bound even when there is only one
  // inequality in the source. For example `signedInt < 4U` establishes that
  // `signedInt >= 0` since if `signedInt` were negative then it would be
  // greater than 4 in the unsigned comparison.

  if (ss < sizeof(int)) { // Lower bound added in `linearBoundFromGuard`
    range(ss); // 0 .. 3
  }

  if (ss < 0x8001) { // Lower bound removed in `getDefLowerBounds`
    range(ss); // $ overflow=+ range=<=32768 MISSING: range=>=-32768
  }

  if ((short)us >= 0) {
    range(us); // 0 .. 32767
  }

  if ((short)us >= -1) {
    range(us); // 0 .. 65535
  }

  if (ss >= sizeof(int)) { // test is true for negative numbers
    range(ss); // -32768 .. 32767
  }

  if (ss + 1 < sizeof(int)) {  // $ overflow=+
    range(ss); // -1 .. 2
  }
}

void widen_recursive_expr() {
  int s;
  for (s = 0; s < 10; s++) {
    range(s); // $ range=<=9 range=>=0
    int result = s + s;
    range(result); // $ range=<=18 Unexpected result: range="<=Phi: s+9" range=>=0 Unexpected result: range=">=Phi: s+0"
  }
}

void guard_bound_out_of_range(void) {
  int i = 0;
  if (i < 0) {
    range(i); // unreachable [BUG: is -max .. +max]
  }

  unsigned int u = 0;
  if (u < 0) {
    range(u); // unreachable [BUG: is 0 .. +max]
  }
}

void test_mod(int s) {
  int s2 = s % 5;
  range(s2); // $ range=>=-4 range=<=4
}

void test_mod_neg(int s) {
  int s2 = s % -5;
  range(s2); // $ range=>=-4 range=<=4
}

void test_mod_ternary(int s, bool b) {
  int s2 = s % (b ? 5 : 500);
  range(s2); // $ range=>=-499 range=<=499
}

void test_mod_ternary2(int s, bool b1, bool b2) {
  int s2 = s % (b1 ? (b2 ? 5 : -5000) : -500000);
  range(s2); // $ range=>=-499999 range=<=499999
}

void exit(int);
void guard_with_exit(int x, int y) {
  if (x) {
    if (y != 0) {
      exit(0);
    }
  }
  range(y); // ..

  // This test ensures that we correctly identify
  // that the upper bound for y is max_int when calling `range(y)`.
}

void test(int x) {
  if (x >= 10) {
    range(x); // $ range=>=10
    return;
  }
  // The basic below has two predecessors.
label:
  range(x); // $ range=<=9
  goto label;
}

void test_overflow() {
  const int x = 2147483647; // 2^31-1
  range(x); // $ range===2147483647
  const int y = 256;
  range(y); // $ range===256
  if ((x + y) <= 512) {
    range(x); // $ range===2147483647
    range(y); // $ range===256
    range(x + y); // $ range===-2147483393
  }
}

void test_negate_unsigned(unsigned u) {
  if(10 < u && u < 20) {
    range<unsigned>(-u); // $ overflow=-
  }
}

void test_negate_signed(int s) {
  if(10 < s && s < 20) {
    range<int>(-s); // $ range=<=-11 range=>=-19
  }
}

// By setting the guard after the use in another guard we 
// don't get the useful information
void test_guard_after_use(int pos, int size, int offset) {
  if (pos + offset >= size) { // $ overflow=+-
    return;
  }
  if (offset != 1) {
    return;
  }
  range(pos + 1); // $ overflow=+ range="==InitializeParameter: pos+1" MISSING: range="<=InitializeParameter: size-1"
} 

int cond();


// This is basically what we get when we have a loop that calls 
// realloc in some iterations
void alloc_in_loop(int origLen) {
  if (origLen <= 10) {
    return;
  }
  int len = origLen;
  int index = 0;
  while (cond()) {
    if (index == len) {
      if (len >= 1000) {
        return;
      }
      len = len * 2; // $ overflow=-
    }
    // We want that index < len
    range(index); // $ MISSING: range="<=InitializeParameter: len-1"
    index++;
  }
}

// This came from a case where it handled the leftovers before an unrolled loop 
void mask_at_start(int len) {
  if (len < 0) {
    return;
  }
  int leftOver = len & 63; 
  for (int i = 0; i < leftOver; i++) {
    range(i); // $ range=<=62 range=>=0  range="<=Store: ... & ... | Store: leftOver-1" range="<=InitializeParameter: len-1"
  }
  // Do something with leftOver
  for (int index = leftOver; index < len; index+=64) {
    range(index);  // $ range="<=InitializeParameter: len-64" range=">=Store: ... & ... | Store: leftOver+0"
    range(index + 63); // $ range="<=InitializeParameter: len-1" range="==Phi: index+63" range=">=Store: ... & ... | Store: leftOver+63"
  }
}


// Same as above but with modulo
void mod_at_start(int len) {
  if (len < 0) {
    return;
  }
  int leftOver = len % 64;
  for (int i = 0; i < leftOver; i++) {
    range(i); // $ range=<=62 range=>=0  range="<=Store: ... % ... | Store: leftOver-1"  range="<=InitializeParameter: len-1"
  }
  // Do something with leftOver
  for (int index = leftOver; index < len; index+=64) {
    range(index);  // $ range="<=InitializeParameter: len-64" range=">=Store: ... % ... | Store: leftOver+0"
    range(index + 63); // $ range="<=InitializeParameter: len-1" range="==Phi: index+63" range=">=Store: ... % ... | Store: leftOver+63"
  }
}
