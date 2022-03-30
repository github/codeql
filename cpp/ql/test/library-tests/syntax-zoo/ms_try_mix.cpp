// semmle-extractor-options: --microsoft
#define EXCEPTION_EXECUTE_HANDLER 1

class C {
    public:
        C(int x);
        ~C();
};

void ms_except_mix(int b1) {
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
}

void ms_finally_mix(int b2) {
    C c101(101);

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

// This function gets a buggy CFG from both the extractor and the QL CFG
// implementation. The extractor-produced CFG contains a loop (!), and the QL
// CFG may destruct c201 twice.
void ms_empty_finally_at_end() {
  C c201(201);

  __try {
    throw 3;
  }
  __finally {
  }
}
