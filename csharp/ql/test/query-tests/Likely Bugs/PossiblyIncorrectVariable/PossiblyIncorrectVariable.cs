using System;

namespace Test
{
    class Point1
    {
        public double x, y;

        public Point1(double x, double y)
        {
            this.x = x;
            this.x = y;  // BAD: this.x should be this.y.
        }

        public Point1(double x, double y, double z)
        {
            this.x = x;
            this.y = y;  // GOOD
        }
    }

    class Point2
    {
        public double mX { get; set; }
        public double mY { get; set; }

        public Point2(double x, double y)
        {
            mX = x;
            mY = x;  // BAD: x should be y.
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            var p1 = new Point1(1, 2);
            var p2 = new Point1(1, 2);
            var p3 = new Point2(1, 2);
            var p4 = new Point2(1, 2);
            double m_x, m_y;

            if (p1.x == p1.x &&
                p1.x == p2.y)  // BAD: x should be y
            {
            }

            if (p1.x == p1.x &&
                p1.y == p2.y)  // GOOD
            {
            }

            p2.x = p1.x;
            p2.y = p1.x;  // BAD: x should be y

            p1.x = p2.x;
            p1.x = p2.y;  // BAD: x should be y

            p3.mX = p1.x;
            p3.mX = p1.y;  // BAD: mX should be mY

            p1.x = p3.mX;
            p1.x = p3.mY;  // BAD: x should be y

            m_x = p1.x;
            m_x = p1.y;  // BAD: x should be y

            m_x = p1.x;
            m_y = p1.y;  // GOOD

            var x = p4.mX;
            var y = p4.mX;  // BAD: mX should be mY

            double Mx = p1.x, My = p1.x;  // BAD: x should be y

            double Nx = p1.x, Ny = p1.y;  // GOOD

            double NN1x = p1.x, NN2y = p1.x;  // GOOD: Nx and NNy are sufficiently unrelated

            if (p1.x != p1.x ||
                p1.x != p2.y)  // BAD: x should be y
            {
            }

            if (p1.x != p1.x ||
                p1.y != p2.y)  // GOOD
            {
            }

            {
                // Tests block scope
                double Lx = 1, Ly = 2;
                p2.x = Lx;
                p2.x = Ly;  // BAD: x should be y

                p2.x = Lx;
                p2.y = Lx;  // BAD: Lx should be Ly
            }
            {
                // Tests block scope
                double Lx = 1, Ly = 2;
                p2.x = Lx;
                p2.x = Ly;  // BAD: x should be y

                p2.x = Lx;
                p2.y = Lx;  // BAD: Lx should be Ly
            }

            if (p1.x == p1.x ||
                p1.x != p2.y)  // GOOD: different operators
            {
            }

            var person1 = new Person();
            var person2 = new Person();

            person1.Surname = person2.Surname;
            person1.GivenName = person2.Surname; // GOOD: names are still related

            if (p1.x == p2.x ||
                p1.x == p2.y ||  // GOOD: False positive
                p1.y == p2.x ||
                p1.y == p2.y)
            {
            }
        }
    }

    class Person
    {
        public string GivenName, Surname;
    }
}
