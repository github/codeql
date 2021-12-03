class A {
  final boolean cond = otherCond();

  boolean otherCond() { return 3 > 5; }

  void f(int initx) {
    boolean done = false;
    while(!done) { // BAD: main loop condition is constant in the loop
      if (otherCond()) break;
    }

    int x = initx * 2;
    int i = 0;
    for(x++; ; i++) {
      if (x > 5 && otherCond()) { // BAD: x>5 is constant in the loop and guards all exits
        if (i > 3) break;
        if (otherCond()) return;
      }
    }

    x = initx;
    i = 0;
    while(true) {
      if (x > 5) break; // OK: more than one exit
      if (i > 3) break;
      i++;
    }

    for(int j = 0; j < 2 * initx; i++) { // BAD: j<initx is constant in the loop
    }

    while(initx > 0) { // OK: loop used as an if-statement
      break;
    }

    while (cond) { // BAD: read of final field
      i++;
    }
  }
}
