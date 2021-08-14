using System;

class StackAllocs
{
    unsafe void Fn()
    {
        var arr1 = stackalloc char[] { 'x', 'y' };
        var arr2 = stackalloc char[1] { 'x' };
        var arr3 = new char[] { 'x' };
        var arr4 = stackalloc char[10];
        var arr5 = new char[10];
        var arr6 = stackalloc[] { 1, 2, 3 };
    }
}

class PinnedReference
{
    unsafe void F()
    {
        Span<byte> buffer = stackalloc byte[10];

        Span<int> t = new int[10];
        // This line should compile and generate a call to t.GetPinnableReference()
        // fixed (int * p = t)
        {
        }
    }
}

class UnmanagedConstraint<T> where T : unmanaged
{
}

class EnumConstraint<T> where T : System.Enum
{
}

class DelegateConstraint<T> where T : System.Delegate
{
}

class ExpressionVariables
{
    ExpressionVariables(out int x)
    {
        x = 5;
    }

    public ExpressionVariables() : this(out int x)
    {
        Console.WriteLine($"x is {x}");
    }
}
