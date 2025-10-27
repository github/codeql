using System;

namespace ConsoleApp1
{
    public class C { }

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


        public override string ToString()
        {
            string y;
            y = $"Name: {name}";
            return y;
        }

        public void NewMethod()
        {
            if (name.EndsWith("test"))
            {
                name = name.ToUpper();
            }
        }
    }

    public class MyObsoleteAttribute : Attribute { }
}
