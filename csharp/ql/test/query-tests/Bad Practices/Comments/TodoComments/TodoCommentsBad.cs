using System;

class Bad
{
    public static double SolveQuadratic(double a, double b, double c)
    {
        // TODO: handle case where a == 0
        return (-b + Math.Sqrt(b * b - 4 * a * c)) / (2 * a);
    }
}
