// Semmle test case for rule ArithmeticUncontrolled.ql (Uncontrolled data in arithmetic expression).
// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

int rand(void);
void trySlice(int start, int end);
void add_100(int);

#define RAND() rand()
#define RANDN(n) (rand() % n)
#define RAND2() (rand() ^ rand())
#define RAND_MAX 32767



void randomTester() {
  int i;
  for (i = 0; i < 1000; i++) {
    int r = rand();
    
    // BAD: The return from rand() is unbounded 
    trySlice(r, r+100);
  }

  for (i = 0; i < 1000; i++) {
    int r = rand();

    // GOOD: put a bound on r
    if (r < 100000) {
      trySlice(r, r+100);
    }
  }

  {
    int r = RAND();
    r += 100; // BAD: The return from RAND() is unbounded
  }

  {
    int r = RANDN(100);
    r += 100; // GOOD: The return from RANDN is bounded
  }

  {
    int r = rand();
    r += 100; // BAD
  }
  
  {
    int r = rand() / 10;
    r += 100; // GOOD
  }
  
  {
    int r = rand();
    r = r / 10;
    r += 100; // GOOD
  }
  
  {
    int r = rand();
    r /= 10;
    r += 100; // GOOD
  }
  
  {
    int r = rand() & 0xFF;
    r += 100; // GOOD
  }

  {
    int r = rand() + 100; // BAD [NOT DETECTED]
  }

  {
    int r = RAND2();

    r = r + 100; // BAD
  }

  {
    int r = (rand() ^ rand());

    r = r + 100; // BAD
  }

  {
    int r = RAND2() + 100; // BAD [NOT DETECTED]
  }

  {
    int r = RAND();
    int *ptr_r = &r;
    *ptr_r += 100; // BAD [NOT DETECTED]
  }

  {
    int r = 0;
    int *ptr_r = &r;
    *ptr_r = RAND();
    r += 100; // BAD [NOT DETECTED]
  }

  {
    int r = rand();
    r = ((2.0 / (RAND_MAX + 1)) * r - 1.0);
    add_100(r);
  }
}

void add_100(int r) {
  r += 100; // GOOD
}

void randomTester2(int bound, int min, int max) {
  int r1 = rand() % bound;
  r1 += 100; // GOOD (`bound` may possibly be MAX_INT in which case this could
             //       still overflow, but it's most likely fine)

  int r2 = (rand() % (max - min + 1)) + min;
  r2 += 100; // GOOD (This is a common way to clamp the random value between [min, max])
}

void moreTests() {
  {
    int r = rand();
    
    r = r * 100; // BAD
  }

  {
    int r = rand();
    
    r *= 100; // BAD
  }

  {
    int r = rand();
    int v = 100;
    v *= r; // BAD
  }

  {
    int r = rand();
    
    r <<= 8; // BAD [NOT DETECTED]
  }

  {
    int r = rand();
    
    r = r - 100; // GOOD
  }

  {
    unsigned int r = rand();
    
    r = r - 100; // BAD
  }
}

void guarded_test(unsigned p) {
  unsigned data = (unsigned int)rand();
  if (p >= data) {
    return;
  }
  unsigned z = data - p; // GOOD
}