namespace ObInit {
    public class A {
        int x = 1;

        public string s = "source";

        public A() { }

        public A(int y) { }

        public A(int y, int z) : this(y) { }
    }

    public class B : A {
        public B() : base(10) { }

        static void Sink(string s) { }

        static void Foo() {
            A a = new A();
            Sink(a.s); // $ flow

            A a2 = new A(0, 0);
            Sink(a2.s); // $ MISSING: flow

            B b = new B();
            Sink(b.s); // $ MISSING: flow
        }
    }
}
