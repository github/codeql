using System;
using System.Collections.Generic;

public static class MyExtensions
{
    extension(string s)
    {
        public bool Prop1 => s.Length > 0;
        public bool Prop2 { get { return true; } set { } }
        public static bool StaticProp1 { get { return false; } }
        public bool M1() => s is not null;
        public string M2(string other) { return s + other; }
        public static int StaticM1() { return 0; }
        public static int StaticM2(string x) { return x.Length; }
        public static string operator *(int a, string b) { return ""; }
        public T StringGenericM1<T>(T t, object o) { return t; }
    }

    extension(object)
    {
        public static int StaticObjectM1() { return 0; }
        public static int StaticObjectM2(string s) { return s.Length; }
        public static bool StaticProp => true;
    }

    extension<T>(T t) where T : class
    {
        public bool GenericProp1 => t is not null;
        public bool GenericProp2 { get { return true; } set { } }
        public bool GenericM1() => t is not null;
        public void GenericM2<S>(S other) { }
        public void GenericStaticM1() { }
        public static void GenericStaticM2<S>(S other) { }
        public static T operator +(T a, T b) { return null; }
    }
}

public static class ClassicExtensions
{
    public static bool M3(this string s) => s is not null;
}

public class C
{
    public static void CallingExtensions()
    {
        var s = "Hello World.";

        // Calling the extensions properties
        var x11 = s.Prop1;
        var x12 = s.Prop2;
        s.Prop2 = true;
        var x13 = string.StaticProp1;
        var x14 = object.StaticProp;

        // Calling the extensions methods.
        var x21 = s.M1();
        var x22 = s.M2("!!!");
        var x23 = string.StaticM1();
        var x24 = string.StaticM2(s);
        var x25 = object.StaticObjectM1();
        var x26 = object.StaticObjectM2(s);

        // Calling the extension operator.
        var x30 = 3 * s;

        // Calling the classic extension method.
        var y = s.M3();

        // Calling the compiler generated static extension methods.
        MyExtensions.M1(s);
        MyExtensions.M2(s, "!!!");
        MyExtensions.StaticM1();
        MyExtensions.StaticM2(s);
        MyExtensions.StaticObjectM1();
        MyExtensions.StaticObjectM2(s);

        // Calling the compiler generated operator method.
        MyExtensions.op_Multiply(3, s);

        // Calling the compiler generated methods used by the extension property accessors.
        MyExtensions.get_Prop1(s);
        MyExtensions.get_Prop2(s);
        MyExtensions.set_Prop2(s, false);
        MyExtensions.get_StaticProp();
    }

    public static void CallingGenericExtensions()
    {
        var s = "Hello Generic World.";
        var o = new object();

        // Calling generic extension method
        o.GenericM1();
        s.GenericM1();

        // Calling the compiler generated static extension methods.
        MyExtensions.GenericM1(o);
        MyExtensions.GenericM1(s);

        o.GenericM2(42);
        MyExtensions.GenericM2(o, 42);

        s.StringGenericM1<int>(7, new object());
        MyExtensions.StringGenericM1<string>(s, "test", new object());
    }
}
