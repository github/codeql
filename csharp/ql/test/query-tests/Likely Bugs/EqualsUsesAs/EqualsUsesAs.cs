public class Test1
{
    public override bool Equals(object other)
    {
        var otherTest = other as Test1; // BAD
        return otherTest != null;
    }
}

public sealed class Test2
{
    public override bool Equals(object other)
    {
        var otherTest = other as Test2; // GOOD
        return otherTest != null;
    }
}

public class Test3
{
    public override bool Equals(object other)
    {
        var otherTest = other as Test3; // GOOD
        return otherTest != null && other.GetType() == typeof(Test3);
    }
}

public class Test4
{
    public override bool Equals(object other)
    {
        var otherTest = other as Test4; // GOOD
        return otherTest != null && otherTest.GetType() == typeof(Test4);
    }
}
