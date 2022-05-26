int scanf(const char *format, ...);
int sscanf(const char *str, const char *format, ...);
int globalVal;
char * globalVala;
int * globalValp;
char globalVala2;
int functionWork1(int retIndex) {
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
  if(retIndex == 0)
    return (int)*a;
  if(retIndex == 1)
    return *p;
  return i;
}

int functionWork1_(int retIndex) {
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
  if(retIndex == 0)
    return (int)*a;
  if(retIndex == 1)
    return *p;
  return i;
}

int functionWork1b(int retIndex) {
  int i;
  char a[10];
  int b;
  int *p = &b;
  scanf("%i", &i); // BAD
  scanf("%s", a); // BAD
  scanf("%i", p); // BAD
  if(retIndex == 0)
    return (int)*a;
  if(retIndex == 1)
    return *p;
  return i;
}
int functionWork1_() {
  int i;
  scanf("%i",&i); // BAD [NOT DETECTED]
  if(i<10)
    return -1;
  return i;
}
int functionWork2(int retIndex) {
  int i = 0;
  char a[10] = "";
  int b = 1;
  int *p = &b;
  scanf("%i", &i); // GOOD:Argument initialized even when scanf fails.
  scanf("%s", a); // GOOD:Argument initialized even when scanf fails.
  scanf("%i", p); // GOOD:Argument initialized even when scanf fails.
  if(retIndex == 0)
    return (int)*a;
  if(retIndex == 1)
    return *p;
  return i;
}

int functionWork2_(int retIndex) {
  int i;
  i = 0;
  char a[10];
  a[0] = '\0';
  int b;
  b=1;
  int *p = &b;
  scanf("%i", &i); // GOOD:Argument initialized even when scanf fails.
  scanf("%s", a); // GOOD:Argument initialized even when scanf fails.
  scanf("%i", p); // GOOD:Argument initialized even when scanf fails.
  if(retIndex == 0)
    return (int)*a;
  if(retIndex == 1)
    return *p;
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
int functionWork3b(int * i) {
  scanf("%i", i); // BAD
  return 0;
}
int functionWork3() {
  char number[] = "42";
  int d;
  sscanf(number, "%d", &d); // GOOD: sscanf always succeeds
  if (d < 16)
    return -1;
}
