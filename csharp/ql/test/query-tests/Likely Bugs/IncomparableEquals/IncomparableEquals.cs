public class Test
{
    public bool M()
    {
        var x = new Test2();
        return this.Equals(x); // BAD
    }
}

public class Test2 { }
