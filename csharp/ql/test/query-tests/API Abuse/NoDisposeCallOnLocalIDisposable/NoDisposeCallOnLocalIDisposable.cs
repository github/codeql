using System;
using System.Text;
using System.IO;
using System.IO.Compression;
using System.Xml;
using System.Threading;
using System.Threading.Tasks;

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
        var c1d = new Timer(TimerProc); // $ Alert
        var fs = new FileStream("", FileMode.CreateNew, FileAccess.Write); // $ Alert
        new FileStream("", FileMode.CreateNew, FileAccess.Write).Fluent(); // $ Alert

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

        // GOOD: XmlDocument.Load disposes incoming XmlReader (False positive as this is disposed in library code)
        var xmlReader = XmlReader.Create(new StringReader("xml"), null); // $ Alert
        var xmlDoc = new XmlDocument();
        xmlDoc.Load(xmlReader);

        // GOOD: Disposed automatically.
        using var c2 = new Timer(TimerProc);

        // GOOD: ownership taken via ??
        StringReader source = null;
        using (XmlReader.Create(source ?? new StringReader("xml"), null))
            ;

        // GOOD: Flagging these generates too much noise and there is a general
        // acceptance that Tasks are not disposed.
        // https://devblogs.microsoft.com/pfxteam/do-i-need-to-dispose-of-tasks/
        Task t = new Task(() => { });
        t.Start();
        t.Wait();

        return null;
    }

    // GOOD: Escapes
    IDisposable Create() => new Timer(TimerProc);

    void TimerProc(object obj)
    {
    }

    public void Dispose() { }
}

class Bad
{
    long GetLength(string file)
    {
        var stream = new FileStream(file, FileMode.Open); // $ Alert
        return stream.Length;
    }
}

static class Extensions
{
    public static FileStream Fluent(this FileStream fs) => fs;
}
