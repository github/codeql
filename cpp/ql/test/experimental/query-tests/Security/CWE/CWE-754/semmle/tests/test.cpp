int scanf(const char *format, ...);
int globalVal;
char * globalVala;
int * globalValp;
char globalVala2;
int functionWork1() {
  int i;
  char a[10];
  int b;
  int *p = &b;
  if (scanf("%i", &i) != 1) // GOOD
    return -1;
  if (scanf("%s", a) != 1) // GOOD
    return -1;
  if (scanf("%i", p) != 1) // GOOD
    return -1;
  return i;
}

int functionWork1_() {
  int i;
  char a[10];
  int b;
  int *p = &b;
  int r;
  r = scanf("%i", &i);
  if (r != 1) // GOOD
    return -1;
  r = scanf("%s", a);
  if (r == 1) // GOOD
    return -1;
  r = scanf("%i", p);
  if (r != 1) // GOOD
    return -1;
  return i;
}

int functionWork1b() {
  int i;
  char a[10];
  int b;
  int *p = &b;
  scanf("%i", &i); // BAD
  scanf("%s", a); // BAD
  scanf("%i", p); // BAD
  return i;
}

int functionWork2() {
  int i = 0;
  char a[10] = "";
  int b = 1;
  int *p = &b;
  scanf("%i", &i); // GOOD:the error can be determined by examining the initial value.
  scanf("%s", a); // GOOD:the error can be determined by examining the initial value.
  scanf("%i", p); // GOOD:the error can be determined by examining the initial value.
  return i;
}

int functionWork2_() {
  int i;
  i = 0;
  char a[10];
  a[0] = '\0';
  int b;
  b=1;
  int *p = &b;
  scanf("%i", &i); // GOOD:the error can be determined by examining the initial value.
  scanf("%s", a); // GOOD:the error can be determined by examining the initial value.
  scanf("%i", p); // GOOD:the error can be determined by examining the initial value.
  return i;
}
int functionWork2b() {
  int i;
  char a[10];
  int b;
  int *p = &b;
  scanf("%i", &i); // BAD
  scanf("%s", a); // BAD
  scanf("%i", p); // BAD
  globalVal = i;
  globalVala = a;
  globalValp = p;
  return 0;
}
int functionWork2b_() {
  char a[10];
  scanf("%s", a); // BAD
  globalVala2 = a[0];
  return 0;
}

void functionRunner() {
  functionWork1();
  functionWork1_();
  functionWork1b();
  functionWork2();
  functionWork2_();
  functionWork2b();
  functionWork2b_();
}
