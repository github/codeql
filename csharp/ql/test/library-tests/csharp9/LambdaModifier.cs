using System;
using System.Threading.Tasks;

public class Class1
{
    public async Task M1()
    {
        void m(Func<int, int> f) { }

        const int z = 10;
        m(static x => x + z);
        m(x => x + z);
        m(static delegate (int x) { return x + z; });

        await Task.Run(async () => { await Task.CompletedTask; });
    }
}
