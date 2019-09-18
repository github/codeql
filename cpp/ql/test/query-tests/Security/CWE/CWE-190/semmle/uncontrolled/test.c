// Semmle test case for rule ArithmeticUncontrolled.ql (Uncontrolled data in arithmetic expression).
// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

int rand(void);
void trySlice(int start, int end);

#define RAND() rand()
#define RANDN(n) (rand() % n)
#define RAND2() (rand() ^ rand())





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
    r += 100; // GOOD: The return from RANDN is bounded [FALSE POSITIVE]
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
    r += 100; // GOOD [FALSE POSITIVE]
  }
  
  {
    int r = rand();
    r /= 10;
    r += 100; // GOOD
  }
  
  {
    int r = rand() & 0xFF;
    r += 100; // GOOD [FALSE POSITIVE]
  }

  {
    int r = rand() + 100; // BAD [NOT DETECTED]
  }

  {
    int r = RAND2();

    r = r - 100; // BAD
  }

  {
    int r = (rand() ^ rand());

    r = r - 100; // BAD [NOT DETECTED]
  }

  {
    int r = RAND2() - 100; // BAD [NOT DETECTED]
  }

  {
    int r = RAND();
    int *ptr_r = &r;
    *ptr_r -= 100; // BAD [NOT DETECTED]
  }

  {
    int r = 0;
    int *ptr_r = &r;
    *ptr_r = RAND();
    r -= 100; // BAD
  }
}
