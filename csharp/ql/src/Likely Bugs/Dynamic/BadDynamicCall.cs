class BadDynamicCall
{
    class WithFoo
    {
        public void Foo(int i) { }
    }

    class WithoutFoo { }

    public static void Main(string[] args)
    {
        dynamic o = new WithoutFoo();
        o.Foo(3);
    }
}
