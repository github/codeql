using System;

class A
{
    public void Lock()
    {
        object synchronizedAlways = null;
        lock (synchronizedAlways) // BAD (always)
        {
            synchronizedAlways.GetHashCode(); // GOOD
        }
    }

    public void ArrayAssignTest()
    {
        int[] arrayNull = null;
        arrayNull[0] = 10; // BAD (always)

        int[] arrayOk;
        arrayOk = new int[10];
        arrayOk[0] = 42; // GOOD
    }

    public void Access()
    {
        int[] arrayAccess = null;
        string[] fieldAccess = null;
        object methodAccess = null;
        object methodCall = null;

        Console.WriteLine(arrayAccess[1]); // BAD (always)
        Console.WriteLine(fieldAccess.Length); // BAD (always)
        Func<String> tmp = methodAccess.ToString; // BAD (always)
        Console.WriteLine(methodCall.ToString()); // BAD (always)

        Console.WriteLine(arrayAccess[1]); // GOOD
        Console.WriteLine(fieldAccess.Length); // GOOD
        tmp = methodAccess.ToString; // GOOD
        Console.WriteLine(methodCall.ToString()); // GOOD
    }

    public void OutOrRef()
    {
        object varOut = null;
        TestMethod1(out varOut);
        varOut.ToString(); // GOOD

        object varRef = null;
        TestMethod2(ref varRef);
        varRef.ToString(); // BAD (always)

        varRef = null;
        TestMethod3(ref varRef);
        varRef.ToString(); // GOOD
    }

    public void LambdaTest()
    {
        string actual = null;

        MyDelegate fun = e => x => actual = e;

        fun("hello")("world");
        Console.WriteLine(actual.Length); // GOOD
    }

    static void TestMethod1(out object num)
    {
        num = 42;
    }

    static void TestMethod2(ref object num)
    {
    }

    static void TestMethod3(ref object num)
    {
        num = 42;
    }

    public delegate MyDelegate2 MyDelegate(string e);
    public delegate void MyDelegate2(string e);
}
