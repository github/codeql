using System;

class Disposal : IDisposable
{
    IDisposable field1, field2;

    void Close()
    {
        field1.Dispose();
    }

    void IDisposable.Dispose()
    {
        Close();
    }

    public Disposal(IDisposable p1, object p2, System.IO.TextWriter fs, IDisposable p3)
    {
        field1 = p1;
        if (p2 is IDisposable d)
            d.Dispose();
        fs.Dispose();
    }
}
