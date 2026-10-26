
static float g(void);

void c_f(void) {
    float x, y;

    x == 3.0;
    3.0 == x;
    x == x;
    x == y; // $ Alert

    g() == 3.0;
    3.0 == g();
    g() == g(); // $ Alert

    x == g(); // $ Alert
    g() == x; // $ Alert
}

