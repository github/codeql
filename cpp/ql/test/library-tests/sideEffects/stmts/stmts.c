
void f(int x) {
    int y;
    int z = x + 3;
    int j = y++;

    switch(x) {
        case 3:
            return;
        case 4:
            break;
        default:
            return;
    }
    return;
}

int x = 0;

struct myStruct {
    int myInt;
} *p;

struct myStruct *getMyStruct(void) {
    x = 1;

    return p;
}

void f2(void) {
    int i;
    getMyStruct()->myInt;
}

