int source();
void sink(int);

void source_ref(int *toTaint) { // $ ir-def=*toTaint ast-def=toTaint
    *toTaint = source();
}



void modify_copy(int* ptr) { // $ ast-def=ptr
  int deref = *ptr;
  int* other = &deref;
  source_ref(other);
}

void test_output() {
   int x = 0;
   modify_copy(&x);
   sink(x); // $ SPURIOUS: ir
}