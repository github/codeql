public class B
{
    public void M1()
    {
        var e = Source<Elem>(1);
        var b1 = new Box1(e, null);
        var b2 = new Box2(b1);
        Sink(b2.box1.elem1); // $ hasValueFlow=1
        Sink(b2.box1.elem2); // no flow
    }

    public void M2()
    {
        var e = Source<Elem>(2);
        var b1 = new Box1(null, e);
        var b2 = new Box2(b1);
        Sink(b2.box1.elem1); // no flow
        Sink(b2.box1.elem2); // $ hasValueFlow=2
    }

    public static void Sink(object o) { }

    public class Elem { }

    public class Box1
    {
        public Elem elem1;
        public Elem elem2;
        public Box1(Elem e1, Elem e2)
        {
            this.elem1 = e1;
            this.elem2 = e2;
        }
    }

    public class Box2
    {
        public Box1 box1;
        public Box2(Box1 b1)
        {
            this.box1 = b1;
        }
    }

    static T Source<T>(object source) => throw null;
}
