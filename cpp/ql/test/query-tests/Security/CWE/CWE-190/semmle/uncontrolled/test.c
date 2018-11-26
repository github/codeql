// Semmle test case for rule ArithmeticUncontrolled.ql (Uncontrolled data in arithmetic expression).
// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

int rand();
void trySlice(int start, int end);

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
}

