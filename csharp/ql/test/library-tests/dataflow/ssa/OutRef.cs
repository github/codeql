using System;

class OutRef
{
    int Field;

    void M()
    {
        int j = 0;
        OutRefM(out int i, ref j);
        Use(i);
        Use(j);
        OutRefM(out i, ref Field);
        Use(i);
        Use(Field);
        OutRefM(out Field, ref Field);
        Use(Field);
        var t = new OutRef();
        OutRefM(out Field, ref t.Field);
        Use(Field);
        Use(t.Field);
        OutRefM2(out j, ref j);
        Use(j);
        OutRefM3(false, ref j);
        Use(j);
    }

    void OutRefM(out int i, ref int j)
    {
        i = j;
        j = 1;
    }

    void OutRefM2(out int i, ref int j)
    {
        i = j;
    }

    void OutRefM3(bool b, ref int j)
    {
        if (b)
            j = 1;
    }

    static void Use<T>(T u) { }
}
