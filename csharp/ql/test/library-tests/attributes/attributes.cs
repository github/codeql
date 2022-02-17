using System;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// General Information about an assembly is controlled through the following
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("C# attributes test")]
[assembly: AssemblyDescription("A test of C# attributes")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("Semmle Plc")]
[assembly: AssemblyProduct("Odasa")]
[assembly: AssemblyCopyright("Copyright © Semmle 2018")]
[assembly: AssemblyTrademark("")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible
// to COM components.  If you need to access a type in this assembly from
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("2f70fdd6-14aa-4850-b053-d547adb1f476")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Build and Revision Numbers
// by using the '*' as shown below:
// [assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]

[assembly: Args(0, new object[] { 1, 2, null }, typeof(ArgsAttribute), (E)12, null, Prop = new object[] { 1, typeof(int) })]
[module: Args(0, new object[] { 1, 2, null }, typeof(ArgsAttribute), (E)12, null, Prop = new object[] { 1, typeof(int) })]

[System.AttributeUsage(System.AttributeTargets.All)]
class Foo : Attribute
{
    [Conditional("DEBUG2")]
    static void foo() { }
}

class Bar
{
    int inc([Foo] int x) { return x + 1; }

    [MyAttribute(false)]
    void M1() { }

    [MyAttribute(true, y = "", x = 0)]
    [My2(b: true, j: 1, a: false, X = 42)]
    void M2() { }
}

class MyAttribute : Attribute
{
    public int x;
    public string y { get; set; }
    public MyAttribute(bool b) { }
}

public enum E { A = 42 }

public class ArgsAttribute : Attribute
{
    public object[] Prop { get; set; }
    public ArgsAttribute(int i, object o, Type t, E e, int[] arr) { }
}

[Args(42, null, typeof(X), E.A, new int[] { 1, 2, 3 }, Prop = new object[] { 1, typeof(int) })]
public class X
{
    [Args(42 + 0, new int[] { 1, 2, 3 }, null, (E)12, null, Prop = new object[] { 1, typeof(int) })]
    [return: Args(42 + 0, new int[] { 1, 2, 3 }, null, (E)12, null, Prop = new object[] { 1, typeof(int) })]
    int SomeMethod() { return 1; }
}

class My2Attribute : Attribute
{
    public int X { get; set; }
    public My2Attribute(bool a, bool b, int i = 12, int j = 13) { }
}

class My3Attribute : Attribute
{
    public My3Attribute(int x) { }
}

[My3Attribute(1)]
[return: My3Attribute(2)]
delegate int My1Delegate(string message);

[return: My3Attribute(3)]
[type: My3Attribute(4)]
delegate string My2Delegate(string message);

public class MyAttributeUsage
{
    [My3Attribute(5)]
    [return: My3Attribute(6)]
    public static int operator +(MyAttributeUsage a, MyAttributeUsage b) => 0;

    public int this[int x]
    {
        [My3Attribute(7)]
        [return: My3Attribute(8)]
        get { return x + 1; }

        [method: My3Attribute(9)]
        [param: My3Attribute(10)]
        set { return; }
    }

    private int p;
    public int Prop1
    {
        [method: My3Attribute(11)]
        [return: My3Attribute(12)]
        get { return p; }

        [My3Attribute(13)]
        [param: My3Attribute(14)]
        set { p = value; }
    }
}