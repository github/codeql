class NullCoalescing
{
    int M1(int? i) => i ?? 0;

    int M2(bool? b) => (b ?? false) ? 0 : 1;

    string M3(string s1, string s2) => s1 ?? s2 ?? "";

    string M4(bool b, string s) => (b ? s : s) ?? "" ?? "";

    int M5(bool? b1, bool b2, bool b3) => (b1 ?? (b2 && b3)) ? 0 : 1;

    void M6(int i)
    {
        var j = (int?)null ?? 0;
        var s = "" ?? "a";
        j = (int?)i ?? 1;
    }
}
