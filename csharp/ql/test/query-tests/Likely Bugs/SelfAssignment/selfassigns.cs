using System;

class Super
{
    protected int IntField;
    protected bool BoolProp { get; set; }
    public virtual string StringProp { get; set; }
}

class SelfAssigns : Super
{
    public override string StringProp { get; set; }
    public SelfAssigns Self;

    private int x, y, z;

    private int weird1;
    public int Weird1
    {
        get
        {
            Console.WriteLine("Side effect!");
            return weird1;
        }
        set
        {
            weird1 = value;
        }
    }

    private int weird2;
    public int Weird2
    {
        get
        {
            return weird2;
        }
        set
        {
            Console.WriteLine("Side effect!");
            weird2 = value;
        }
    }

    private int normal;
    public int Normal1
    {
        get { return normal; }
        set { normal = value; }
    }

    public int Normal2 { get; set; }

    int[] intArray;

    int this[int i] { get { return 0; } set { } }

    public void OK(SelfAssigns obj, int x)
    {
        obj.x = x;
        x = this.x;
        this.x = x;
        obj.Weird1 = obj.Weird1;
        obj.Weird2 = obj.Weird2;
        base.StringProp = this.StringProp;
        this.Self.Self.Self.IntField = Self.Self.IntField;
        intArray[0] = intArray[1];
        new SelfAssigns { StringProp = StringProp };
    }

    public void NotOK(SelfAssigns obj, int y)
    {
        this[4] = this[4];
        y = y;
        obj.y = obj.y;
        z = this.z;
        this.z = z;
        obj.Normal1 = obj.Normal1;
        obj.Normal2 = obj.Normal2;
        base.IntField = IntField;
        this.BoolProp = base.BoolProp;
        this.Self.Self.Self.StringProp = Self.Self.Self.StringProp;
        intArray[1] = this.intArray[1 + 0];
    }

    enum Enum
    {
        X = 42,
        Y = 100,
        Z
    }
}
