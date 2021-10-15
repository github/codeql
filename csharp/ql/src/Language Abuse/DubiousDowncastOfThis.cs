class DubiousDowncastOfThis
{
    class BaseClass
    {
        public int doAnything(int x)
        {
            DerivedA a = this as DerivedA;
            if (a != null)
                return a.doSomething(x);

            DerivedB b = this as DerivedB;
            if (b != null)
                return b.doSomethingElse(x);

            return 0;
        }
    }

    class DerivedA : BaseClass
    {
        public int doSomething(int x)
        {
            return x + 5;
        }
    }

    class DerivedB : BaseClass
    {
        public int doSomethingElse(int x)
        {
            return x + 10;
        }
    }
}
