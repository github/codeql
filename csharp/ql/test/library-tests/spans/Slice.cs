using System;

public class C
{
    public void M(int a, int b)
    {
        var s = "hello world";
        var sub1 = s[1..a];
        var sub2 = s[..2];
        var sub3 = s[3..];
        var sub4 = s[..^4];
        var sub5 = s[a..^b];

        Span<int> sp = null;
        var slice1 = sp[5..a];
        var slice2 = sp[..6];
        var slice3 = sp[7..];
        var slice4 = sp[..^8];
        var slice5 = sp[a..^b];
    }
}
