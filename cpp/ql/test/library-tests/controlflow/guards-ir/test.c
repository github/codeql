
int test(int x, int w, int z) {
    int j;
    long y = 50;

    // simple comparison
    if (x > 0) {
        y = 20;
        z = 10;
    } else {
        y = 30;
    }

    z = x + y;

    // More complex
    if(x < 0 && y > 1)
        y = 40;
    else
        y = 20;  /* The && expression does not control this block as the x<0 expression jumps here if false. */


    z = 10;

    // while loop
    while(x > 0) {
        y = 10;
        x--;
    }

    z += y;

    // for loop
    for(j = 0; j < 10; j++) {
        y = 0;
        w = 10;
    }

    z += w;

    // nested control flow
    for(j = 0; j < 10; j++) {
        y = 30;
        if(z > 0)
            if(y > 0) {
                w = 0;
                break;
            } else {
                w = 20;
            }
        else {
            w = 10;
            continue;
        }
        x = 0;
    }

    if (x == 0 || y < 0) {
        y = 60;
        z = 10;
    } else
        return z;

    z += x;

    return 0;
}


int test2(int x, int w, int z) {
    int j;
    long y = 50;

    // simple comparison
    if (x == 0) {
        y = 20;
        z = 10;
    } else {
        y = 30;
    }

    z = x + y;

    // More complex
    if(x == 0 && y != 0)
        y = 40;
    else
        y = 20;

    
    z = 10;

    // while loop
    while(x != 0) {
        y = 10;
        x--;
    }

    z += y;

    // for loop
    for(j = 0; j < 10; j++) {
        y = 0;
        w = 10;
    }

    z += w;

    if (x == 0 || y < 0) {
        y = 60;
        z = 10;
    } else
        return z;

    z += x;

    return 0;
}

int test3_condition();
void test3_action();

void test3() {
  int b = 0;

  if (1 && test3_condition()) {
    b = 1;
    test3_action();
  }

  if (b) {
    test3_action();
  }
}

void test4(int i) {
  if (0) {
    if (i) {
      ;
    }
  }
  return;
}

void test5(int x) {
  if (!x) {
    test3();
  }
}

void test6(int x, int y) {
  return x && y;
}
