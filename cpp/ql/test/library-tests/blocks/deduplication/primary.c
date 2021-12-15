static int common() {
  return ^{return 0;}();
}

#ifndef FN
#define FN primary
#endif

int FN() {
  return common();
}
