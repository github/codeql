using System;
using System.Text;

class Strings
{
    void Test()
    {
        var s = "";
        object o = null;

        s = s + o;
        s += o;

        var sb = new StringBuilder();
        sb.Append(o);
        sb.AppendFormat("{0}", o);
        sb.AppendFormat("{0}, {1}, {2}, {3}", o, o, o, o);
        sb.AppendFormat("{0}, {1}, {2}, {3}", new object[] { o, o, o, o });

        string.Format("{0}", o);
        string.Format("{0}, {1}, {2}, {3}", o, o, o, o);
        string.Format("{0}, {1}, {2}, {3}", new object[] { o, o, o, o });

        Console.Write(true);
        Console.WriteLine(0);

        MyStringFormat("{1}", o);

        s = $"Hello: {o}";
    }

    string MyStringFormat(string s, params object[] args)
    {
        return string.Format(s, args);
    }

    string MyRestrictedStringFormat(string s, params string[] args)
    {
        return string.Format(s, args);
    }

    string MyReadOnlyStringFormat(string s, params ReadOnlySpan<object> args)
    {
        return string.Format(s, args);
    }
}
