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

    void M5()
    {
        switch (1 + 2)
        {
            case 2:
                break;
            case 3:
                break;
        }
    }

    void M6(string s)
    {
        switch ((object)s)
        {
            case int _:
                break;
            case "":
                break;
        }
    }

    bool M7(int i, int j)
    {
        switch (i)
        {
            case 1:
                return true;
            case 2:
                if (j > 2)
                    break;
                return true;
        }
        return false;
    }

    bool M8(object o)
    {
        switch (o)
        {
            case int _:
                return true;
        }
        return false;
    }

    int M9(string s)
    {
        switch (s?.Length)
        {
            case 0: return 0;
            case 1: return 1;
        }
        return -1;
    }

    static bool Throw() => throw new Exception();

    int M10(string s)
    {
        switch (s.Length)
        {
            case 3 when s == "foo": return 1;
            case 2 when s == "fu": return 2;
        }
        return -1;
    }

    void M11(object o)
    {
        if (o switch { bool b => b, _ => false })
            return;
    }

    string M12(object o)
    {
        return (o switch { string s => s, _ => null })?.ToString();
    }

    int M13(int i)
    {
        switch (i)
        {
            default: return -1;
            case 1: return 1;
            case 2: return 2;
        }
    }

    int M14(int i)
    {
        switch (i)
        {
            case 1: return 1;
            default: return -1;
            case 2: return 2;
        }
    }

    void M15(bool b)
    {
        var s = b switch { true => "a", false => "b" };
        if (b)
            System.Console.WriteLine($"a = {s}");
        else
            System.Console.WriteLine($"b = {s}");
    }
}
