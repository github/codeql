using System;

class NoConstantsOnly
{
    abstract class MathConstants
    {
        public const double Pi = 3.14; // BAD
    }

    class Circle : MathConstants
    {
        private double radius;

        public double Area() => Math.Pow(radius, 2) * Pi;
    }
}
