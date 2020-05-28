// Semmle test case for rule ArithmeticWithExtremeValues.ql (Use of extreme values in arithmetic expression).
// Associated with CWE-190: Integer Overflow or Wraparound. http://cwe.mitre.org/data/definitions/190.html

#define INT_MAX 2147483647

int len_last(int n, char** lines) {
  int min;
  min = INT_MAX;
  int i;

  for (i = 0; i < n; i++) {
    int len = strlen(lines[i]);
    min = len;
  }

  // BAD: if the input array is empty, then max will still be INT_MAX
  return min + 1;
}


int len_last_good(int n, char** lines) {
  int min;
  min = INT_MAX;
  int i;

  for (i = 0; i < n; i++) {
    int len = strlen(lines[i]);
    min = len;
  }

  // GOOD: check for INT_MAX
  if (min < INT_MAX) {
    return min + 1;
  } else {
    return 0;
  }
}

#define CHAR_MIN -128
#define CHAR_MAX 127

void test_crement() {
  signed char sc1, sc2, sc3, sc4, sc5, sc6, sc7, sc8, sc9, sc10;

  sc1 = CHAR_MIN;
  sc1++; // GOOD
  sc2 = CHAR_MIN;
  sc2--; // BAD
  sc3 = CHAR_MAX;
  sc3++; // BAD
  sc4 = CHAR_MAX;
  sc4--; // GOOD

  sc5 = CHAR_MAX;
  sc5 = 0;
  sc5++; // GOOD [FALSE POSITIVE]

  sc6 = CHAR_MAX;
  sc6 += 1; // BAD
  sc7 = CHAR_MAX;
  sc7 -= 1; // GOOD
  sc8 = CHAR_MIN;
  sc8 -= 1; // BAD
  sc9 = CHAR_MIN;
  sc9 += 1; // GOOD

  sc10 = 1;
  sc10 += CHAR_MAX; // BAD [NOT DETECTED]
}

void test_negatives() {
  signed char sc1, sc2, sc3, sc4, sc5, sc6, sc7, sc8;

  sc1 = CHAR_MAX;
  sc1 += 0; // GOOD [FALSE POSITIVE]
  sc1 += -1; // GOOD [FALSE POSITIVE]
  sc2 = CHAR_MIN;
  sc2 += -1; // BAD [NOT DETECTED]
  sc3 = CHAR_MIN;
  sc3 = sc3 + -1; // BAD [NOT DETECTED]
  sc4 = CHAR_MAX;
  sc4 -= -1; // BAD [NOT DETECTED]
  sc5 = -1;
  sc5 += CHAR_MIN; // BAD [NOT DETECTED]
}

void test_guards1(int cond) {
	int x = cond ? INT_MAX : 0;

	// ...

	if (x > 128) return;

	return x + 1; // GOOD
}

void test_guards2(int cond) {
	int x = cond ? INT_MAX : 0;

	// ...

	if (x < 128) return;

	return x + 1; // BAD [NOT DETECTED]
}

void test_guards3(int cond) {
	int x = cond ? INT_MAX : 0;

	// ...

	if (x != 0) return;

	return x + 1; // GOOD
}

void test_guards4(int cond) {
	int x = cond ? INT_MAX : 0;

	// ...

	if (x == 0) return;

	return x + 1; // BAD
}
