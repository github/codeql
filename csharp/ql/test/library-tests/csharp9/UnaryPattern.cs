using System;

public class UnaryPattern
{
    public int P1 { get; set; }

    public static bool M1(char c) =>
        c is not 'a';
    public static bool M2(object c) =>
        c is not null;
    public static bool M3(object c) =>
        c is not UnaryPattern { P1: 1 } u;

    public static string M4(int i)
    {
        return i switch
        {
            not 1 => "not 1",
            _ => "other"
        };
    }
}
