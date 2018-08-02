class ChainedIs
{
    interface Animal
    {
        void Speak();
    }
    class Cat : Animal
    {
        public void Speak() { Console.WriteLine("Miaow!"); }
    }
    class Dog : Animal
    {
        public void Speak() { Console.WriteLine("Woof!"); }
    }

    public static void Main(string[] args)
    {
        List<Animal> animals = new List<Animal> { new Cat(), new Dog() };
        foreach (var a in animals)
            a.Speak();
    }
}
