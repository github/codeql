typedef struct { int i; } MyInt;
MyInt f(MyInt);

int main() {
    MyInt myInt = { 0 };
    // This call dispatches to one `Function` that has three `Location`s and
    // two `Parameters`. The first `Parameter` has three types.
    f(myInt);
    return 0;
}
