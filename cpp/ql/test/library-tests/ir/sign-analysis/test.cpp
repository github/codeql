template<typename T> T sign(T value);

int f1(int x, int y) {
  if (x < 0) {
    return sign(x); // $ sign=-
  }
  if (x < y) {
    return sign(y); // $ sign=+
  }
  
  return 0;
}

void u(int x) {
  unsigned c = (unsigned)x;
  sign(c); // $ sign=+0
}

void constants() {
  int i_pos = 1234;
  sign(i_pos); // $ sign=+
  int i_neg = -1234;
  sign(i_neg); // $ sign=-
  int i_zero = 0;
  sign(i_zero);  // $ sign=0
  long l_pos = 1234;
  sign(l_pos);  // $ sign=+
  long l_neg = -1234;
  sign(l_neg);  // $ sign=-
  long l_zero = 0;
  sign(l_zero);  // $ sign=0
  long l_pos_big = 0x00000001baadf00d;
  sign(l_pos_big);  // $ sign=+
  float f_pos = 1.234f;
  sign(f_pos);  // $ sign=+
  float f_neg = -1.234f;
  sign(f_neg);  // $ sign=-
  float f_zero = 0.0f;
  sign(f_zero);  // $ sign=0
}

void arithmetic(int y) {
  int x = 0;
  sign(x + 1);  // $ sign=+
  x = -1;
  sign(x);  // $ sign=-
  sign(x + 1);  // $ sign=+-0 // Ideally 0 because it's constant
  if (y < 0) {
    sign(y);  // $ sign=-
    sign(y + 1);  // $ sign=+-0 // Ideally -0 because it's only adding one.
    int z = y;
    sign(++z);  // $ sign=+-0  // Ideally -0 because it's only adding one.
    z = y;
    sign(z++);  // $ sign=-
    sign(z);  // $ sign=+-0  // Ideally -0 because it's only adding one.
  }
}
