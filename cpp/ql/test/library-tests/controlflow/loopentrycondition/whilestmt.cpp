// GOOD = at least one iteration
// BAD = possibly no iterations

void test1() {
    bool done = false;
    while (!done) { // GOOD
        done = true;
    }
}

void test2() {
    bool done = true;
    done = false;
    while (!done) { // GOOD (NOT REPORTED)
        done = true;
    }
}

void test3(int i) {
    bool done = false;
    for (; i++; i < 10) {
        while (!done) { // BAD
            done = true;
        }
    }
}

void test4(int i) {
    for (; i++; i < 10) {
        bool done = false;
        while (!done) { // GOOD
            done = true;
        }
    }
}

void test5(int max) {
  int i = 0, k = 0;
  int max_index = 0;
  while (i < max) { // BAD
      max_index = i;
      i++;
  }
  i = 0;
  while (i <= max_index) { // BAD
      i++;
  }
}

void test6() {
    int i = 1;
    while (i > 0) { // GOOD
      &i;
    }
}

void test7(bool b) {
    int i = 1;
    while (b) { // BAD
        while (i > 0) { // BAD
          &i;
        }
    }
}