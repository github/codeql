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