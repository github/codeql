
void f_if_1(int i) {
    if (i) {
        ;
    } else {
        ;
    }
}

void f_if_2(void) {
    if (1) {
        ;
    } else {
        ;
    }
}

void f_if_3(void) {
    if (0) {
        ;
    } else {
        ;
    }
}

void f_for_1(void) {
    int i;
    for(i = 0; i < 10; i++) {
        ;
    }
    return;
}

void f_for_2(void) {
    int i;
    for(i = 0; 1; i++) {
        ;
    }
    return;
}

void f_for_3(void) {
    int i;
    for(i = 0; 0; i++) {
        ;
    }
    return;
}

void f_while_1(int i) {
    while(i) {
        i--;
    }
    return;
}

void f_while_2(void) {
    while(1) {
        ;
    }
    return;
}

void f_while_3(void) {
    while(0) {
        ;
    }
    return;
}

void f_do_1(int i) {
    do {
        i--;
    } while (i);
    return;
}

void f_do_2(void) {
    do {
        ;
    } while (1);
    return;
}

void f_do_3(void) {
    do {
        ;
    } while (0);
    return;
}

void f_cond_1(int i) {
    int j = i ? 3 : 4;
    return;
}

void f_cond_2(void) {
    int j = 1 ? 3 : 4;
    return;
}

void f_cond_3(void) {
    int j = 0 ? 3 : 4;
    return;
}

void f_switch_1(int i) {
    switch(i) {
        case 0:
            return;
        case 1:
            return;
        case 2:
        case 3:
            ;
        case 4:
            return;
        default:
            return;
    }
    return;
}

void f_switch_2(int i) {
    switch(i) {
        case 0:
            return;
        case 1:
            return;
        case 2:
        case 3:
            ;
        case 4:
            return;
    }
    return;
}

void f_switch_3(void) {
    switch(1) {
        case 0:
            return;
        case 1:
            return;
        case 2:
        case 3:
            ;
        case 4:
            return;
        default:
            return;
    }
    return;
}

void f_switch_4(void) {
    switch(1) {
        case 0:
            return;
        case 1:
            return;
        case 2:
        case 3:
            ;
        case 4:
            return;
    }
    return;
}

void f_switch_5(void) {
    switch(9) {
        case 0:
            return;
        case 1:
            return;
        case 2:
        case 3:
            ;
        case 4:
            return;
        default:
            return;
    }
    return;
}

void f_switch_6(void) {
    switch(9) {
        case 0:
            return;
        case 1:
            return;
        case 2:
        case 3:
            ;
        case 4:
            return;
    }
    return;
}

void f_switch_7(int i) {
    switch(i ? 1 : 3) {
        case 0:
            return;
        case 1:
            return;
        case 2:
        case 3:
            ;
        case 4:
            return;
    }
    return;
}

int f_and_1(int x, int y) {
  if (x && !y) {
    return x;
  }
  return y;
}

int f_and_2(int x, int y) {
  if (!(x && y)) {
    return x;
  }
  return y;
}

void f_if_ternary_1(int b, int x, int y) {
  if (b ? x : y) {
  }
}
