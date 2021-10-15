extern "C++" {
    namespace std {
        typedef unsigned long size_t;
    }

    void* operator new(std::size_t);
    void* operator new[](std::size_t);
    void operator delete(void*);
    void operator delete[](void*);
}

class C_with_constr_destr {
    public:
    C_with_constr_destr() { };
    ~C_with_constr_destr() { };
};

void f_with_op(int i) {
    char *c = new char;
    char *buf1 = new char[500];
    char *buf2 = new char[500 + i];
    delete[] buf2;
    delete[] buf1;
    delete c;

    C_with_constr_destr *cd = new C_with_constr_destr;
    delete cd;
}
