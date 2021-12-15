using System;
using System.Collections.Generic;
using System.Reflection;

public delegate void EventHandler<T>();

public class ViableCallable
{
    public void Run<T1, T2, T3>(C1<T1, T2> x1, C1<T1[], T2> x2, dynamic dyn, T3 t3)
    {
        // Viable callables: {C2,C3,C4,C5,C6,C7}.M()
        x1.M(default(T1), 8);
        // Viable callables: {C2,C3,C4,C5,C6,C7}.{get_Prop(),set_Prop()}
        x1.Prop = x1.Prop;
        // Viable callables: {C2,C3,C4,C5,C6,C7}.{get_Item(),set_Item()}
        x1[default(T2)] = x1[default(T2)];
        // Viable callables: {C2,C3,C4,C5,C6,C7}.{add_Event(),remove_Event()}
        x1.Event += () => { };
        x1.Event -= () => { };

        // Viable callables: {C4,C6}.M() (not C7.M(), as C7<T[]> is not constructed for any T)
        x2.M(new T1[0], false);
        // Viable callables: {C4,C6}.{get_Prop(),set_Prop()}
        x2.Prop = x2.Prop;
        // Viable callables: {C4,C6}.{get_Item(),set_Item()}
        x2[default(T2)] = x2[default(T2)];
        // Viable callables: {C4,C6}.{add_Event(),remove_Event()}
        x2.Event += () => { };
        x2.Event -= () => { };

        // Viable callables: {C2,C6}.M()
        C1<string, int> x3 = Mock<C1<string, int>>();
        x3.M("abc", 42);
        // Viable callables: {C2,C6}.{get_Prop(),set_Prop()}
        x3.Prop = x3.Prop;
        // Viable callables: {C2,C6}.{get_Item(),set_Item()}
        x3[0] = x3[0];
        // Viable callables: {C2,C6}.{add_Event(),remove_Event()}
        x3.Event += () => { };
        x3.Event -= () => { };

        // Viable callables: {C2,C3,C6}.M()
        C1<string, decimal> x4 = Mock<C1<string, decimal>>();
        x4.M("abc", 42d);
        // Viable callables: {C2,C3,C6}.{get_Prop(),set_Prop()}
        x4.Prop = x4.Prop;
        // Viable callables: {C2,C3,C6}.{get_Item(),set_Item()}
        x4[0M] = x4[0M];
        // Viable callables: {C2,C3,C6}.{add_Event(),remove_Event()}
        x4.Event += () => { };
        x4.Event -= () => { };

        // Viable callables: {C4,C6}.M()
        C1<int[], bool> x5 = Mock<C1<int[], bool>>();
        x5.M<object>(new int[] { 42 }, null);
        // Viable callables: {C4,C6}.{get_Prop(),set_Prop()}
        x5.Prop = x5.Prop;
        // Viable callables: {C4,C6}.{get_Item(),set_Item()}
        x5[false] = x5[false];
        // Viable callables: {C4,C6}.{add_Event(),remove_Event()}
        x5.Event += () => { };
        x5.Event -= () => { };

        // Viable callables: {C2,C5,C6}.M()
        C1<string, bool> x6 = Mock<C1<string, bool>>();
        x6.M<object>("", null);
        // Viable callables: {C2,C5,C6}.{get_Prop(),set_Prop()}
        x6.Prop = x6.Prop;
        // Viable callables: {C2,C5,C6}.{get_Item(),set_Item()}
        x6[false] = x6[false];
        // Viable callables: {C2,C5,C6}.{add_Event(),remove_Event()}
        x6.Event += () => { };
        x6.Event -= () => { };

        // Viable callables: C6.M()
        C1<T1, bool> x7 = new C6<T1, bool>();
        x7.M(default(T1), "");
        // Viable callables: C6.{get_Prop(),set_Prop()}
        x7.Prop = x7.Prop;
        // Viable callables: C6.{get_Item(),set_Item()}
        x7[false] = x7[false];
        // Viable callables: C6.{add_Event(),remove_Event()}
        x7.Event += () => { };
        x7.Event -= () => { };

        // Viable callables: {C8,C9}.M()
        dynamic d = Mock<C8>();
        d.M(Mock<IEnumerable<C4<string>>>());
        // Viable callables: {C8,C9}.{get_Prop(),set_Prop()}
        d.Prop1 = d.Prop1;
        // Viable callables: {C8,C9}.{get_Item(),set_Item()}
        d[0] = d[0];

        // Viable callables: (none)
        d.M(Mock<IEnumerable<C4<int>>>());

        // Viable callables: C5.M()
        d = 42;
        C5.M(d);
        // Viable callables: C5.set_Prop2()
        d = "";
        C5.Prop2 = d;
        // Viable callables: C5.{add_Event(),remove_Event()}
        d = (EventHandler<string>)(() => { });
        C5.Event2 += d;
        C5.Event2 -= d;

        // Viable callables: (none)
        d = "";
        C5.M(d);
        // Viable callables: (none)
        d = 0;
        C5.Prop2 = d;
        // Viable callables: (none)
        C5.Event2 += d;
        C5.Event2 -= d;

        // Viable callables: C8.M2()
        d = new decimal[] { 0M };
        C8.M2<decimal>(d);

        // Viable callables: C8.M2()
        d = new string[] { "" };
        C8.M2<string>(d);

        // Viable callables: (none)
        d = "";
        C8.M2<object>(d);

        // Viable callables: C6.M()
        d = new C6<T1, byte>();
        d.M(default(T1), "");
        // Viable callables: C6.{get_Prop(),set_Prop()}
        d.Prop = d.Prop;
        // Viable callables: C6.{get_Item(),set_Item()}
        d[(byte)0] = d[(byte)0];
        // Viable callables: C6.{add_Event(),remove_Event()}
        d.Event += (EventHandler<string>)(() => { });
        d.Event -= (EventHandler<string>)(() => { });

        // Viable callables: C8.M3(), C9.M3()
        d = Mock<C8>();
        d.M3();
        d.M3(0);
        d.M3(0, 0.0);

        // Viable callables: {C8,C9,C10}.M3()
        dyn.M3();
        dyn.M3(0);
        dyn.M3(0, 0.0);
        // Viable callables: {C8,C9,C10}.{get_Prop1(),set_Prop1()}
        dyn.Prop1 = dyn.Prop1;
        // Viable callables: {C2,C3,C6,C7,C8,C9,C10}.{get_Item(),set_Item()}
        dyn[0] = dyn[0];
        // Viable callables: {C2,C3,C5,C6,C7,C8,C9}.{add_Event(),remove_Event()}
        dyn.Event += (EventHandler<string>)(() => { });
        dyn.Event -= (EventHandler<string>)(() => { });

        // Viable callables: C8.M4()
        dyn.M4(0, Mock<IList<string>>());
        dyn.M4(0, new string[] { "" });

        // Viable callables: C10.set_Prop1()
        dyn.Prop1 = false;

        // Viable callables: (none)
        dyn.M4(-1, new string[] { "" });
        dyn.M4(0, new int[] { 0 });

        // Viable callables: (none)
        dyn.Prop1 = 0;

        // Viable callables: {C2,C6}.{get_Item(),set_Item()}
        dyn[""] = dyn[""];

        // Operator calls using dynamic types: all target int operators
        d = 0;
        d = d + 1;
        d = 0;
        d = 1 - d;
        d = 0;
        d = d + t3; // mixed with a type parameter

        // Operator calls using reflection: targets C10 addition operator
        var c = new C10();
        typeof(C10).InvokeMember("op_Addition", BindingFlags.Static | BindingFlags.Public | BindingFlags.InvokeMethod, null, null, new object[] { c, c });

        // Property call using reflection: targets C10 property getter/setter
        typeof(C10).InvokeMember("get_Prop3", BindingFlags.Static | BindingFlags.Public | BindingFlags.InvokeMethod, null, null, new object[0]);
        typeof(C10).InvokeMember("set_Prop3", BindingFlags.Static | BindingFlags.Public | BindingFlags.InvokeMethod, null, null, new object[] { "" });

        // Indexer call using reflection: targets C10 indexer getter/setter
        typeof(C10).InvokeMember("get_Item", BindingFlags.Instance | BindingFlags.Public | BindingFlags.InvokeMethod, null, c, new object[] { 0 });
        typeof(C10).InvokeMember("set_Item", BindingFlags.Instance | BindingFlags.Public | BindingFlags.InvokeMethod, null, c, new object[] { 0, true });

        // Event handler call using reflection: targets C10 event adder/remover
        EventHandler<bool> e = () => { };
        typeof(C10).InvokeMember("add_Event", BindingFlags.Instance | BindingFlags.Public | BindingFlags.InvokeMethod, null, c, new object[] { e });
        typeof(C10).InvokeMember("remove_Event", BindingFlags.Instance | BindingFlags.Public | BindingFlags.InvokeMethod, null, c, new object[] { e });
    }

    public static T Mock<T>() { throw new Exception(); }

    void CreateTypeInstance()
    {
        new C2<bool>();
        new C2<int>();
        new C2<decimal>();
        new C4<int>();
        new C6<string, bool>();
        new C6<string, int>();
        new C6<string, decimal>();
        new C6<int[], bool>();
        new C7<bool>();
        // Need to reference built-in operators for them to be extracted
        if (2 + 3 - 1 > 0) ;
        // No construction of C8/C9; reflection/dynamic calls should not rely on existence of types
    }
}

public abstract class C1<T1, T2>
{
    public abstract T2 M<T3>(T1 x, T3 y);

    public abstract T1 Prop { get; set; }

    public abstract T1 this[T2 x] { get; set; }

    public abstract event EventHandler<T1> Event;

    public void Run(T1 x)
    {
        // Viable callables: C2.M(), C3.M(), C4.M(), C5.M(), C6.M(), C7.M()
        M(x, 8);
    }
}

public class C2<T> : C1<string, T>
{
    public override T M<T3>(string x, T3 y) { throw new Exception(); }
    public override string Prop { get; set; }
    public override string this[T x] { get { throw new Exception(); } set { throw new Exception(); } }
    public override event EventHandler<string> Event { add { } remove { } }
}

public class C3 : C1<string, decimal>
{
    public override decimal M<T3>(string x, T3 y) { throw new Exception(); }
    public override string Prop { get; set; }
    public override string this[decimal x] { get { throw new Exception(); } set { throw new Exception(); } }
    public override event EventHandler<string> Event { add { } remove { } }
}

public class C4<T> : C1<T[], bool>
{
    public override bool M<T3>(T[] x, T3 y) { throw new Exception(); }
    public override T[] Prop { get; set; }
    public override T[] this[bool x] { get { throw new Exception(); } set { throw new Exception(); } }
    public override event EventHandler<T[]> Event { add { } remove { } }
}

public class C5 : C1<string, bool>
{
    public override bool M<T3>(string x, T3 y) { throw new Exception(); }
    public static void M(int x) { }
    public override string Prop { get; set; }
    public static string Prop2 { get; set; }
    public override string this[bool x] { get { throw new Exception(); } set { throw new Exception(); } }
    public override event EventHandler<string> Event { add { } remove { } }
    public static event EventHandler<string> Event2 { add { } remove { } }
}

public class C6<T1, T2> : C1<T1, T2>
{
    public override T2 M<T3>(T1 x, T3 y) { throw new Exception(); }
    public override T1 Prop { get; set; }
    public override T1 this[T2 x] { get { throw new Exception(); } set { throw new Exception(); } }
    public override event EventHandler<T1> Event { add { } remove { } }

    public void Run(T1 x)
    {
        // Viable callables: C6.M(), C7.M()
        M(x, 8);

        // Viable callables: C6.M(), C7.M()
        this.M(x, 8);
    }
}

public class C7<T1> : C6<T1, byte>
{
    public override byte M<T3>(T1 x, T3 y) { throw new Exception(); }
    public override T1 Prop { get; set; }
    public override T1 this[byte x] { get { throw new Exception(); } set { throw new Exception(); } }
    public override event EventHandler<T1> Event { add { } remove { } }

    public void Run(T1 x)
    {
        // Viable callables: C7.M()
        M(x, 8);

        // Viable callables: C7.M()
        this.M(x, 8);

        // Viable callables: C6.M()
        base.M(x, 8);
    }
}

public class C8
{
    public virtual void M(IEnumerable<C1<string[], bool>> x) { }
    public static void M2<T>(T[] x) { }
    public void M3(params double[] x) { }
    public void M4(byte b, IEnumerable<string> s) { }
    public virtual string Prop1 { get; set; }
    public static string Prop2 { get; set; }
    public string Prop3 { get; set; }
    public virtual string this[int x] { get { throw new Exception(); } set { throw new Exception(); } }
    public virtual event EventHandler<string> Event { add { } remove { } }
}

public class C9<T> : C8
{
    public override void M(IEnumerable<C1<string[], bool>> x) { }
    public void M3(params T[] x) { }
    public override string Prop1 { get; set; }
    public string Prop3 { get; set; }
    public override string this[int x] { get { throw new Exception(); } set { throw new Exception(); } }
    public override event EventHandler<string> Event { add { } remove { } }
}

public class C10
{
    public void M3(params double[] x) { }
    public static C10 operator +(C10 x, C10 y) { return x; }
    public bool Prop1 { get; set; }
    public static string Prop3 { get; set; }
    public bool this[int x] { get { return false; } set { return; } }
    public event EventHandler<bool> Event { add { } remove { } }
}

public class C11
{
    void M(dynamic d) { }

    public void Run()
    {
        dynamic d = this;
        int x = 0;
        x += 42;
        // Viable callables: C11.M()
        d.M(x);
        // Viable callables: C11.C11()
        new C11(d);
        d = 0;
        // Viable callables: (none)
        new C11(d);
    }

    C11(C11 x) { }
}

public class C12
{
    interface I
    {
        void M();
    }

    class C13 : I { public void M() { } }

    class C14 : I { public void M() { } }

    void Run<T1>(T1 x) where T1 : I
    {
        // Viable callables: C13.M()
        x.M();
    }

    void Run2<T2>(T2 x) where T2 : I
    {
        Run(x);
    }

    void Run3()
    {
        Run2(new C13());
    }
}

public class C15
{
    interface I<T1> { void M<T2>(); }

    class A1 { public virtual void M<T1>() { } }

    class A2 : A1, I<int> { }

    class A3 : A2 { new public void M<T1>() { } }

    class A4 : A2, I<int> { new public virtual void M<T1>() { } }

    class A5 : A4 { public override void M<T1>() { } }

    class A6 : A1 { public override void M<T1>() { } }

    void Run(I<int> i)
    {
        // Viable callables: {A1,A4,A5}.M()
        i.M<int>();

        i = new A3();
        // Viable callables: A1.M()
        i.M<bool>();

        i = new A4();
        // Viable callables: A4.M()
        i.M<string>();

        i = ViableCallable.Mock<A4>();
        // Viable callables: {A4,A5}.M()
        i.M<string>();
    }
}

abstract class C16<T1, T2>
{
    public virtual T2 M1(T1 x) => throw null;
    public virtual T M2<T>(Func<T> x) => x();
}

class C17 : C16<string, int>
{
    void M1(int i)
    {
        // Viable callables: C16<string, int>.M1()
        this.M1("");

        // Viable callables: C17.M2<int>()
        this.M2(() => i);
    }

    public override T M2<T>(Func<T> x) => x();

    void M3<T>(T t, string s) where T : C17
    {
        // Viable callable: C17.M2()
        t.M2(() => s);
    }

    void M4<T>(C16<T, int> c) where T : struct
    {
        // Viable callable: C16.M2() [also reports C17.M2(); false positive]
        c.M2(() => default(T));
    }

    void M5<T>(C16<T, int> c) where T : class
    {
        // Viable callables: {C16,C17}.M1()
        c.M2(() => default(T));
    }
}

interface I2
{
    void M1();
    void M2() => throw null;
}

class C18 : I2
{
    public void M1() { }

    void Run(I2 i)
    {
        // Viable callables: C18.M1()
        i.M1();

        // Viable callables: I2.M2()
        i.M2();
    }
}