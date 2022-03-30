void always_false_1() {
  while(0) {
    l1:;
  }
  l2:;
}

void always_false_2() {
  int done = 1;
  while(!done) {
    done = 0;
  }
}

void always_true_1() {
  while(1) {
    l1:;
    break;
  }
  l2:;
}

void always_true_2() {
  while(1) {
    l1:;
    break;
    l2:;
  }
  l3:;
}

void always_true_3() {
  while(1) {
    l1:;
  }
  l2:;
}

void normal() {
  int i = 0;
  while(i < 10) {
    ++i;
  }
  l:;
}
