
public class TestConsts
{
    const char max1 = 'n';  // GOOD: Not dead

    public bool Const1(char c)
    {
        return c <= max1;
    }

    public bool Const2(char c)
    {
        const char max2 = 'm';  // GOOD: Not dead
        return c <= max2;
    }

    public int Const3(char c)
    {
        const char max2 = 'm';  // GOOD: Not dead
        return max2 + 1;
    }

}
