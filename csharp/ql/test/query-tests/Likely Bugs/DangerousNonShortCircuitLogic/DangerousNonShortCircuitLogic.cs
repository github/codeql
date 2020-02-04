class Test
{
    int Field;

    void M()
    {
        int i = 42;
        var c = new C();

        var x = i | Field; // GOOD
        if (true & false) ; // GOOD
        if (c != null ^ this.Field > 0) ; // GOOD
        if (c != null && c.Field > 0) ; // GOOD

        if (c != null & c.Field > 0) ; // BAD
        if (c == null | c.Property == "") ; // BAD
        if (c == null | c[0]) ; // BAD
        if (c == null | c.Method()) ; // BAD

        var b = true;
        b &= c.Method(); // GOOD
        b |= c[0]; // GOOD

        if (c == null | c.Method(out _)) ; // GOOD
        if (c == null | (c.Method() | c.Method(out _))) ; // GOOD
    }

    class C
    {
        public int Field;
        public string Property { get; set; }
        public bool this[int i] { get { return false; } set { } }
        public bool Method() { return false; }
        public bool Method(out int x) { x = 0; return false; }
    }
}

