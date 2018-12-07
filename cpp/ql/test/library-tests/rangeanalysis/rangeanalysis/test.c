
// Guards, inference, critical edges
int test1(int x, int y) {
  if (x < y) {
    x = y;
  }
  return x;
}

// Bounds mergers at phi nodes
int test2(int x, int y) {
  if (x < y) {
    x = y;
  } else {
    x = x-2;
  }
  return x;
}

// for loops
int test3(int x, void *p) {
  int i;
  for(i = 0; i < x; i++) {
    p[i];
  }
  for(i = x; i > 0; i++) {
    p[i];
  }
}

// pointer bounds
int test4(int *begin, int *end) {
  while (begin < end) {
    *begin = (*begin) + 1;
    begin++;
  }
}

