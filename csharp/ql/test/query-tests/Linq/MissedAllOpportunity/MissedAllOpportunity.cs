using System;
using System.Linq;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

class MissedAllOpportunity
{
    public void M1(List<int> lst)
    {
        // BAD: Can be replaced with lst.All(e => e % 2 == 0)
        var allEven = true;
        foreach (int i in lst)
        {
            if (i % 2 != 0)
            {
                allEven = false;
                break;
            }
        } // $ Alert
    }

    public void M2(NonEnumerableClass nec)
    {
        // GOOD: Linq can't be used here.
        var allEven = true;
        foreach (int i in nec)
        {
            if (i % 2 != 0)
            {
                allEven = false;
                break;
            }
        }
    }

    public void M3(List<int> lst, ref int x)
    {
        // GOOD: Linq can't be used here because the condition uses a ref parameter.
        var allEven = true;
        foreach (int i in lst)
        {
            if (i % 2 != x)
            {
                allEven = false;
                break;
            }
        }
    }

    public class NonEnumerableClass
    {
        public IEnumerator<int> GetEnumerator() => throw null;
    }

    private static bool ValidateReferenceChains(List<string> references, Dictionary<string, object> documents, object diagnostic, CancellationToken cancellationToken)
    {
        var completed = new HashSet<string>();
        foreach (var start in references)
        {
            if (!ValidateReferenceChain(start, completed, documents, diagnostic, cancellationToken))
            {
                return false;
            }
        } // $ Alert
        return true;
    }

    private static bool ValidateReferenceChain(string start, HashSet<string> completed, Dictionary<string, object> documents, object diagnostic, CancellationToken cancellationToken) => throw null;

    public bool ReturnFalseWithoutBraces(List<int> lst)
    {
        foreach (int i in lst)
            if (i % 2 != 0)
                return false; // $ Alert
        return true;
    }

    public bool ReturnFalseAfterLoop(List<int> lst)
    {
        foreach (int i in lst)
        {
            if (i % 2 != 0)
                return false;
        }
        return false;
    }

    public bool ExtraWorkBeforeReturningFalse(List<int> lst)
    {
        foreach (int i in lst)
        {
            if (i % 2 != 0)
            {
                Console.WriteLine(i);
                return false;
            }
        }
        return true;
    }

    public bool ExtraWorkAfterLoop(List<int> lst)
    {
        foreach (int i in lst)
        {
            if (i % 2 != 0)
                return false;
        }
        Console.WriteLine("All elements checked");
        return true;
    }

    public bool ReturnFalseWithElse(List<int> lst)
    {
        foreach (int i in lst)
        {
            if (i % 2 != 0)
                return false;
            else
                Console.WriteLine(i);
        }
        return true;
    }

    public bool ReturnFalseWithRefParameter(List<int> lst, ref int x)
    {
        foreach (int i in lst)
        {
            if (i % 2 != x)
                return false;
        }
        return true;
    }

    public async Task<bool> ReturnFalseWithAwait(List<int> lst)
    {
        foreach (int i in lst)
        {
            if (!await Task.FromResult(i % 2 == 0))
                return false;
        }
        return true;
    }

    public bool ReturnFalseWithRefLocal(List<int> lst, int[] limits)
    {
        ref int limit = ref limits[0];
        foreach (int i in lst)
        {
            if (i > limit)
                return false;
        }
        return true;
    }

    public bool ReturnFalseWithReadonlyRefLocal(List<int> lst, int[] limits)
    {
        ref readonly int limit = ref limits[0];
        foreach (int i in lst)
        {
            if (i > limit)
                return false;
        }
        return true;
    }

    public bool ReturnFalseWithRefLikeLocal(List<int> lst)
    {
        var limits = new RefLikeLimits<int>();
        foreach (int i in lst)
        {
            if (i > limits[0])
                return false;
        }
        return true;
    }

    public bool ReturnFalseWithRefLikeParameter(List<int> lst, RefLikeLimits<int> limits)
    {
        foreach (int i in lst)
        {
            if (i > limits[0])
                return false;
        }
        return true;
    }

    public void AssignFalseWithRefLocal(List<int> lst, ref int x)
    {
        ref var y = ref x;
        var allEven = true;
        foreach (int i in lst)
        {
            if (i % 2 != y)
            {
                allEven = false;
                break;
            }
        }
    }

    // Framework stubs omit the ref modifier on Span<T> and ReadOnlySpan<T>.
    public ref struct RefLikeLimits<T>
    {
        public T this[int index] => throw null;
    }
}
