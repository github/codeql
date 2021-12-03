
int i = 5;
int j = 6;
int k = 7;
int l = 8;
int m = 9;

void f(void) {
    int *p;

    j++;
    k = 8;

    p = &l;
    *p = 9;

    p = &m; // We will conservatively assume that m might be modified
}

