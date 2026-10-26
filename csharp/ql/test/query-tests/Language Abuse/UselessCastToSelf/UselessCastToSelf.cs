using System;
using System.Linq.Expressions;

class Test
{
    void f()
    {
        // BAD
        var bad1 = (int)1; // $ Alert
        var bad2 = (Test)this; // $ Alert
        var bad3 = this as Test; // $ Alert
        func = (Func<int, int?>)(x => x); // $ MISSING: Alert
        exprFunc = (Expression<Func<int, int?>>)(x => x); // $ Alert

        // GOOD
        var good1 = (object)1;
        var good2 = (int)good1;
        var good3 = 1 as object;
        var good4 = good1 as Test;
        var good5 = (Action<int>)(x => { });
        var good6 = (Action<int>)(delegate (int x) { });
        var good7 = (Action<int>)((int x) => { });
        func = x => x;
        exprFunc = x => x;
        exprFuncUntyped = (Expression<Func<int, int?>>)(x => x); // $ SPURIOUS: Alert
    }

    enum Enum
    {
        A = 2,
        B = 1 | A,
        C = 1 | (int)A, // $ Alert // BAD
        D = 9 | (32 << A),
        E = 9 | (32 << (int)A) // $ Alert // BAD
    }

    private Func<int, int?> func;
    private Expression<Func<int, int?>> exprFunc;
    private LambdaExpression exprFuncUntyped;
}
