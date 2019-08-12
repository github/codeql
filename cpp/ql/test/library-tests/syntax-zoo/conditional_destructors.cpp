
class C1 {
    public:
        int val;
        C1(int x) {
            val = x;
        }

    bool operator==(const C1 &other) const {
        return val == other.val;
    }
};

class C2 {
    public:
        int val;
        C2(int x) {
            val = x;
        }
        ~C2() {
            ;
        }

    bool operator==(const C2 &other) const {
        return val == other.val;
    }
};

void f1(void) {
    if (C1(1) == C1(2)) {
        ;
    }
    if (C1(3) == C1(3)) {
        ;
    }
}

void f2(void) {
    if (C2(1) == C2(2)) {
        ;
    }
    if (C2(3) == C2(3)) {
        ;
    }
}

