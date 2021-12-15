public class G
{
    Box2 boxfield;

    public void M1()
    {
        Elem e = Source<Elem>(1);
        Box2 b = new Box2(new Box1(null));
        b.Box1.Elem = e;
        SinkWrap(b);
    }

    public void M2()
    {
        Elem e = Source<Elem>(2);
        Box2 b = new Box2(new Box1(null));
        b.Box1.SetElem(e);
        SinkWrap(b);
    }

    public void M3()
    {
        Elem e = Source<Elem>(3);
        Box2 b = new Box2(new Box1(null));
        b.GetBox1().Elem = e;
        SinkWrap(b);
    }

    public void M4()
    {
        Elem e = Source<Elem>(4);
        Box2 b = new Box2(new Box1(null));
        b.GetBox1().SetElem(e);
        SinkWrap(b);
    }

    public static void SinkWrap(Box2 b2)
    {
        Sink(b2.GetBox1().GetElem()); // $ hasValueFlow=1 $ hasValueFlow=2 $ hasValueFlow=3 $ hasValueFlow=4
    }

    public void M5a()
    {
        Elem e = Source<Elem>(5);
        boxfield = new Box2(new Box1(null));
        boxfield.Box1.Elem = e;
        M5b();
    }

    private void M5b()
    {
        Sink(boxfield.Box1.Elem); // $ hasValueFlow=5
    }

    public static void Sink(object o) { }

    public class Elem { }

    public class Box1
    {
        public Elem Elem;
        public Box1(Elem e) { Elem = e; }
        public Elem GetElem() => Elem;
        public void SetElem(Elem e) { Elem = e; }
    }

    public class Box2
    {
        public Box1 Box1;
        public Box2(Box1 b) { Box1 = b; }
        public Box1 GetBox1() => Box1;
        public void SetBox1(Box1 b) { Box1 = b; }
    }

    static T Source<T>(object source) => throw null;
}