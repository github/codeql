using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;

class MissedSelectOpportunity
{
    public void M1(List<int> lst)
    {
        // BAD: Can be replaced with lst.Select(i => i * i)
        foreach (int i in lst)
        {
            int j = i * i;
            Console.WriteLine(j);
        } // $ Alert
    }

    public async Task M2(IEnumerable<ICounter> counters)
    {
        // GOOD: Cannot use Select because the initializer contains an await expression
        foreach (var counter in counters)
        {
            var count = await counter.CountAsync();
            Console.WriteLine(count);
        }
    }

    public void M3(List<int> lst, out int x)
    {
        // GOOD: Linq can't be used here as the Select would capture an out parameter.
        x = 2;
        foreach (int i in lst)
        {
            int j = i * x;
            Console.WriteLine(j);
        }
    }

    public interface ICounter
    {
        Task<int> CountAsync();
    }
}
