using System.Threading.Tasks;

namespace ConstantIsNullOrEmpty
{
    internal class Program
    {
        static void Main(string[] args)
        {
            {
                if (string.IsNullOrEmpty(nameof(args))) // $ Alert
                {
                }

                string? x = null;
                if (string.IsNullOrEmpty(x)) // Missing Alert (always true)
                {
                }

                string y = "";
                if (string.IsNullOrEmpty(y)) // Missing Alert (always true)
                {
                }

                if (args[1] != null)
                    y = "b";
                if (string.IsNullOrEmpty(y)) // good: non-constant
                {
                }

                string z = " ";
                if (string.IsNullOrEmpty(z)) // Missing Alert (always false)
                {
                }

                string a = "a";
                if (string.IsNullOrEmpty(a)) // Missing Alert (always false)
                {
                }

                if (args[1] != null)
                    a = "";
                if (string.IsNullOrEmpty(a)) // good: non-constant
                {
                }

                if (string.IsNullOrEmpty(null)) // $ Alert
                {
                }

                if (string.IsNullOrEmpty("")) // $ Alert
                {
                }

                if (string.IsNullOrEmpty(" ")) // $ Alert
                {
                }
            }
        }
    }
}
