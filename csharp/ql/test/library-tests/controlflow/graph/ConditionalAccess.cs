class ConditionalAccess
{
    string M1(int? i) => i?.ToString()?.ToLower();

    int? M2(string s) => s?.Length;

    int? M3(string s1, string s2) => (s1 ?? s2)?.Length;

    int M4(string s) => s?.Length ?? 0;

    int M5(string s)
    {
        if (s?.Length > 0)
            return 0;
        else
            return 1;
    }

    string M6(string s1, string s2) => s1?.CommaJoinWith(s2);

    void M7(int i)
    {
        var j = ((string)null)?.Length;
        var s = ((int?)i)?.ToString();
        s = ""?.CommaJoinWith(s);
    }
}

static class Ext
{
    public static string CommaJoinWith(this string s1, string s2) => s1 + ", " + s2;
}
