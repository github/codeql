using System;

class Bad
{
    double ParseInt(string s)
    {
        var success = int.TryParse(s, out int i); // $ Alert
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
        catch (FormatException e) // $ Alert
        {
            return double.NaN;
        }
    }

    int Count(string[] ss)
    {
        int count = 0;
        foreach (var s in ss) // $ Alert
            count++;
        return count;
    }

    string IsInt(object o)
    {
        if (o is int i) // $ Alert
            return "yes";
        else
            return "no";
    }

    string IsString(object o)
    {
        switch (o)
        {
            case string s: // $ Alert
                return "yes";
            default:
                return "no";
        }
    }
}
