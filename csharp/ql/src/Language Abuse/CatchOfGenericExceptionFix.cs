double reciprocal(double input)
{
    try
    {
        return 1 / input;
    }
    catch (DivideByZeroException)
    {
        return 0;
    }
    catch (OverflowException)
    {
        return double.MaxValue;
    }
}
