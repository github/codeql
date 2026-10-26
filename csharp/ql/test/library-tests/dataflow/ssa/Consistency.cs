using System;

class Consistency
{
    int Field;

    void Splitting(bool b)
    {
        try
        {
            if (b) throw new System.Exception();
        }
        finally
        {
            var i = 1;
            Use(i);
        }
    }

    void DoubleDef()
    {
        // This is, in principle, a double definition of `c.Field`: one for the
        // qualifier `c`, and one for `Field` via the call to `Out`. The SSA library
        // makes the choice to only include the former definition
        Out(out Consistency c);
        Use(c.Field);
        Use(c.Field);
    }

    void Out(out Consistency c)
    {
        c = new Consistency();
        c.Field = 0;
    }

    void CapturedDeclNoInit()
    {
        int i; // Should not get an SSA definition
        Action a = () => { i = 0; Use(i); };
    }

    void StructDeclNoInit()
    {
        S s; // Should get an SSA definition
        s.I = 0;
        Use(s);
    }

    ref int GetElement(int[] a, int i) => ref a[i];

    void Ref(int[] a)
    {
        var i = GetElement(a, 0);         // Should *not* get an SSA definition
        i = 0;                            // Should *not* get an SSA definition
        ref var j = ref GetElement(a, 0); // Should *not* get an SSA definition
        ref var k = ref GetElement(a, 0); // Should get an SSA definition
        k = 0;                            // Should get an SSA definition
        k = 1;                            // Should get an SSA definition
    }

    void Use<T>(T x) { }
}

struct S
{
    public int I;
}
