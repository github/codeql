
template <typename T>
class TC1 {
    public:
    T fun() const {
        return 5;
    }
};

template <typename T>
class TC2 {
    public:
    T fun() const {
        return 5;
    }
};

void f(void) {
    int i;

    TC1<int> *tc1 = new TC1<int>();
    i = tc1->fun();

    TC2<const int> *tc2 = new TC2<const int>();
    i = tc2->fun();
}

