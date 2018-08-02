using System;

class Switch
{
    void M1(object o)
    {
        switch (o) { }
    }

    void M2(object o)
    {
        switch (o)
        {
            case "a":
                return;
            case 0:
                throw new Exception();
            case null:
                goto default;
            case int i:
                if (o == null)
                    return;
                goto case 0;
            case string s when s.Length > 0 && s != "a":
                Console.WriteLine(s);
                return;
            case double d when Throw():
                Label:
                return;
            default:
                goto Label;
        }
    }

    void M3()
    {
        switch (Throw())
        {
            default:
                return;
        }
    }

    void M4(object o)
    {
        switch (o)
        {
            case int _:
                break;
            case bool _ when o != null:
                break;
        }
    }

    static bool Throw() => throw new Exception();
}
