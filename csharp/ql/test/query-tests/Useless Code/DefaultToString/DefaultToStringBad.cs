using System;

class Bad
{
    static void Main(string[] args)
    {
        var p = new Person("Eric Arthur Blair");
        Console.WriteLine("p: " + p);

        var ints = new int[] { 1, 2, 3 };
        Console.WriteLine("ints: " + ints);
    }

    class Person
    {
        private string Name;

        public Person(string name)
        {
            this.Name = name;
        }
    }
}
