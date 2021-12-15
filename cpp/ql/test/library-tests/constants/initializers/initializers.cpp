
int cppi = 3;
int cppj = 4;

void g(void) {
    int &ri = cppi;
    int &rj = cppj;

    ri = 4;
}

