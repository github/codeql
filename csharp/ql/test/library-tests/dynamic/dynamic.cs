using System;
using System.Collections.Generic;

class DynamicTest
{
    private DynamicTest(int x) { }

    static void Main(string[] args)
    {
        var dt = new DynamicTest(0);
        var array = new int[] { 42 };
        Action<int> action = x => { };
        dynamic d = 0;

        // DynamicObjectCreation
        new DynamicTest(d);
        new DynamicTest(d) { Field = d };
        new KeyValuePair<string, dynamic>("", d);
        new System.Collections.Generic.KeyValuePair<string, dynamic>("", d);

        // ObjectCreation
        new DynamicTest(0);
        new DynamicTest(0) { Field = d };

        // DynamicMethodCall
        d.Bar("");
        Foo(d);

        // MethodCall
        dt.Bar("");
        Foo(0);

        // DynamicOperatorCall
        d = 0;
        d = -d;
        d = d + d;
        d += d;

        // OperatorCall
        var i = 0;
        i = -i;
        i = i + i;
        i += i;
        i++;

        // DynamicMutatorOperatorCall
        d++;

        // MutatorOperatorCall
        i++;

        // DynamicMemberAccess
        d.Field = 0;
        d.Prop = d.Prop;

        // MemberAccess
        dt.Field = 0;
        dt.Prop = dt.Prop;

        // DynamicElementAccess
        d = array;
        d[0] = d[0];
        d = d?[0];

        // ElementAccess
        d = 0;
        dt[0] = dt[d];
        d = dt?[0];
        array[0] = array[d];
        d = array?[0];

        // DelegateCall
        action(3);
        d = action;
        d(42);
    }

    private static void Foo(int x) { }
    private static void Foo(string x) { }

    public void Bar(string x) { }

    public static DynamicTest operator ++(DynamicTest dt)
    {
        return dt;
    }

    public int Field;

    public int Prop { get; set; }

    public int this[int x] { get { return x; } set { } }
}
