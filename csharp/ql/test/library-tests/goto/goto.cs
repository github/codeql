
class Goto
{
    static void Main()
    {
        {
            s1: goto s2;
        }
        s2: string s = "5";
        switch (s)
        {
            case null: s3: goto case "1";
            case "1": s4: goto case "2";
            case "2": s5: goto s2;
            case "3": s6: goto default;
            case "4": s7: break;
            default: s8: goto case null;
        }
        s9:;
    }
}
