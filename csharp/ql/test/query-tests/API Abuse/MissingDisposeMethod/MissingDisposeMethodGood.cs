using System;
using System.IO;

class GoodBase : IDisposable
{
    private FileStream stream1 = new FileStream("a.txt", FileMode.Open);

    public virtual void Dispose()
    {
        stream1.Dispose();
    }
}

class Good : BadBase
{
    private FileStream stream2 = new FileStream("b.txt", FileMode.Open);

    public override void Dispose()
    {
        base.Dispose();
        stream2.Dispose();
    }
}
