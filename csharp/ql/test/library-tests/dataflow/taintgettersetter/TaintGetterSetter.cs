public class A
{
    string Taint() { return "tainted"; }
    void Sink(object o) { }

    static string Step(string s) { return s + "0"; }

    class Box
    {
        public string s;
        public Box(string s)
        {
            this.s = s + "1";
        }
        public string GetS1() { return s + "2"; }
        public string GetS2() { return Step(s + "_") + "2"; }
        public void SetS1(string s) { this.s = "3" + s; }
        public void SetS2(string s) { this.s = "3" + Step("_" + s); }
        public static Box mk(string s)
        {
            Box b = new Box("");
            b.s = Step(s);
            return b;
        }
    }

    class Box2
    {
        string s1;
        string s2;
        public Box2(string s1, string s2)
        {
            this.s1 = s1 + "1";
            this.s2 = s2 + "2";
        }

        public string GetS1() { return s1 + "2"; }
        public string GetS2() { return Step(s2 + "_") + "2"; }
        public void SetS2(string s) { s2 = "3" + Step("_" + s); }
        public Box2 GetS1SetS2()
        {
            var b = new Box2("", "");
            b.SetS2(this.GetS1());
            return b;
        }
    }

    void M(Box b1, Box b2)
    {
        b1.SetS1(Taint());
        Sink(b1.GetS1());

        b2.SetS2(Taint());
        Sink(b2.GetS2());

        string t3 = Taint();
        var b3 = new Box(Step(t3));
        Sink(b3.s);

        var b4 = Box.mk(Taint());
        Sink(b4.GetS1());

        var b5 = new Box2(Taint(), "");
        var b6 = b5.GetS1SetS2();
        Sink(b6.GetS2());
    }
}
