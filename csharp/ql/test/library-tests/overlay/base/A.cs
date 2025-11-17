using System;

namespace ConsoleApp1
{
    public class A
    {
        private string name;
        public A(string x)
        {
            name = x;
        }

        // Destructor
        ~A()
        {
            Console.WriteLine("Destructor called!");
        }

        public string Prop { get; set; } = "Hello";

        public object this[int i]
        {
            get { return new object(); }
            set { }
        }

        /*
         * An example event
         */
        public event EventHandler Clicked
        {
            add
            {
                Console.WriteLine("Handler added");
            }
            remove
            {
                Console.WriteLine("Handler removed");
            }
        }

        public static A operator +(A a, A b)
        {
            return a;
        }

        [MyObsolete]
        public void ObsoleteMethod() { }

        public int OldMethod(int x)
        {
            var y = x + 1;
            return y;
        }

        public override string ToString()
        {
            var x = $"A: {name}";
            return x;
        }
    }

    public class MyObsoleteAttribute : Attribute { }

    public class B { }
}
