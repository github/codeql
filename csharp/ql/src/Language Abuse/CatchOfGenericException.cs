double reciprocal(double input)
{
    try
    {
        return 1 / input;
    }
    catch
    {
        // division by zero, return 0
        return 0;
    }
}
