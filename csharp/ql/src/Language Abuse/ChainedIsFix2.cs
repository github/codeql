class ChainedIs
{
    interface Visitor
    {
        void Visit(Cat c);
        void Visit(Dog d);
    }
    class SpeakVisitor : Visitor
    {
        public void Visit(Cat c) { Console.WriteLine("Miaow!"); }
        public void Visit(Dog d) { Console.WriteLine("Woof!"); }
    }
    interface Animal
    {
        void Accept(Visitor v);
    }
    class Cat : Animal
    {
        public void Accept(Visitor v) { v.Visit(this); }
    }
    class Dog : Animal
    {
        public void Accept(Visitor v) { v.Visit(this); }
    }

    public static void Main(string[] args)
    {
        List<Animal> animals = new List<Animal> { new Cat(), new Dog() };
        foreach (var a in animals)
            a.Accept(new SpeakVisitor());
    }
}
