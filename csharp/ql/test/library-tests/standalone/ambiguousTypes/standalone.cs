using A;
using B;

namespace A
{
    public class Base
    {
        public void M0(string s) { }
        public void M0(string s, int i = 1) { }
        public void M0(string s, double d = 0.0) { }
        public void M0(string s, params int[] i) { }
    }

    public class C : Base
    {
        public void M1(string s) { }
        public void M1(string s, int i = 1) { }
        public void M1(string s, double d = 0.0) { }
        public void M1(string s, params int[] i) { }

        public void M3(string s) { }

        public static void M4(string s) { }
        public void M4(string s, int i = 5) { }
    }
}

namespace B
{
    public class C : Base
    {
        public void M2(string s) { }
        public void M2(string s, int i = 1) { }
        public void M2(string s, double d = 0.0) { }
        public void M2(string s, params int[] i) { }

        public void M3(string s) { }
    }
}

public class D
{
    public C c = new();

    private void M(string s)
    {
        c.M0(s);
        c.M0(s, 1);
        c.M0(s, 1.1);
        c.M0(s, 1, 2);

        c.M1(s);
        c.M1(s, 1);
        c.M1(s, 1.1);
        c.M1(s, 1, 2);

        c.M2(s);
        c.M2(s, 1);
        c.M2(s, 1.1);
        c.M2(s, 1, 2);

        c.M3(s);

        c.M0(s, new[] { 1, 2 });
        c.M1(s, new[] { 1, 2 });
        c.M2(s, new[] { 1, 2 });

        C.M4(s);
        c.M4(s);
    }

    private static void Main()
    {
    }
}