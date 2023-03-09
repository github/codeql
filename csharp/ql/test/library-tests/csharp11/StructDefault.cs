public class MyEmptyClass { }
public struct StructDefaultValue
{
    public int X;
    public int Y;
    public MyEmptyClass? Z;

    public StructDefaultValue(int x, bool inity)
    {
        X = x;
        if (inity) { Y = 1; }
    }
}