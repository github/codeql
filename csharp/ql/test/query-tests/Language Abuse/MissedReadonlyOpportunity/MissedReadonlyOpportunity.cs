class MissedReadonlyOpportunity<T>
{
    public int Bad1; // $ Alert
    public T Bad2; // $ Alert
    public Immutable Bad3; // $ Alert
    public readonly int Good1;
    public readonly int Good2 = 0;
    public const int Good3 = 0;
    public int Good4;
    public readonly T Good5;
    public T Good6;
    public Mutable Good7;

    public MissedReadonlyOpportunity(int i, T t)
    {
        Bad1 = i;
        Bad2 = t;
        Bad3 = new Immutable();
        Good1 = i;
        Good2 = i;
        Good4 = i;
        Good5 = t;
        Good6 = t;
        Good7 = new Mutable();
    }

    public void M(int i)
    {
        Good4 = i;
        var x = new MissedReadonlyOpportunity<bool>(0, true);
        x.Good6 = false;
    }
}

struct Mutable
{
    private int x;
    public int Mutate()
    {
        x = x + 1;
        return x;
    }
}

readonly struct Immutable { }

class Tree
{
    private Tree? Parent;
    private Tree? Left; // $ Alert
    private readonly Tree? Right;

    public Tree(Tree left, Tree right)
    {
        this.Left = left;
        this.Right = right;
        left.Parent = this;
        right.Parent = this;
    }

    public Tree()
    {
        Left = null;
        Right = null;
    }
}

class StaticFields
{
    static int X; // $ Alert
    static int Y;

    // Static constructor
    static StaticFields()
    {
        X = 0;
    }

    // Instance constructor
    public StaticFields(int y)
    {
        Y = y;
    }
}
