// semmle-extractor-options: -std=c++17

struct Point {
  int x;
  int y;
};

struct Rect {
  Point topLeft;
  Point bottomRight;
};

int ChiPhiNode(Point* p, bool which1, bool which2) {
  if (which1) {
    p->x++;
  }
  else {
    p->y++;
  }

  if (which2) {
    p->x++;
  }
  else {
    p->y++;
  }

  return p->x + p->y;
}

int UnreachableViaGoto() {
  goto skip;
  return 1;
skip:
  return 0;
}

int UnreachableIf(bool b) {
  int x = 5;
  int y = 10;
  if (b) {
    if (x == y) {
      return 1;
    }
    else {
      return 0;
    }
  }
  else {
    if (x < y) {
      return 0;
    }
    else {
      return 1;
    }
  }
}

int DoWhileFalse() {
  int i = 0;
  do {
    i++;
  } while (false);

  return i;
}

void chiNodeAtEndOfLoop(int n, char* p) {
  while (n-- > 0)
    * p++ = 0;
}
