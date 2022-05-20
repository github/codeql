using System;

class Bad
{
    double ParseInt(string s)
    {
        var success = int.TryParse(s, out int i);
        return i;
    }

    bool IsDouble(string s)
    {
        var success = double.TryParse(s, out double i);
        return success;
    }

    double ParseDouble(string s)
    {
        try
        {
            return double.Parse(s);
        }
        catch (FormatException e)
        {
            return double.NaN;
        }
    }

    int Count(string[] ss)
    {
        int count = 0;
        foreach (var s in ss)
            count++;
        return count;
    }

    string IsInt(object o)
    {
        if (o is int i)
            return "yes";
        else
            return "no";
    }

    string IsString(object o)
    {
        switch (o)
        {
            case string s:
                return "yes";
            default:
                return "no";
        }
    }
}
