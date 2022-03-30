
void f1(int i) {
    switch(i) {
        case 1:
        case 2:
        case 3:
            i = 3; // Bad
        case 4:
        case 5:
        case 6:
            i = 6;
            break; // OK: has break
        case 7:
        case 8:
        case 9:
            i = 9;
            return; // OK: has return
        default:
            i = 10; // OK: default at end
    }
}

void f2(int i) {
    switch(i) {
        case 1:
        case 2:
        case 3:
            i = 3; // Bad
        case 4:
        case 5:
        case 6:
            i = 6;
            break; // OK: has break
        default:
            i = 10; // Bad: default not at end
        case 7:
        case 8:
        case 9:
            i = 9;
            return; // OK: has return
    }
}

void f3(int i) {
    switch(i) {
        case 1:
        case 2:
        case 3:
            i = 3; // Bad
        case 4:
        case 5:
        case 6:
            i = 6;
            break; // OK: has break
        case 7:
        case 8:
        case 9:
            i = 9;
            return; // OK: has return
        case 10:
        case 11:
        case 12:
            i = 12; // Bad
    }
}

void f4(int i) {
    switch(i) {
        case 1:
        case 2:
        case 3:
            {
                i = 3; // Bad
            }
        case 4:
        case 5:
        case 6:
            {
                i = 6;
                break; // OK: has break
            }
        case 7:
        case 8:
        case 9:
            {
                i = 9;
                return; // OK: has return
            }
        default:
            {
                i = 10; // OK: default at end
            }
    }
}

