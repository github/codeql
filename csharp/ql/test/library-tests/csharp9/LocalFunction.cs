using System;
using System.Threading.Tasks;

public class Class1
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
}