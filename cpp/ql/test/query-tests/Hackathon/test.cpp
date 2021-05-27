void start();
void end();

void test1(bool b) {
  if(b) {
    start();
  }

  if(b) {
    end(); // BAD
  }
}

void test2(bool b) {
  if(b) {
    start();
  }

  if(!b) {
    end(); // GOOD [FALSE POSITIVE]
  }
}

void test3(bool b) {
  if(b) { }
  else {
    start();
  }

  if(!b) {
    end(); // BAD
  }
}

void test4(bool b) {
  if(b) {
    start();
  }

  if(!b) { }
  else {
    end(); // BAD
  }
}

void test5(bool b) {
  if(b) { }
  else {
    start();
  }

  if(!b) { }
  else {
    end(); // GOOD [FALSE POSITIVE]
  }
}
