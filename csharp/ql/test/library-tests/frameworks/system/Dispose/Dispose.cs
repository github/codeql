using System;
using System.ComponentModel;

class NoDispose { }

class Dispose1 : IDisposable
{
    public void Dispose() { }
}

class Dispose2<T> : IDisposable
{
    public virtual void Dispose(bool disposing) { }
    public void Dispose() { Dispose(true); }
}

class Dispose3 : Dispose2<int>
{
    public override void Dispose(bool disposing) { }
}

class Dispose4 : Dispose2<int> { }

class Dispose5 : Component
{
    protected override void Dispose(bool disposing) { }
}

struct NoDisposeStruct { }

struct Dispose1Struct : IDisposable
{
    public void Dispose() { }
}

// semmle-extractor-options: /r:System.ComponentModel.Primitives.dll
