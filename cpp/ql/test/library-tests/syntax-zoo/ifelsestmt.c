void always_false_1() {
  if(0) {
    l1:;
  }
  else {
    l2:;
  }
  l3:;
}

void always_false_2() {
  if(0)
    l1:;
  else
    l2:;
  l3:;
}

void always_true_1() {
  if(1) {
    l1:;
  }
  else {
    l2:;
  }
  l3:;
}

void always_true_2() {
  if(1)
    l1:;
  else
    l2:;
  l3:;
}

void normal(int x, int y) {
  if(x == y) {
    l1:;
  }
  else {
    l2:;
  }
  l3:;
}
