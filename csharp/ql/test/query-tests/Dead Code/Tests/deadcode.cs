using System;
using System.Collections.Generic;
using System.Reflection;

namespace System.ComponentModel.Composition
{
    class ExportAttribute : Attribute
    {
        public ExportAttribute(Type t) { }
    }
}

interface Interface1
{
}

// GOOD: Class is exported
[System.ComponentModel.Composition.Export(typeof(Interface1))]
sealed class Exported : Interface1
{
}

// BAD: Class is dead
sealed class Dead2
{
}

public class DynamicCallsBase
{
    protected void f1() { }   // GOOD: Live
    void f2() { }   // GOOD: Live
}

public class DynamicCalls : DynamicCallsBase
{
    public void Main()
    {
        GetType().InvokeMember(
          "f1",
          BindingFlags.InvokeMethod | BindingFlags.NonPublic | BindingFlags.Instance,
          null,
          this,
          null
          );

        var x = new DynamicCallsBase();
        x.GetType().InvokeMember(
          "f2",
          BindingFlags.InvokeMethod | BindingFlags.NonPublic | BindingFlags.Instance,
          null,
          x,
          null
          );
    }
}

namespace MainTests
{
    class GoodContainsMain1
    {
        static int Main()
        {
            return 0;
        }
    }

    class GoodContainsMain2
    {
        static void Main()
        {
        }
    }

    class GoodContainsMain3
    {
        static int Main(string[] args)
        {
            return 0;
        }
    }
}

public struct S
{
    C Field; // dead
    class C { } // not dead
}

[Microsoft.VisualStudio.TestTools.UnitTesting.TestClass]
public class VisualStudioTests
{
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestInitialize]
    public void Setup() { } // not dead
}
