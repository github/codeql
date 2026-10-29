using System;
using System.Collections.Generic;

class Test : IComparer<string>
{
    // this is really dead
    private string dead = "Actual dead field"; // $ Alert[cs/unused-field]

    private static void Main(string[] args)
    {
        var test = new Test();
        test.Use(test.Ret42);
        // Anonymous types should not have their fields marked as dead
        Console.WriteLine(new { x = 42, y = "LtUaE" });

        dynamic d = 42;
        test.DynamicSig(test);
        test.DynamicallyCalled(d);
        ((dynamic)test).DynamicallyCalledOnDynamicType(d);
    }

    private void Use(Func<int> func)
    {
        Console.WriteLine(func());
    }

    private int Ret42()
    {
        return 42;
    }

    public int Compare(string a, string b)
    {
        return 0;
    }

    int IComparer<string>.Compare(string a, string b)
    {
        // this method is live because it implements an interface
        return PartCompare(a, b);
    }

    private static int PartCompare(string a, string b)
    {
        // this method is live because it is called
        // from a non-dead method
        return 1;
    }

    // this is really dead
    private void ActualDeadMethod() { } // $ Alert[cs/unused-method]

    // this is live
    private void DynamicSig(dynamic d) { }

    // this is live
    private void DynamicallyCalled(int i) { }

    // this is dead
    private void NotDynamicallyCalled(int i) { } // $ Alert[cs/unused-method]

    // this is live
    private void DynamicallyCalledOnDynamicType(int i) { }

    public static int GenericTest()
    {
        return LiveGeneric(0) + new GenericClass<int>().LiveMember();
    }

    // GOOD: This is live
    static int LiveGeneric<V>(V v) { return liveFieldAccessedFromGeneric; }

    // GOOD: This is live
    static int liveFieldAccessedFromGeneric;

    // BAD: This is dead
    void DeadCaller() // $ Alert[cs/unused-method]
    {
        DeadGeneric(0);
        DeadGeneric(0.0);
    }

    // BAD: This is dead (called from dead)
    void DeadGeneric<V>(V a) { } // $ Alert[cs/unused-method]
}

class GenericClass<T>
{
    public int LiveMember()
    {
        return LiveGeneric(0);
    }

    // GOOD: This is live (from LiveMember)
    int LiveGeneric<V>(V v)
    {
        deadWrittenField = 3;
        return liveField;
    }

    // GOOD: This is live (accessed from LiveGeneric)
    int liveField;

    // BAD: These are not live
    void DeadGeneric1() // $ Alert[cs/unused-method]
    {
        DeadGeneric2(0);
        DeadGeneric2(1.0);
    }
    void DeadGeneric2<V>(V v) { } // $ Alert[cs/unused-method]

    // BAD: This is dead (never accessed)
    int deadField; // $ Alert[cs/unused-field]

    // BAD: This is dead (only ever written)
    int deadWrittenField; // $ Alert[cs/unused-field]
}

class MemberInitialization
{
    public interface ITest { }
    class ThisIsLive : ITest { }
    public ITest member = new ThisIsLive(); // GOOD: This is live
}

public class FieldOutParam
{
    // BAD: Only written (by an out param)
    int deadField; // $ Alert[cs/unused-field]

    public void Test()
    {
        Fn1(out deadField);
    }

    void Fn1(out int x)
    {
        x = 0;
    }
}
