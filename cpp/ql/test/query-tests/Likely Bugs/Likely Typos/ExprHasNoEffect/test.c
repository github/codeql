
extern int g(void);

void f(int b) {
    int i;

    0; // $ Alert

    ({ 1; 2; 3; }); // $ Alert
    i = ({ 4; 5; 6; }); // $ Alert
    i = ({ 7; 8; 9, 10; }); // $ Alert

    i = 11, 12; // $ Alert
    i = 13, 14, 15; // $ Alert
    i = (16, 17); // $ Alert
    i = (18, 19, 20); // $ Alert
    21, 22; // $ Alert
    23, 24, 25; // $ Alert

    i = b ? 26  : 27;
    i = b ? g() : 28;
    i = b ? 29  : g();
    i = b ? g() : g();

    b ? 30  : 31; // $ Alert
    b ? g() : 32; // $ Alert
    b ? 33  : g(); // $ Alert
    b ? g() : g();
}

