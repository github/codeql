void f1() {
    for (int i = 0; i < 10; i++) {
        l1:
    }
    ;
}

void f2() {
    for (int i = 0; false; i++) { // true edge pruned
    }
}

void f3() {
    for (int i = 0; true; i++) { // false edge pruned
    }
}

void f4() {
    for (int i = 0; i < 0; i++) { // true edge pruned
    }
}