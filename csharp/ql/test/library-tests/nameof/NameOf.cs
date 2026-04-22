using System;
using System.Collections.Generic;

class Program
{
    public void M(int x)
    {
        var test1 = nameof(x);
        var test2 = nameof(M);
        var test3 = nameof(Program);
        var test4 = nameof(String);
        var test5 = nameof(List<int>);
        var test6 = nameof(List<>);
    }
}
