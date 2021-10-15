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
    C1 Field; // GOOD

    public virtual void Dispose()
    {
        Field.Dispose();
    }
}

class C2 : C1
{
    C2 Field; // BAD
}

class C3 : C1
{
    C2 Field; // GOOD

    public override void Dispose()
    {
        base.Dispose();
        Field.Dispose();
    }
}

class WebPage : Page
{
    C1 Field1; // BAD
    Control Field2; // GOOD
}

class WebControl : Control
{
    C1 Field1; // BAD
    Control Field2; // GOOD
}

class C4 : IDisposable
{
    public void Dispose() { Dispose(true); }
    public virtual void Dispose(bool disposing) { }
}

class C5 : C4
{
    C2 Field; // GOOD

    public override void Dispose(bool disposing)
    {
        base.Dispose(disposing);
        if (disposing)
        {
            Field.Dispose();
        }
    }
}

class C6 : C4
{
    C2 Field; // BAD
}

class C7 : Component
{
    C2 Field; // BAD
}

class C8 : Component
{
    C2 Field; // GOOD

    protected override void Dispose(bool disposing)
    {
        base.Dispose(disposing);
        if (disposing)
        {
            Field.Dispose();
        }
    }
}

class C9 : C1
{
    C2 Field; // BAD

    public virtual void Dispose()
    { // Typo: virtual instead of override
        base.Dispose();
        Field.Dispose();
    }
}
