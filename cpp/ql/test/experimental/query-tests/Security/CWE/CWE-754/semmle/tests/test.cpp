int scanf(const char *format, ...);
int globalVal;
int functionWork1() {
  int i;
  if (scanf("%i", &i) == 1) // GOOD
    return i;
  else
    return -1;
}

int functionWork1_() {
  int i;
  int r;
  r = scanf("%i", &i);
  if (r == 1) // GOOD
    return i;
  else
    return -1;
}

int functionWork1b() {
  int i;
  scanf("%i", &i); // BAD
  return i;
}

int functionWork2() {
  int i = 0;
  scanf("%i", &i); // GOOD:the error can be determined by examining the initial value.
  return i;
}

int functionWork2_() {
  int i;
  i = 0;
  scanf("%i", &i); // GOOD:the error can be determined by examining the initial value.
  return i;
}
int functionWork2b() {
  int i;
  scanf("%i", &i); // BAD
  globalVal = i;
  return 0;
}

void functionRunner() {
  functionWork1();
  functionWork1_();
  functionWork1b();
  functionWork2();
  functionWork2_();
  functionWork2b();
}
