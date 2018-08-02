using System; // semmle-extractor-options: /r:System.Dynamic.Runtime.dll /r:System.Linq.Expressions.dll
using System.Collections.Generic;
using System.Reflection;

class Dynamic
{
    class C1
    {
        public C3 Field;
        public void Method() { }
    }

    class C2
    {
        public C4 Field;
        public void Method() { }
    }

    class C3
    {
        public void Method() { }
    }

    class C4
    {
        public void Method() { }
    }

    class C5
    {
        public C1 Field;
        public void Method() { }
    }

    class C6
    {
        public C2 Field;
        public void Method() { }
    }

    public static void Run(dynamic d)
    {
        // Targets: C1.Method(), C2.Method(), C3.Method(), C4.Method(), C5.Method(), C6.Method()
        d.Method();

        // Targets: C1.Method(), C2.Method(), C3.Method(), C4.Method()
        d.Field.Method();

        dynamic dyn = new C1();
        // Targets: C3.Method()
        dyn.Field.Method();

        // Targets: C3.Method(), C4.Method()
        d.Field.Field.Method();

        dyn = new C5();
        // Targets: C3.Method()
        dyn.Field.Field.Method();
    }
}
