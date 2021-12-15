using System;

public class RelationalPattern
{
    public static bool M1(char c) =>
        c is >= 'a';
    public static bool M2(char c) =>
        c is > 'a';
    public static bool M3(char c) =>
        c is <= 'a';
    public static bool M4(char c) =>
        c is < 'a';

    public static string M5(int i)
    {
        return i switch
        {
            1 => "1",
            >1 => ">1",
            _ => "other"
        };
    }
}
