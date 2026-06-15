using Library;

public class F
{
    public void M1()
    {
        object o = null;
        o.Accept(); // $ Alert[cs/dereferenced-value-is-always-null]
    }

    public void M2()
    {
        object? o = null;
        o.AcceptNullable();
    }
}
