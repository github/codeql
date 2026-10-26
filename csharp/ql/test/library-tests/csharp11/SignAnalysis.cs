public class MySignAnalysis
{

    public void UnsignedRightShiftSign(int x, int y)
    {
        int z;
        if (x == 0)
        {
            z = x >>> y;
        }

        if (y == 0)
        {
            z = x >>> y;
        }

        if (x > 0 && y == 0)
        {
            z = x >>> y;
        }

        if (x > 0 && y > 0)
        {
            z = x >>> y;
        }

        if (x > 0 && y < 0)
        {
            z = x >>> y;
        }

        if (x < 0 && y > 0)
        {
            z = x >>> y;
        }

        if (x < 0 && y < 0)
        {
            z = x >>> y;
        }
    }
}