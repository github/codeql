using System;
class HashSet<T>
{
    public bool Add(T t)
    {
        return true;
    }
}

class C1
{
    static void Main(string[] args)
    {
        var intHashSet = new HashSet<int>();
        var stringHashSet = new HashSet<string>();

        // GOOD
        var ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);
        ret = intHashSet.Add(42);

        // BAD:
        stringHashSet.Add("42");
    }
}

class StringBuilder
{
    public StringBuilder Append(string s) { return this; }
}

class C2
{
    static void Main(string[] args)
    {
        var sb = new StringBuilder();

        // GOOD: chaining
        sb.Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("")
        .Append("");
    }
}

namespace System.IO
{
    public abstract class Stream
    {
        public abstract int Read(byte[] buffer, int offset, int count);
        public virtual int ReadByte() { return 0; }
    }

    public class MemoryStream : Stream
    {
        public override int Read(byte[] buffer, int offset, int count) { return 0; }
    }
}

class C3
{
    static void Main(string[] args)
    {
        var s = new System.IO.MemoryStream();
        int ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        ret = s.Read(null, 0, 0);
        s.Read(null, 0, 0); // always check
        s.ReadByte(); // always check
    }
}

class C4
{
    static void M()
    {
        var ret1 = M1<int>();
        ret1 = M1<int>();
        ret1 = M1<int>();
        ret1 = M1<int>();
        ret1 = M1<int>();
        ret1 = M1<int>();
        ret1 = M1<int>();
        ret1 = M1<int>();
        ret1 = M1<int>();
        M1<int>(); // BAD
        M1<string>(); // GOOD

        var ret2 = M2<int>();
        ret2 = M2<bool>();
        ret2 = M2<string>();
        ret2 = M2<char>();
        ret2 = M2<byte>();
        ret2 = M2<sbyte>();
        ret2 = M2<ulong>();
        ret2 = M2<ushort>();
        ret2 = M2<double>();
        ret2 = M2<int>();
        ret2 = M2<bool>();
        ret2 = M2<string>();
        ret2 = M2<char>();
        ret2 = M2<byte>();
        ret2 = M2<sbyte>();
        ret2 = M2<ulong>();
        ret2 = M2<ushort>();
        ret2 = M2<double>();
        M2<decimal>(); // BAD

        var ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        ret3 = M3<C6>(null);
        M3<C5>(null); // GOOD
        M3<C6>(null); // BAD
        M3<C7>(null); // GOOD
    }

    static T M1<T>() { return default(T); }

    static bool M2<T>() { return false; }

    static T M3<T>(T x) { return x; }

    static void M2Void()
    {
        M2<int>(); // GOOD: void wrapper
    }

    class C5 { }
    class C6 : C5 { }
    class C7 : C6 { }
}

class C5
{
    int M1() => 0;

    void M2()
    {
        // GOOD
        M1();
        Action a = () => M1();
        a = () => M1();
        a = () => M1();
        a = () => M1();
        a = () => M1();
        a = () => M1();
        a = () => M1();
        a = () => M1();
        a = () => M1();
    }
}
