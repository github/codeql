public class Test
{
    public bool M()
    {
        var x = new Test2();
        return this.Equals(x); // $ Alert // BAD
    }
}

public class Test2 { }
