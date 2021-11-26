using System;
using System.Threading.Tasks;

public class LocalFunction
{
    public async Task M1()
    {
        int? i = 1;
        async Task<int?> mul(int mul)
        {
            return mul * i;
        }

        await mul(2);

        static extern void localExtern();
    }

    public void M2()
    {
        [Obsolete]
        int? dup([System.Diagnostics.CodeAnalysis.NotNullWhen(true)] bool b, int? i)
        {
            return 2 * i;
        }

        dup(true, 42);
    }
}
