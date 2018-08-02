public class Test1
{
    public override bool Equals(object other)
    {
        return other is Test1; // BAD
    }
}

public sealed class Test2
{
    public override bool Equals(object other)
    {
        return other is Test2; // GOOD
    }
}
