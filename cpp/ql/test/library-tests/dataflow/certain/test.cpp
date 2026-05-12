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
  use(x); // $ uncertain="SSA phi(x)"
  }

  {
  int x; // $ certain="SSA def(&x)" certain="SSA def(x)"
  if(b) {
    x = 0; // $ certain="SSA def(x)"
  } else {
  
  }
  use(x); // $ uncertain="SSA phi(x)"
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
  for(int i = 0; i < 10;) { // $ certain="SSA def(&i)" certain="SSA def(i)" uncertain="SSA phi(i)"
    if(b) {
      ++i; // $ certain="SSA def(i)"
    }
    use(i); // $ uncertain="SSA phi(i)"
  }
}