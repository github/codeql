using System;

class Good
{
    static void Main(string[] args)
    {
        var p = new Person("Eric Arthur Blair");
        Console.WriteLine("p: " + p);

        var ints = new int[] { 1, 2, 3 };
        Console.WriteLine("ints: " + string.Join(", ", ints));
    }

    class Person
    {
        private string Name;

        public Person(string name)
        {
            this.Name = name;
        }

        public override string ToString() => Name;
    }
}
