public partial class Partial1
{
    private object[] _backingArray = new object[10];
    public partial object this[int index]
    {
        get { return _backingArray[index]; }
        set { _backingArray[index] = value; }
    }
}

public partial class Partial1
{
    public partial object this[int index] { get; set; }
}

public partial class Partial2
{
    public partial object this[int index]
    {
        get { return null; }
        set { }
    }
}

public partial class Partial2
{
    public partial object this[int index] { get; set; }
}

public partial class PartialTest
{
    public void M()
    {
        var o = Source<object>(1);

        var p1 = new Partial1();
        p1[0] = o;
        Sink(p1[0]); // $ hasValueFlow=1

        var p2 = new Partial2();
        p2[0] = o;
        Sink(p2[0]); // no flow
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
