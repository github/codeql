class Class1
{
    void M1()
    {
    }

    void M2(int x, string y)
    {
    }

    void M2(object x, string y)
    {
    }

    void M3(int x, double y = 1.0, string z = "foo")
    {
    }

    void M4(int x, params string[] str)
    {
    }

    void M5(int x, params object[] obj)
    {
    }

    void TestCall()
    {
        dynamic x = this;

        // These are GOOD:
        x.M1();
        x.M2(1, "");
        x.M2("", "");
        x.M3(1);
        x.M3(0, 0);
        x.M3(1, 1.0);
        x.M3(1, 1.0, "");
        x.M4(1);
        x.M4(1, "");
        x.M4(1, "", "");
        x.M4(1, new string[1]);
        x.M5(1, new string[1]);

        // These are BAD:
        x.M1(1);
        x.M2();
        x.M2("", 1);
        x.M2(1, "", 2.0);
        x.M3();
        x.M3(1, 2, 3, 4);
        x.M4();
        x.M4(1, 2);
        x.M4("");
        x.M4(1, new object[1]);
        x.M6();

        // These are GOOD:
        x.M7(2);
        x.M7(2, new string[] { "abc" });
        x.M5(1, new string[] { "abc" }, new string[] { "def" });

        // These are BAD:
        x.M7(2, "abc");
        x.M8(1, new string[] { "abc" }, new string[] { "def" });

        // These are GOOD:
        if ("" + "" == "") ;
        dynamic s = "";
        s = s + "";
        dynamic d = new Class2();
        d = d + d;
        d -= 10;

        // These are BAD:
        x = x + x;

        // These are GOOD:
        dynamic d2 = GetI();
        d2.M9();

        // These are BAD:
        dynamic d3 = GetI();
        d3.M();

        // These are GOOD
        dynamic d4 = "";
        d4.ToString();
        decimal dec = 1 / 1;
        char ch = 'a';
        dynamic d5 = dec;
        d5 /= ch;

        // These are GOOD
        dynamic d6 = new System.Collections.Generic.Dictionary<int, string>();
        dynamic d7 = "abc";
        d6.ContainsKey(d7.Length);
        d6 = new System.Collections.Generic.Dictionary<System.Tuple<int, bool>, string>();
        d6.ContainsKey(System.Tuple.Create(d7.Length, false));
    }

    void M7(int p1, params string[][] p2)
    {
    }

    void M8(int p1, params string[] p2)
    {
    }

    I GetI() { return null; }
}

class Class2 : Class1
{
    public static Class2 operator +(Class2 x, Class2 y) { return x; }
    public static Class2 operator -(Class2 x, int y) { return x; }
}

interface I { }

abstract class Class3 : I { }

class Class4 : Class3
{
    public void M9() { }
}
