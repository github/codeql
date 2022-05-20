class MissedCastOpportunityFix
{
    class Animal { }

    class Dog : Animal
    {
        private string name;

        public Dog(string name)
        {
            this.name = name;
        }

        public void Woof()
        {
            Console.WriteLine("Woof! My name is " + name + ".");
        }
    }

    public static void Main(string[] args)
    {
        List<Animal> lst = new List<Animal> { new Dog("Rover"),
            new Dog("Fido"), new Dog("Basil") };

        foreach (Dog d in lst.Cast<Dog>())
        {
            d.Woof();
        }
    }
}
