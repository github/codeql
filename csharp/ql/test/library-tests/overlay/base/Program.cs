using System;

namespace ConsoleApp1
{
    internal class Program
    {
        public static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Print usage instructions here.");
                return;
            }
            var x = args[0];
            var a = new A(x);
            Console.WriteLine(a.ToString());
        }

        private string programName;

        public Program(string x)
        {
            programName = x;
        }

        // Program destructor
        ~Program()
        {
            Console.WriteLine("Program destructor called!");
        }

        public string ProgramProp { get; set; } = "Hello World!";

        public string this[int i]
        {
            get { return string.Empty; }
            set { }
        }

        /*
         * A program event.
         */
        public event EventHandler ProgramClicked
        {
            add
            {
                Console.WriteLine("Program handler added");
            }
            remove
            {
                Console.WriteLine("Program handler removed");
            }
        }

        public static Program operator -(Program a, Program b)
        {
            return b;
        }

        [Program]
        public void AnnotatedMethod() { }
    }

    public class ProgramAttribute : Attribute { }
}
