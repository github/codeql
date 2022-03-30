using System;

public struct MyStruct
{
    public int X;
    public MyStruct(int x) => X = x;
}

public record struct MyRecordStruct2(int Y) { }

public class MyWithExamples
{
    public void M1()
    {
        var s1 = new MyStruct(1);
        var s2 = s1 with { X = 2 };
    }

    public void M2()
    {
        var r1 = new MyRecordStruct2(4);
        var r2 = r1 with { Y = 6 };
    }

    public void M3()
    {
        var anon1 = new { A = 3, B = 4 };
        var anon2 = anon1 with { A = 5 };
    }
}