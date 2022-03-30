namespace N
{
    /*internal*/
    unsafe class C
    {
        /*private*/
        C() { }

        public C(int i) : this() { }

        /*private*/
        void M1() { }

        private void M2() { }

        protected void M3() { }

        public static extern void M4();

        /*private*/
        async void M5() { }

        /*private*/
        sealed class C1
        {
            public C1() { }
        }

        protected abstract class C2 : C
        {
            protected C2() { }

            new void M2() { }

            public abstract void M6();
        }

        internal partial class C3 { }

        /*private*/
        static int F1;

        public const int F2 = 0;

        internal protected readonly int F3;

        private volatile int F4;
    }

    internal interface I { }

    public struct S
    {
        public int P1 { /*public*/ get; /*public*/ set; }
        public int P2 { /*public*/ get; private set; }
        /*private*/
        int P3 { /*private*/ get; /*private*/ set; }
    }

    public interface I1
    {
        void M1();
        void M2() => throw null;
    }

    internal interface I2
    {
        void M1() => throw null;
    }

    public class C2 : I2
    {
        void I2.M1() => throw null;

        protected private void M2() { }
        protected internal void M3() { }
    }
}
