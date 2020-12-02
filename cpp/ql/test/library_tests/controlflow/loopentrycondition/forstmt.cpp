// GOOD = at least one iteration
// BAD = possibly no iterations

void test1() {
    for (int i = 0; i < 10; i++) { // GOOD
    }
}

void test2() {
    for (int i = 0, j = 1; i + j < 10; i++) { // GOOD
    }
}

void test3() {
    int j = 2;
    for (int i = j = 1; i + j < 10; i++) { // GOOD
    }
}

void test4() {
    int i = 2, j = 3;
    for (i = j = 1; i + j < 10; i++) { // GOOD
    }
}

void test5() {
    int i, k;
    for (i = k = 0; i < 10; i++) { // GOOD
    }
}

void test6() {
    int i = 0;
    for (; i < 10; i++) { // GOOD
      i = 1;
    }
}

void test7() {
    int i = 0;
    for (i = 1; i < 10; i++) { // GOOD
      i = 1;
    }
}

void test8() {
    int i = 0;
    i = 1;
    for (; i < 10; i++) { // GOOD (NOT REPORTED)
    }
}

void test9() {
    bool done = false;
    for (; !done; ) { // GOOD
      done = true;
    }
}

void test10(int i) {
    bool done = false;
    for (; i++; i < 10) { // BAD
        for (; !done; ) { // BAD
            done = true;
        }
    }
}

void test11(int i) {
    for (; i++; i < 10) { // BAD
        bool done = false;
        for (; !done; ) { // GOOD
            done = true;
        }
    }
}

void test12(int max) {
  int i, k;
  int max_index = 0;
  for (i = k = 0; i < max; i++) { // BAD
    max_index = i;
  }
  for (i = 0; i <= max_index; i++) { // BAD
  }
}

void test13() {
    int i;
    for (i = 1; i > 0; ) { // GOOD
      &i;
    }
}

void test14(bool b) {
    int i = 1;
    while (b) {
        for (; i > 0; ) { // BAD
          &i;
        }
    }
}