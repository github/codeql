public class Constructors
{
    public class C_no_ctor
    {
        private object s1 = Source<object>(1);

        void M1()
        {
            C_no_ctor c = new C_no_ctor();
            c.M2();
        }

        public void M2()
        {
            Sink(s1); // $ hasValueFlow=1
        }
    }

    public class C_with_ctor
    {
        private object s1 = Source<object>(1);

        void M1()
        {
            C_with_ctor c = new C_with_ctor();
            c.M2();
        }

        public C_with_ctor() { }

        public void M2()
        {
            Sink(s1); // $ hasValueFlow=1
        }
    }

    public static void Sink(object o) { }

    public static T Source<T>(object source) => throw null;
}
