
int topLevel = 100;

class MyPureClass {
    public:
    MyPureClass operator+(const MyPureClass &other) {
    }
    MyPureClass operator=(const MyPureClass &other) {
    }
    MyPureClass &operator++() {
    }
    MyPureClass operator++(int x) {
    }
};

class MyImpureClass {
    public:
    MyImpureClass operator+(const MyImpureClass &other) {
        topLevel += 1;
    }
    MyImpureClass operator=(const MyImpureClass &other) {
        topLevel += 2;
    }
    MyImpureClass &operator++() {
        topLevel += 4;
    }
    MyImpureClass operator++(int x) {
        topLevel += 8;
    }
};

void cpp_operator_overloading() {
    int x = 1;
    MyPureClass p = MyPureClass();
    MyImpureClass i = MyImpureClass();

    x = x + x;
    p = p + p;
    i = i + i;
    ++x;
    ++p;
    ++i;
    x++;
    p++;
    i++;
}

