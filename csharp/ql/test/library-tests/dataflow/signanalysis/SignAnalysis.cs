using System;
using System.Linq;
using System.Diagnostics;

class SignAnalysis
{
    static int GetRandomValue() { return (new System.Random()).Next(0, 1000) - 500; }

    int RandomValue { get => GetRandomValue(); }

    int random = GetRandomValue();

    int SsaSources(int p, int[] values)
    {
        var v = GetRandomValue();
        if (v < 0)
        {
            return v;
        }

        v = RandomValue;
        if (v < 0)
        {
            return v;
        }

        v = p;
        if (v < 0)
        {
            return v;
        }

        v = random;
        if (v < 0)
        {
            return v;
        }

        v = values[0];
        if (v < 0)
        {
            return v;
        }

        int x = values[1];
        v = x;
        if (v < 0)
        {
            return v;
        }

        return 0;
    }

    void Operations(int i, int j, bool b)
    {
        if (i < 0 && j < 0)
        {
            var x = i + j;
            System.Console.WriteLine(x); // strictly neg
            x = i * j;
            System.Console.WriteLine(x); // strictly pos
            x = i / j;
            System.Console.WriteLine(x); // pos
            x = i - j;
            System.Console.WriteLine(x); // no clue
            x = i % j;
            System.Console.WriteLine(x); // neg
            x = i++;
            System.Console.WriteLine(x); // strictly neg
            x = i--;
            System.Console.WriteLine(x); // neg
            x = -i;
            System.Console.WriteLine(x); // strictly pos
            x = +i;
            System.Console.WriteLine(x); // strictly neg
            var l = (long)i;
            System.Console.WriteLine(l); // strictly neg

            x = i;
            x += i;
            System.Console.WriteLine(x); // strictly neg
        }

        if (i < 0 && j > 0)
        {
            var x = i + j;
            System.Console.WriteLine(x);
            x = i * j;
            System.Console.WriteLine(x); // strictly neg
            x = i / j;
            System.Console.WriteLine(x); // neg
            x = i - j;
            System.Console.WriteLine(x); // strictly neg
            x = i % j;
            System.Console.WriteLine(x); // neg
            x = b ? i : j;
            System.Console.WriteLine(x); // any (except 0)
        }
    }

    void NumericalTypes()
    {
        var f = 4.2f;
        System.Console.WriteLine(f);
        var d = 4.2;
        System.Console.WriteLine(d);
        var de = 4.2m;
        System.Console.WriteLine(de);
        var c = 'a';
        System.Console.WriteLine(c);
    }

    int f0;

    int f1;

    void Field0()
    {
        f0++;
        System.Console.WriteLine(f0); // strictly positive
        f0 = 0;
    }

    void Field1()
    {
        f1++;
        System.Console.WriteLine(f1); // no clue
        f1 = -10;
    }

    void Field2()
    {
        System.Console.WriteLine(f1); // no clue
    }

    void Ctor()
    {
        var i = new Int32(); // const 0 value
        i++;
        System.Console.WriteLine(i); // strictly pos
    }

    int Guards(int x, int y)
    {
        if (x < 0)
        {
            return x; // strictly negative
        }

        if (y == 1)
        {
            return y; // strictly positive
        }

        if (y is -1)
        {
            return y; // strictly negative
        }

        if (x < y)
        {
            return y; // strictly positive
        }

        var b = y == 1;
        if (b)
        {
            return y; // strictly positive
        }

        return 0;
    }

    void Inconsistent()
    {
        var i = 1;
        if (i < 0)
        {
            System.Console.WriteLine(i); // reported as strictly pos, although unreachable
        }
    }

    void SpecialValues(int[] ints)
    {
        System.Console.WriteLine(ints.Length); // positive
        ints = new int[] { 1, 2, 3 };
        System.Console.WriteLine(ints.Length); // 3, so strictly positive
        System.Console.WriteLine(ints.Count()); // positive
        System.Console.WriteLine(ints.Count(i => i > 1)); // positive

        var s = "abc";
        System.Console.WriteLine(s.Length); // positive, could be strictly positive

        var enumerable = Enumerable.Empty<int>();
        System.Console.WriteLine(enumerable.Count()); // positive

        var i = new int[,] { { 1, 1 }, { 1, 2 }, { 1, 3 } };
        System.Console.WriteLine(i.Length); // 6, so strictly positive
    }

    void Phi1(int i)
    {
        if (i > 0)
        {
            System.Console.WriteLine(i); // strictly positive
        }
        else
        {
            System.Console.WriteLine(i); // negative
        }
        System.Console.WriteLine(i); // any
    }

    void Phi2(int i)
    {
        if (i > 0)
        {
            System.Console.WriteLine(i); // strictly positive
        }
        else
        {
            if (i < 0) // negative
            {
                System.Console.WriteLine(i); // strictly negative
                return;
            }
        }
        System.Console.WriteLine(i); // positive, not found
    }

    void Phi3(int i)
    {
        if (i > 0)
        {
            System.Console.WriteLine(i); // strictly positive
        }
        else
        {
            if (i < 0) // negative
            {
                System.Console.WriteLine(i); // strictly negative
            }
            else
            {
                System.Console.WriteLine(i); // zero, nothing is reported
            }
        }
    }

    void Loop(int i, int j, int k)
    {
        if (i > 0)
        {
            while (i >= 0) // any
            {
                i--; // positive
                System.Console.WriteLine(i); // any
            }
            System.Console.WriteLine(i); // strictly neg
        }

        if (j > 0)
        {
            while (j > 0)
            {
                j--; // strictly pos
                System.Console.WriteLine(j); // positive
            }
            System.Console.WriteLine(j); // reported negative, can only be 0
        }

        if (k > 0)
        {
            while (k > 0)
            {
                k--; // strictly pos
                System.Console.WriteLine(k); // positive

                if (k == 5) // positive
                {
                    break;
                }
            }
            System.Console.WriteLine(k); // any
        }
    }

    void Assert(int i, bool b)
    {
        Debug.Assert(i > 0);
        System.Console.WriteLine(i); // strictly positive

        if (b)
            System.Console.WriteLine(i); // strictly positive
    }

    void CheckedUnchecked(int i)
    {
        var x = unchecked(-1 * i * i);
        if (x < 0)
        {
            System.Console.WriteLine(x); // strictly negative
        }

        x = checked(-1 * i * i);
        if (x < 0)
        {
            System.Console.WriteLine(x); // strictly negative
        }
    }

    void CharMinMax()
    {
        var min = char.MinValue;
        var max = char.MaxValue;
        var c = min + 1;
        System.Console.WriteLine(c); // strictly positive
        c = min - 1;
        System.Console.WriteLine(c); // strictly negative
        c = max + 1;
        System.Console.WriteLine(c); // strictly positive
    }

    void NullCoalesce(int? v)
    {
        if (v > 0)
        {
            var x = v ?? 1;
            System.Console.WriteLine(x); // strictly positive
        }

        if (v == null)
        {
            var x = v ?? 1;
            System.Console.WriteLine(x); // strictly positive
        }

        if (v < 0)
        {
            var x = v ?? 0;
            System.Console.WriteLine(x); // negative
        }
    }

    async System.Threading.Tasks.Task Await()
    {
        var i = await System.Threading.Tasks.Task.FromResult(5);
        if (i < 0)
        {
            System.Console.WriteLine(i); // strictly negative
        }
    }

    void Unsigned(uint i)
    {
        if (i != 0) // positive
        {
            System.Console.WriteLine(i); // strictly positive
        }
    }

    public int MyField = 0;

    void FieldAccess()
    {
        var x = new SignAnalysis();
        var y = x.MyField;
        if (y < 0)
        {
            System.Console.WriteLine(y); // strictly negative
        }
    }

    private static unsafe void Pointer(float d)
    {
        float* dp = &d;
        var x = *dp;
        if (x < 0)
        {
            System.Console.WriteLine(x); // strictly negative
        }
    }

    [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Explicit, Size = 15)]
    struct MyStruct { }

    unsafe void Sizeof()
    {
        var x = sizeof(MyStruct);
        System.Console.WriteLine(x); // strictly positive
    }

    void SwitchCase(string s)
    {
        var x = s switch
        {
            "x" => 0,
            _ => 2
        };
        System.Console.WriteLine(x); // positive
    }

    void Capture()
    {
        var i = 1;
        void Capture()
        {
            if (i > 0)
                Console.WriteLine(i); // strictly positive
        }
        Capture();

        if (i > 0)
            Console.WriteLine(i); // strictly positive
    }

    public struct MyStruct2 { public int F; }
    void RefExpression(MyStruct2 s)
    {
        ref var x = ref s.F;
        if (x < 0)
        {
            Console.WriteLine(x); // strictly negative
        }
    }

    enum MyEnum { A = 12, B, C }
    void EnumOp(MyEnum x, MyEnum y)
    {
        var i = x - y;
        if (i < 0)
        {
            System.Console.WriteLine(i); // strictly negative
        }
    }

    unsafe void PointerCast(byte* src, byte* dst)
    {
        var x = (int)(src - dst);
        if (x < 0)
        {
            System.Console.WriteLine(x); // strictly negative
        }

        byte[] buf = new byte[10];

        fixed (byte* to = buf)
        {
            System.Console.WriteLine((int)to);
        }
    }

    uint Unsigned() { return 1; }
    void UnsignedCheck(int i)
    {
        long l = Unsigned();
        if (l != 0)
        {
            System.Console.WriteLine(l); // strictly positive
        }

        uint x = (uint)i;
        x++;
        System.Console.WriteLine(x); // strictly positive
    }

    void Splitting1(bool b)
    {
        var x = b ? 1 : -1;
        if (b)
            System.Console.WriteLine(x); // strictly positive [MISSING]
        else
            System.Console.WriteLine(x); // strictly negative [MISSING]
    }

    void Splitting2(bool b)
    {
        int x;
        if (b) x = 1; else x = -1;

        System.Console.WriteLine(x); // strictly positive (b = true) or strictly negative (b = false)

        if (b)
            System.Console.WriteLine(x); // strictly positive
        else
            System.Console.WriteLine(x); // strictly negative
    }
}

// semmle-extractor-options: /r:System.Linq.dll