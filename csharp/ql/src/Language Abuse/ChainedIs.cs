class ChainedIs
{
    interface Animal { }
    class Cat : Animal { }
    class Dog : Animal { }

    public static void Main(string[] args)
    {
        List<Animal> animals = new List<Animal> { new Cat(), new Dog() };
        foreach (Animal a in animals)
        {
            if (a is Cat)
                Console.WriteLine("Miaow!");
            else if (a is Dog)
                Console.WriteLine("Woof!");
            else
                throw new Exception("Oops!");
        }
    }
}
