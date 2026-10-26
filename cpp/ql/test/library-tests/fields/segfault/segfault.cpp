
struct Private;
typedef int (Private::*Zero);

class C {
public:
    C(Zero x = 0) {}
};

void f() {
    C result;
}

