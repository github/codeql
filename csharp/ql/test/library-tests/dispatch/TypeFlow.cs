using System;

class TypeFlow
{
    TypeFlow(C1 c1) {
      Field = new C2();
      Run(c1, new C2());
    }

    class C1
    {
        public virtual void Method() { }
    }

    class C2 : C1
    {
        public override void Method() { }
    }

    C1 Field = null;

    C1 Prop { get; set; } = new C2();

    void Run(C1 x, C1 y)
    {
        // Targets: C2.Method()
        Field.Method();

        // Targets: C2.Method()
        Prop.Method();

        // Targets: C1.Method(), C2.Method()
        x.Method();

        if (x is C2)
          // Targets: C2.Method()
          ((C2)x).Method();

        // Targets: C2.Method()
        y.Method();
    }
}
