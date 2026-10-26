
void myFunction(int x = 10) {
    x = 3;
}

void f(void) {
    myFunction(9);
    myFunction();
}

