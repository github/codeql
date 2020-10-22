using System;

public class Pattern
{
    public void M1(object o)
    {
        if (o is not null)
        {
            var x = o.ToString();
        }

        switch (o)
        {
            case Pattern: break;
        }
    }

    public static bool IsLetter(this char c) =>
        c is >= 'a' and <= 'z' or >= 'A' and <= 'Z';

    public static bool IsLetterOrSeparator(this char c) =>
        c is (>= 'a' and <= 'z') or (>= 'A' and <= 'Z') or '.' or ',';
}
