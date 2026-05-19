void use(...);

void test1() {
  int x = 0; // $ certain="SSA def(&x)" certain="SSA def(x)"
  use(x);

  x = 1; // $ certain="SSA def(x)"
  use(x);

  int* p = &x; // $ certain="SSA def(&p)" certain="SSA def(p)" certain="SSA def(*p)"
  use(p);

  *p = 2; // $ certain="SSA def(*p)"
  use(p);

  p = nullptr; // $ certain="SSA def(p)" certain="SSA def(*p)"
  use(p);

  *p = 2; // $ uncertain="SSA def(*p)"
  use(p);
}

void test2(bool b) { // $ certain="SSA def(&b)" certain="SSA def(b)"
  {
  int x; // $ certain="SSA def(&x)" 
  if(b) {
    x = 0; // $ certain="SSA def(x)"
  } else {
    x = 1; // $ certain="SSA def(x)"
  }
  use(x); // $ certain="SSA phi(x)"
  }

  {
  int x; // $ certain="SSA def(&x)" certain="SSA def(x)"
  if(b) {
    x = 0; // $ certain="SSA def(x)"
  } else {
  
  }
  use(x); // $ certain="SSA phi(x)"
  }

  {
  int x; // $ certain="SSA def(&x)" certain="SSA def(x)"
  int* p = &x; // $ certain="SSA def(&p)" certain="SSA def(p)" certain="SSA def(*p)"
  if(b) {
    *p = 0; // $ certain="SSA def(*p)"
  } else {
    *(p + 1) = 1; // $ uncertain="SSA def(*p)"
  }
  use(p); // $ uncertain="SSA phi(*p)"
  }
  
}

void test3(bool b) { // $ certain="SSA def(&b)" certain="SSA def(b)"
  for(int i = 0; i < 10;) { // $ certain="SSA def(&i)" certain="SSA def(i)" certain="SSA phi(i)"
    if(b) {
      ++i; // $ certain="SSA def(i)"
    }
    use(i); // $ certain="SSA phi(i)"
  }
}

void test(int x, bool b1, bool b2) { // $ certain="SSA def(&x)" certain="SSA def(x)" certain="SSA def(&b1)" certain="SSA def(b1)" certain="SSA def(&b2)" certain="SSA def(b2)"
  int* p = &x; // $ certain="SSA def(&p)" certain="SSA def(p)" certain="SSA def(*p)" 
  int i = 0; // $ certain="SSA def(&i)" certain="SSA def(i)"
  int j = 0; // $ certain="SSA def(&j)" certain="SSA def(j)"
  while (i < 10) { // $ certain="SSA phi(i)" uncertain="SSA phi(*p)"
  if (b1) {
    *p = 0; // $ certain="SSA def(*p)" 
  }
  ++i; // $ certain="SSA def(i)" uncertain="SSA phi(*p)"
  }
  while (j < 10) { // $ uncertain="SSA phi(*p)" certain="SSA phi(j)"
    if (b2) {
      *(p + j) = 0; // $ uncertain="SSA def(*p)"
    }
    ++j; // $ certain="SSA def(j)" uncertain="SSA phi(*p)"
  }
}