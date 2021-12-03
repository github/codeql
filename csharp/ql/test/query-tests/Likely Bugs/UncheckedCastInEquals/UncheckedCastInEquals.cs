public class Test
{
    public int Field;

    public override bool Equals(object other)
    {
        return ((Test)other).Field == this.Field;
    }
}
