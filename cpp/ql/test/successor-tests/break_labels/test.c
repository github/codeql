
int f(int i) {
    int result = 0;
    if (i != 0) {
        result++;
        while (i < 10) {
            if (i++ == 5) {
                result = 7;
                break;
            }
        }
    }
    return result;
}

void f_for(void) {
    int i;
    int x = 0;

    for(i = 0; i < 10; i++) {
        if (i == 5) {
            continue;
        }
        if (i == 7) {
            break;
        }
        x++;
    }
}

