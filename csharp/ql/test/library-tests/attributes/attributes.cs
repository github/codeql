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
    void M2() { }
}

class MyAttribute : Attribute
{
    public int x;
    public string y { get; set; }
    public MyAttribute(bool b) { }
}
