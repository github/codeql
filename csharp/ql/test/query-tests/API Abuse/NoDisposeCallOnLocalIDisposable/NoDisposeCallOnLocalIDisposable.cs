using System;
using System.Text;
using System.IO;
using System.IO.Compression;
using System.Xml;
using System.Threading;

class Test
{
    IDisposable d;
    IDisposable dProp { get; set; }
    IDisposable this[int i] { get => null; set { } }

    public IDisposable Method()
    {
        // GOOD: Disposed automatically.
        using (var c1 = new Timer(TimerProc))
        {
        }

        // GOOD: Dispose called in finally
        Timer c1a = null;
        try
        {
            c1a = new Timer(TimerProc);
        }
        finally
        {
            if (c1a != null)
            {
                c1a.Dispose();
            }
        }

        // GOOD: Close called in finally
        FileStream c1b = null;
        try
        {
            c1b = new FileStream("", FileMode.CreateNew, FileAccess.Write);
        }
        finally
        {
            if (c1b != null)
            {
                c1b.Close();
            }
        }

        // BAD: No Dispose call
        var c1d = new Timer(TimerProc);
        var fs = new FileStream("", FileMode.CreateNew, FileAccess.Write);
        new FileStream("", FileMode.CreateNew, FileAccess.Write).Fluent();

        // GOOD: Disposed via wrapper
        fs = new FileStream("", FileMode.CreateNew, FileAccess.Write);
        var z = new GZipStream(fs, CompressionMode.Compress);
        z.Close();

        // GOOD: Escapes
        d = new Timer(TimerProc);
        if (d == null)
            return new Timer(TimerProc);
        fs = new FileStream("", FileMode.CreateNew, FileAccess.Write);
        d = new GZipStream(fs, CompressionMode.Compress);
        dProp = new Timer(TimerProc);
        this[0] = new Timer(TimerProc);
        d = new FileStream("", FileMode.CreateNew, FileAccess.Write).Fluent();

        // GOOD: Passed to another IDisposable
        using (var reader = new StreamReader(new FileStream("", FileMode.Open)))
            ;

        // GOOD: XmlDocument.Load disposes incoming XmlReader (according to CIL)
        var xmlReader = XmlReader.Create(new StringReader("xml"), null);
        var xmlDoc = new XmlDocument();
        xmlDoc.Load(xmlReader);

        // GOOD: Passed to a library. This is only detected in CIL.
        DisposalTests.Class1.Dispose(new StreamWriter("output.txt"));

        // GOOD: Disposed automatically.
        using var c2 = new Timer(TimerProc);

        // GOOD: ownership taken via ??
        StringReader source = null;
        using (XmlReader.Create(source ?? new StringReader("xml"), null))
            ;

        return null;
    }

    // GOOD: Escapes
    IDisposable Create() => new Timer(TimerProc);

    void TimerProc(object obj)
    {
    }

    public void Dispose() { }
}

static class Extensions
{
    public static FileStream Fluent(this FileStream fs) => fs;
}
