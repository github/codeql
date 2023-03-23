void always_false() {
  do {
    l1:;
  } while(0);
  l2:;
}

static void always_true_1() {
  do {
    l1:;
    break;
  } while(1);
  l2:;
}

static void always_true_2() {
  do {
    l1:;
    break;
    l2:;
  } while(1);
  l3:;
}

static void always_true_3() {
  do {
    l1:;
  } while(1);
  l2:;
}

static void normal() {
  int i = 0;
  do {
    ++i;
  } while(i < 10);
  l:;
}
