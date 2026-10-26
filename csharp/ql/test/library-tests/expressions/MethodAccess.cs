using System;

class MethodAccess
{
    void M()
    {
        void M1() { };
        Action a = M1;
        a = M2;
        a = this.M2;
        a = M3;
        a = MethodAccess.M3;
    }

    void M2() { }

    static void M3() { }
}
