using System;
using System.Linq;

class VariableNameTooShort
{
    int F; // BAD
    int Foo; // GOOD

    Func<int, string> Func = _ => "";

    void M(int i /* BAD */, int[] args /* GOOD */)
    {
        args.Select(x /* GOOD */ => x + 1);
        Func<int, int> func = x /* BAD */ => x + 1;
    }
}
