
int x;

void f1(void) {
    x = 1;
    return;
    x = 2;
}

void f2(void) {
    if (1) {
        x = 1;
    } else {
        x = 2;
    }

    if (0) {
        x = 1;
    } else {
        x = 2;
    }
}

void f3(void) {
    x = 1;

    while (1) {
        x = 2;
    }

    x = 3;
}

void f4(void) {
    x = 1;

    while (1) {
        x = 2;
        break;
    }

    x = 3;
}

void f5(void) {
    x = 1;

    for (;;) {
        x = 2;
    }

    x = 3;
}

void f6(void) {
    x = 1;

    for (;;) {
        x = 2;
        goto out;
    }

out:
    x = 3;
}

void f7(void) {
    x = 1;

start:
    switch (0) {
    case 0:
        goto start;
    default:
        return;
    }
}

void f8(void) {
    x = 1;

start:
    goto start;
    return;
}

