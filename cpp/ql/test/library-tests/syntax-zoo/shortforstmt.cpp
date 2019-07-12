void always_false() {
  for(;0;) {
    l1:;
  }
  l2:;
}

void always_true_1() {
  for(;1;) {
    l1:;
    break;
  }
  l2:;
}

void always_true_2() {
  for(;1;) {
    l1:;
    if(0) break;
    if(1) break;
    l2:;
  }
  l3:;
}

void always_true_3() {
  for(;1;) {
    l1:;
  }
  l2:;
}

void normal(int x, int y) {
  for(;x < y;) {
    x = y;
  }
  l:;
}
