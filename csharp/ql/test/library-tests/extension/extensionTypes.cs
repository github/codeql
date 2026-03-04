using System;
using System.Diagnostics.CodeAnalysis;

public static class MyExtensionTypes
{
    extension([NotNull] string s)
    {
        public void M11() { }
    }
    extension(ref readonly int i1)
    {
        public void M21() { }
    }
    extension(in int i2)
    {
        public void M31() { }
    }
    extension(ref int i3)
    {
        public void M41() { }
    }
    extension(string? s)
    {
        public void M51() { }
    }
    extension<T1>([NotNullWhen(true)] T1 t1) where T1 : class
    {
        public void M61<T2>(object o, T2 t2) { }
    }
}
