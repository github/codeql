template<typename T> void mod(T value);

const int c1 = 42;
const int c2 = 43;

void m(int i, bool cond, int x, int y) {
    int eq = i + 3;

    int mul = eq * c1 + 3; // congruent 3 mod 42

    int seven = 7;
    if (mul % c2 == seven) {
        mod(mul); // $ mod=0,3,42
    }

    int j = cond
        ? i * 4 + 3
        : i * 8 + 7;
    mod(j); // $ mod=0,3,4

    if (x % c1 == 3 && y % c1 == 7) {
        mod(x + y); // $ mod=0,10,42
    }

    if (x % c1 == 3 && y % c1 == 7) {
        mod(x - y); // $ mod=0,38,42
    }

    if (cond) {
        j = i * 4 + 3;
    }
    else {
        j = i * 8 + 7;
    }
    mod(j); // $ mod=0,3,4

    if (cond) {
        mod(j); // $ mod=0,3,4
    } else {
        mod(j); // $ mod=0,3,4
    }

    if ((x & 15) == 3) {
        mod(x); // $ mod=0,3,16
    }
}

void loops(int cap)
{
    for (int i = 0; i < cap; i++)
        mod(i);

    for (int j = 0; j < cap; j += 1)
        mod(j);

    for (int k = 0; k < cap; k += 3)
        mod(k); // $ mod=0,0,3
}
