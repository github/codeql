// semmle-extractor-options: --microsoft
#define EXCEPTION_EXECUTE_HANDLER 1

class C {
    public:
        C(int x);
        ~C();
};

void f(int b1, int b2) {
    C c101(101);

    __try {
        C c102(102);
        if (b1) {
            throw 1;
        }
        C c103(103);
    }
    __except (EXCEPTION_EXECUTE_HANDLER) {
        C c104(104);
    }

    C c105(105);

    __try {
        C c106(106);
        if (b2) {
            throw 2;
        }
        C c107(107);
    }
    __finally {
        C c108(108);
    }

    C c109(109);
}

