using System;

class C<T>
{
    object x1;
    dynamic x2;
    object[] x3;
    dynamic[] x4;
    object[,,,] x5;
    dynamic[,,,] x6;
    C<object> x7;
    C<dynamic> x8;
    C<C<dynamic[]>> x9;
    C<C<object[]>> x10;

    // Verify conversions
    void M()
    {
        x1 = x2;
        x2 = x1;
        x3 = x4;
        x4 = x3;
        x5 = x6;
        x6 = x5;
        x7 = x8;
        x8 = x7;
        x9 = x10;
        x10 = x9;
    }
}

// semmle-extractor-options: /r:System.Dynamic.Runtime.dll /r:System.Linq.Expressions.dll
