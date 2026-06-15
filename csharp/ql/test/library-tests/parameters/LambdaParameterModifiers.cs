using System;
using System.Collections.Generic;

public class LambdaParameterModifiers
{
    delegate void MyRef(ref int i1);
    delegate void MyOut(out int i2);
    delegate void MyIn(in int i3);
    delegate void MyRefReadonly(ref readonly int i4);

    delegate void MyScopedRef(scoped ref int i5);

    public void M()
    {
        // Explicitly typed lambda parameters with modifiers.
        var l1 = (ref int x1) => x1;
        var l2 = (out int x2) => x2 = 0;
        var l3 = (in int x3) => x3;
        var l4 = (ref readonly int x4) => x4;
        var l5 = (scoped ref int x5) => x5;
        var l6 = (params IEnumerable<int> x6) => x6;

        // Implicitly typed lambda parameters with modifiers.
        MyRef l7 = (ref i1) => { };
        MyOut l8 = (out i2) => i2 = 0;
        MyIn l9 = (in i3) => { };
        MyRefReadonly l10 = (ref readonly i4) => { };
        MyScopedRef l11 = (scoped ref i5) => { };
    }
}
