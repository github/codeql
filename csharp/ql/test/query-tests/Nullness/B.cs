using System;

class B
{
    public void OperatorCall()
    {
        B eqCallAlways = null;
        B b2 = null;
        B b3 = null;
        B neqCallAlways = null;

        if (eqCallAlways == null)
            eqCallAlways.ToString(); // BAD (always)

        if (b2 != null)
            b2.ToString(); // GOOD

        if (b3 == null) { }
        else
            b3.ToString(); // GOOD

        if (neqCallAlways != null) { }
        else
            neqCallAlways.ToString(); // BAD (always)
    }

    public static bool operator ==(B b1, B b2)
    {
        return Object.Equals(b1, b2);
    }

    public static bool operator !=(B b1, B b2)
    {
        return !(b1 == b2);
    }

    public struct Coords
    {
        public int x, y;

        public Coords(int p1, int p2)
        {
            x = p1;
            y = p2;
        }
    }

    public class Casts
    {
        void test()
        {
            object o = null;
            if ((object)o != null)
            {
                var eq = o.Equals(o); // GOOD
            }
        }
    }

    public class Delegates
    {
        delegate void Del();

        class Foo
        {
            public static void Run(Del d) => d();
            public void Bar() { }
        }

        void F()
        {
            Foo foo = null;
            Foo.Run(delegate { foo = new Foo(); });
            foo.Bar(); // GOOD
        }
    }
}
