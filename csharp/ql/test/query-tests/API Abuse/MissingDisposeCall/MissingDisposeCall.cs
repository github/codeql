using System;
using System.Web.UI;
using System.ComponentModel;

namespace System.Web.UI
{
    class Page : IDisposable
    {
        public void Dispose() { }
    }

    class Control : IDisposable
    {
        public void Dispose() { }
    }
}

class C1 : IDisposable
{
    C1 Field1; // GOOD
    C1 Field2; // BAD

    public virtual void Dispose() // $ Alert
    {
        Field1.Dispose();
    }
}

class C2 : C1
{
    C1 Field1; // GOOD
    C1 Field2; // BAD

    public override void Dispose() // $ Alert
    {
        base.Dispose();
        Field1.Dispose();
    }
}

class C4 : IDisposable
{
    public void Dispose() { Dispose(true); }
    public virtual void Dispose(bool disposing) { }
}

class C5 : C4
{
    C1 Field1; // GOOD
    C1 Field2; // BAD

    public override void Dispose(bool disposing) // $ Alert
    {
        base.Dispose(disposing);
        if (disposing)
        {
            Field1.Dispose();
        }
    }
}

class C6 : Component
{
    C1 Field1; // GOOD
    C1 Field2; // BAD

    protected override void Dispose(bool disposing) // $ Alert
    {
        base.Dispose(disposing);
        if (disposing)
        {
            Field1.Dispose();
        }
    }
}
