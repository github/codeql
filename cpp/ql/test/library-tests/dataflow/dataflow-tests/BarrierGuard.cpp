int source();
void sink(int);
bool guarded(int);

void bg_basic(int source) {
  if (guarded(source)) {
    sink(source); // no flow
  } else {
    sink(source); // flow
  }
}

void bg_not(int source) {
  if (!guarded(source)) {
    sink(source); // flow
  } else {
    sink(source); // no flow
  }
}

void bg_and(int source, bool arbitrary) {
  if (guarded(source) && arbitrary) {
    sink(source); // no flow
  } else {
    sink(source); // flow
  }
}

void bg_or(int source, bool arbitrary) {
  if (guarded(source) || arbitrary) {
    sink(source); // flow
  } else {
    sink(source); // flow
  }
}

void bg_return(int source) {
  if (!guarded(source)) {
    return;
  }
  sink(source); // no flow
}

struct XY {
  int x, y;
};

void bg_stackstruct(XY s1, XY s2) {
  s1.x = source();
  if (guarded(s1.x)) {
    sink(s1.x); // no flow [FALSE POSITIVE in AST]
  } else if (guarded(s1.y)) {
    sink(s1.x); // flow
  } else if (guarded(s2.y)) {
    sink(s1.x); // flow
  }
}

void bg_structptr(XY *p1, XY *p2) {
  p1->x = source();
  if (guarded(p1->x)) {
    sink(p1->x); // no flow [FALSE POSITIVE in AST]
  } else if (guarded(p1->y)) {
    sink(p1->x); // flow
  } else if (guarded(p2->x)) {
    sink(p1->x); // flow
  }
}
