using System;

class Good
{
    double ParseInt(string s)
    {
        int.TryParse(s, out int i);
        return i;
    }

    bool IsDouble(string s)
    {
        var success = double.TryParse(s, out _);
        return success;
    }

    double ParseDouble(string s)
    {
        try
        {
            return double.Parse(s);
        }
        catch (FormatException)
        {
            return double.NaN;
        }
    }

    int Count(string[] ss)
    {
        return ss.Length;
    }

    string IsInt(object o)
    {
        if (o is int)
            return "yes";
        else
            return "no";
    }

    string IsString(object o)
    {
        switch (o)
        {
            case string _:
                return "yes";
            default:
                return "no";
        }
    }
}
