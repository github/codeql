using System;

class Patterns
{
    void M1()
    {
        object o = null;
        if (o is int i1)
        {
            Console.WriteLine($"int {i1}");
        }
        else if (o is string s1)
        {
            Console.WriteLine($"string {s1}");
        }
        else if (o is var v1)
        {
        }

        switch (o)
        {
            case "xyz":
                break;
            case int i2 when i2 > 0:
                Console.WriteLine($"positive {i2}");
                break;
            case int i3:
                Console.WriteLine($"int {i3}");
                break;
            case string s2:
                Console.WriteLine($"string {s2}");
                break;
            case var v2:
                break;
            default:
                Console.WriteLine("Something else");
                break;
        }

        switch (o)
        {
        }
    }

    public int P1 { get; set; }

    public static bool M2(char c) =>
        c is not 'a';

    public static bool M3(object c) =>
        c is not null ? c is 1 : c is 2;

    public static bool M4(object c) =>
        c is not Patterns { P1: 1 } u;

    public static string M5(int i)
    {
        return i switch
        {
            not 1 => "not 1",
            _ => "other"
        };
    }

    public static string M6()
    {
        return 2 switch
        {
            not 2 => "impossible",
            2 => "possible"
        };
    }

    public static string M7(int i)
    {
        return i switch
        {
            > 1 => "> 1",
            < 0 => "< 0",
            1 => "1",
            _ => "0"
        };
    }

    public static string M8(int i) => i is 1 or not 2 ? "not 2" : "2";

    public static string M9(int i) => i is 1 and not 2 ? "1" : "not 1";

    public E Prop { get; set; }

    public enum E { A, B, C }

    public void M10()
    {
        if (this is { Prop: E.A or E.B })
        {
            Console.WriteLine("not C");
        }
    }
}
