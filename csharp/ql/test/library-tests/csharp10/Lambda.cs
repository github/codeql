using System;

public class Lambda
{
    public void M1()
    {
        // Examples need for implicitly typed lambdas.
        Func<int, string> f1 = (int x) => x.ToString();
        var f2 = (int x) => x.ToString();

        // Examples need for  explicit return type for implicitly and explicitly typed lambda.
        var f3 = object (bool b) => b ? "1" : 0;
        Func<bool, object> f4 = object (bool b) => b ? "1" : 0;

        // Examples needed for explicit return type for downcast.
        var f5 = int (bool b) => b ? 1 : 0;
        var f6 = object (bool b) => b ? 1 : 0;
    }
}

