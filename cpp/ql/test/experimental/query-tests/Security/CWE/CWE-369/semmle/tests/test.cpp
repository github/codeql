typedef struct {}
FILE;
int getc(FILE * stream);

int getSize(int type) {
  int st;
  switch (type) {
  case 1:
    st = 1;
    break;
  case 2:
    st = 2;
    break;
  case 3:
    st = 3;
    break;
  case 4:
    st = -1;
    break;
  default:
    st = 0;
    break;
  }
  return st;
}
int getSize2(int type) {
  int st = 0;
  switch (type) {
  case 1:
    st = 1;
    break;
  case 2:
    st = 2;
    break;
  case 3:
    st = 3;
    break;
  case 4:
    st = -1;
    break;
  }
  return st;
}

int badTestf1(int type, int met) {
  int is = getSize(type);
  if (met == 1) return 123 / is; // BAD
  else return 123 / getSize2(type); // BAD
}
int badTestf2(int type) {
  int is;
  is = getSize(type);
  return 123 / is; // BAD
}

int badTestf3(int type, int met) {
  int is;
  is = getSize(type);
  switch (met) {
  case 1:
    if (is >= 0) return 123 / is; // BAD [NOT DETECTED]
  case 2:
    if (0 == is) return 123 / is; // BAD [NOT DETECTED]
  case 3:
    if (!is & 123 / is) // BAD
      return 123;
  case 4:
    if (!is | 123 / is) // BAD
      return 123;
  case 5:
    if (123 / is || !is) // BAD 
      return 123;
  case 6:
    if (123 / is && !is) // BAD
      return 123;
  case 7:
    if (!is) return 123 / is; // BAD
  case 8:
    if (is > -1) return 123 / is; // BAD
  case 9:
    if (is < 2) return 123 / is; // BAD
  }
  if (is != 0) return -1;
  if (is == 0) type += 1;
  return 123 / is; // BAD [NOT DETECTED]
}

int goodTestf3(int type, int met) {
  int is = getSize(type);
  if (is == 0) return -1;
  switch (met) {
  case 1:
    if (is < 0) return 123 / is; // GOOD
  case 2:
    if (!is && 123 / is) // GOOD 
      return 123;
  case 3:
    if (!is || 123 / is) // GOOD
      return 123;
  case 8:
    if (is < -1) return 123 / is; // GOOD
  case 9:
    if (is > 2) return 123 / is; // GOOD
  }
  return 123 / is;
}

int goodTestf3a(int type, int met) {
  int is = getSize(type);
  switch (met) {
  case 1:
    if (is < 0)
      return 123 / is; // GOOD
  case 2:
    if (!is && 123 / is) // GOOD 
      return 123;
  case 3:
    if (!is || 123 / is) // GOOD 
      return 123;
  }
  return 1;
}

int badTestf4(int type) {
  int is = getSize(type);
  int d;
  d = type * is;
  return 123 / d; // BAD
}

int badTestf5(int type) {
  int is = getSize(type);
  int d;
  d = is / type;
  return 123 / d; // BAD
}
int badTestf6(int type) {
  int is = getSize(type);
  int d;
  d = is / type;
  return type * 123 / d; // BAD
}

int badTestf7(int type, int met) {
  int is = getSize(type);
  if (is == 0) goto quit;
  switch (met) {
  case 1:
    if (is < 0)
      return 123 / is; // GOOD
  }
  quit:
    return 123 / is; // BAD
}

int goodTestf7(int type, int met) {
  int is = getSize(type);
  if (is == 0) goto quit2;
  if (is == 0.) return -1;
  switch (met) {
  case 1:
    if (is < 0.)
      return 123 / is; // GOOD
  }
  return 123 / is; // GOOD
  quit2:
    return -1;
}

int badTestf8(int type) {
  int is = getSize(type);
  type /= is; // BAD
  type %= is; // BAD
  return type;
}

float getSizeFloat(float type) {
  float st;
  if (type)
    st = 1.0;
  else
    st = 0.0;
  return st;
}
float badTestf9(float type) {
  float is = getSizeFloat(type);
  return 123 / is; // BAD
}
float goodTestf9(float type) {
  float is = getSizeFloat(type);
  if (is == 0.0) return -1;
  return 123 / is; // GOOD
}

int badTestf10(int type) {
  int out = type;
  int is = getSize(type);
  if (is > -2) {
    out /= 123 / (is + 1); // BAD
  }
  if (is > 0) {
    return 123 / (is - 1); // BAD
  }
  if (is <= 0) return 0;
  return 123 / (is - 1); // BAD
  return 0;
}
int badTestf11(int type) {
  int is = getSize(type);
  return 123 / (is - 3); // BAD
}

int goodTestf11(int type) {
  int is = getSize(type);
  if (is > 1) {
    return 123 / (is - 1); // GOOD
  } else {
    return 0;
  }
}

int badTestf12(FILE * f) {
  int a;
  int ret = -1;
  a = getc(f);
  if (a == 0) ret = 123 / a; // BAD [NOT DETECTED]
  return ret;
}

int goodTestf12(FILE * f) {
  int a;
  int ret = -1;
  a = getc(f);
  if (a != 0) ret = 123 / a; // GOOD
  return ret;
}

int badMyDiv(int type, int is) {
  type /= is;
  type %= is;
  return type;
}

int goodMyDiv(int type, int is) {
  if (is == 0) return -1;
  type /= is;
  type %= is;
  return type;
}
int badMySubDiv(int type, int is) {
  type /= (is - 3);
  type %= (is + 1);
  return type;
}

void badTestf13(int type) {
  int is = getSize(type);
  badMyDiv(type, is); // BAD
  badMyDiv(type, is - 2); // BAD
  badMySubDiv(type, is); // BAD
  goodMyDiv(type, is); // GOOD
  if (is < 5)
    badMySubDiv(type, is); // BAD
  if (is < 0)
    badMySubDiv(type, is); // BAD [NOT DETECTED]
  if (is > 5)
    badMySubDiv(type, is); // GOOD
  if (is == 0)
    badMyDiv(type, is); // BAD
  if (is > 0)
    badMyDiv(type, is); // GOOD
  if (is < 5)
    badMyDiv(type, is - 3); // BAD
  if (is < 0)
    badMyDiv(type, is + 1); // BAD
  if (is > 5)
    badMyDiv(type, is - 3); // GOOD
}
