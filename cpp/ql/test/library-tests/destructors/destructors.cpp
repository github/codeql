
class C {
    public:
        C(int x);
        ~C();
};

void f(int b1, int b2) {
    C c10(110);
    {
        C c20(120);
        {
            C c30(130);
        }
        {
            C c31(131);
            if (b1) goto out;
            C c32(132);
            if (b2) return;
            C c33(133);
        }
        {
            C c34(134);
        }
        C c21(121);
    }
    {
        C c22(122);
    }
    {
out:
        C c23(123);
    }
    C c11(111);
}

