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

void Escape(void* p);

void ScalarPhi(bool b) {
  int x = 0;
  int y = 1;
  int z = 2;
  if (b) {
    x = 3;
    y = 4;
  }
  else {
    x = 5;
  }
  int x_merge = x;
  int y_merge = y;
  int z_merge = z;
}

void MustExactlyOverlap(Point a) {
  Point b = a;
}

void MustExactlyOverlapEscaped(Point a) {
  Point b = a;
  Escape(&a);
}

void MustTotallyOverlap(Point a) {
  int x = a.x;
  int y = a.y;
}

void MustTotallyOverlapEscaped(Point a) {
  int x = a.x;
  int y = a.y;
  Escape(&a);
}

void MayPartiallyOverlap(int x, int y) {
  Point a = { x, y };
  Point b = a;
}

void MayPartiallyOverlapEscaped(int x, int y) {
  Point a = { x, y };
  Point b = a;
  Escape(&a);
}

void MergeMustExactlyOverlap(bool c, int x1, int x2) {
  Point a = {};
  if (c) {
    a.x = x1;
  }
  else {
    a.x = x2;
  }
  int x = a.x;
  Point b = a;
}
