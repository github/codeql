using System;

class VarDecls
{
    unsafe ulong M1(string[] strings)
    {
        fixed (char* c1 = strings[0], c2 = strings[1])
        {
            return (ulong)c1;
        }
    }

    string M2(string s)
    {
        string s1 = s, s2 = s;
        return s1 + s2;
    }

    C M3(bool b)
    {
        using (new C())
            ;

        using (C x = new C(), y = new C())
            return b ? x : y;
    }

    class C : IDisposable { public void Dispose() { } }
}
