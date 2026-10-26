class Foo {};

void named() {
  try {
  }
  catch(Foo x) {
  }
  catch(const char* y) {
  }
  catch(int z) {
  }
}

void unnamed() {
  try {
  }
  catch(Foo) {
  }
  catch(const char*) {
  }
  catch(int) {
  }
}
