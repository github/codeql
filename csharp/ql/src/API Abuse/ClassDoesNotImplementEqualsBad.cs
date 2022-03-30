using System;

class Bad
{
    class Car
    {
        protected string make;
        protected string model;

        public Car(string make, string model)
        {
            this.make = make;
            this.model = model;
        }

        public override bool Equals(object obj)
        {
            if (obj is Car c && c.GetType() == typeof(Car))
                return make == c.make && model == c.model;
            return false;
        }
    }

    class GasolineCar : Car
    {
        protected bool unleaded;

        public GasolineCar(string make, string model, bool unleaded) : base(make, model)
        {
            this.unleaded = unleaded;
        }
    }

    public static void Main(string[] args)
    {
        var car1 = new GasolineCar("Ford", "Focus", true);
        var car2 = new GasolineCar("Ford", "Focus", false);
        Console.WriteLine("car1 " + (car1.Equals(car2) ? "does" : "does not") + " equal car2.");
    }
}
