using System;
using System.Collections.Generic;

public ref struct RS
{
    public int GetZero() { return 0; }
}

public class C
{
    private int one = 1;

    // Test that we can use unsafe context, ref locals and ref structs in iterators.
    public IEnumerable<int> GetObjects()
    {
        unsafe
        {
            // Do pointer stuff
        }
        ref int i = ref one;
        RS rs;
        var zero = rs.GetZero();
        yield return zero;
    }
}
