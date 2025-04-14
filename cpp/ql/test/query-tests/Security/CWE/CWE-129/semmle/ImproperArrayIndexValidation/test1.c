int atoi(const char *nptr);

void dosomething(char c);

const char chr[26] = "abcdefghijklmnopqrstuvwxyz";

int main(int argc, char *argv[]) {
  int i = atoi(argv[1]);
  test1(i);
  test2(i);
  test3(i);
  test4(i);
  test5(i);
  test6(i);
  test7(argv[1]);
}

void test1(int i) {
  // BAD: i has not been validated.
  char c = chr[i];
  dosomething(c);
}

void test2(int i) {
  if (0 <= i && i < 26) {
    // GOOD: i has been validated.
    char c = chr[i];
    dosomething(c);
  }
}

int myArray[10];

void test3(int i) {
  myArray[i] = 0; // BAD: i has not been validated

  i = 5;

  myArray[i] = 0; // GOOD: i is not untrusted input [FALSE POSITIVE]
}

void test4(int i) {
  myArray[i] = 0; // BAD: i has not been validated

  if ((i < 0) || (i >= 10)) return;

  myArray[i] = 1; // GOOD: i has been validated
}

void test5(int i) {
  int j = 0;

  j = i;

  j = myArray[j]; // BAD: j has not been validated
}

extern int myTable[256];

void test6(int i) {
  unsigned char s = i;

  myTable[s] = 0; // GOOD: Input is small [FALSE POSITIVE]
}

typedef void FILE;
#define EOF (-1)

int getc(FILE*);

extern int myMaxCharTable[256];

void test7(FILE* fp) {
  int ch;
  while ((ch = getc(fp)) != EOF) {
    myMaxCharTable[ch] = 0; // GOOD
  }
}

