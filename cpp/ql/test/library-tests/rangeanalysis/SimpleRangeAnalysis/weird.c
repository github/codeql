static void out(int i);

void weird1() {
  int i;
  for (i = 0; i <= 11; ++i) {
    if (0 <= i && i <= 9) {
      out(i);
      int j;
      j = i - 0;
      out(j);
    }
  } 
}

void weird2(int i) {
  if (i <= 11) {
    if (0 <= i && i <= 9) {
      out(i);
      int j;
      j = i - 0;
      out(j);
    }
  } 
}