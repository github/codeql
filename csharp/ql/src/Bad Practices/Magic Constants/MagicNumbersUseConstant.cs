class Circle
{
    private const double Pi = 3.14;
    private double radius;
    public double area()
    {
        return Math.Pow(radius, 2) * 3.14; // BAD: use the "Pi" constant
    }
    public double circumference()
    {
        return radius * 2 * 3.14; // BAD: use the "Pi" constant
    }
}
