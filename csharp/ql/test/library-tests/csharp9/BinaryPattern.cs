using System;

public class BinaryPattern
{
    public int P1 { get; set; }

    public static bool M1(char c) =>
        c is 'a' or 'b';
    public static bool M2(object c) =>
        c is object o and BinaryPattern { P1: 1 } u;
    public static bool M3(object c) =>
        c is object o and BinaryPattern u;

    public static string M4(int i)
    {
        return i switch
        {
            1 or 2 => "1 or 2",
            _ => "other"
        };
    }
}
