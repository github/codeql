using System;

class Bad
{
    abstract class MathConstants
    {
        public static readonly double Pi = 3.14;
    }

    class Circle : MathConstants
    {
        private double radius;

        public double Area() => Math.Pow(radius, 2) * Pi;
    }
}
