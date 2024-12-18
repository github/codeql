int source();
void sink(...);
bool guarded(int);

void bg_basic(int source) {
  if (guarded(source)) {
    sink(source);
  } else {
    sink(source); // $ ast,ir
  }
}

void bg_not(int source) {
  if (!guarded(source)) {
    sink(source); // $ ast,ir
  } else {
    sink(source);
  }
}

void bg_and(int source, bool arbitrary) {
  if (guarded(source) && arbitrary) {
    sink(source);
  } else {
    sink(source); // $ ast,ir
  }
}

void bg_or(int source, bool arbitrary) {
  if (guarded(source) || arbitrary) {
    sink(source); // $ ast,ir
  } else {
    sink(source); // $ ast,ir
  }
}

void bg_return(int source) {
  if (!guarded(source)) {
    return;
  }
  sink(source);
}

struct XY {
  int x, y;
};

void bg_stackstruct(XY s1, XY s2) {
  s1.x = source();
  if (guarded(s1.x)) {
    sink(s1.x); // $ SPURIOUS: ast
  } else if (guarded(s1.y)) {
    sink(s1.x); // $ ast,ir
  } else if (guarded(s2.y)) {
    sink(s1.x); // $ ast,ir
  }
}

void bg_structptr(XY *p1, XY *p2) { // $ ast-def=p1 ast-def=p2 ir-def=*p1 ir-def=*p2
  p1->x = source();
  if (guarded(p1->x)) {
    sink(p1->x); // $ SPURIOUS: ast
  } else if (guarded(p1->y)) {
    sink(p1->x); // $ ast,ir
  } else if (guarded(p2->x)) {
    sink(p1->x); // $ ast,ir
  }
}

int* indirect_source();
bool guarded(const int*);

void bg_indirect_expr() {
  int *buf = indirect_source();
  if (guarded(buf)) {
    sink(buf);
  }
}

void test_guard_and_reassign() {
  int x = source();

  if(!guarded(x)) {
    x = 0;
  }
  sink(x); // $ SPURIOUS: ast
}

void test_phi_read_guard(bool b) {
  int x = source();

  if(b) {
    if(!guarded(x))
      return;
  }
  else {
    if(!guarded(x))
      return;
  }
  
  sink(x); // $ SPURIOUS: ast
}

bool unsafe(int);

void test_guard_and_reassign_2() {
  int x = source();

  if(unsafe(x)) {
    x = 0;
  }
  sink(x); // $ SPURIOUS: ast
}

void test_phi_read_guard_2(bool b) {
  int x = source();

  if(b) {
    if(unsafe(x))
      return;
  }
  else {
    if(unsafe(x))
      return;
  }
  
  sink(x); // $ SPURIOUS: ast
}