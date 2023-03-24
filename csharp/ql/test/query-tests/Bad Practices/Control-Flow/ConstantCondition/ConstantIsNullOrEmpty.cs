using System.Threading.Tasks;

namespace ConstantIsNullOrEmpty
{
    internal class Program
    {
        static void Main(string[] args)
        {
            {
                if (string.IsNullOrEmpty(nameof(args))) // bad: always false
                {
                }

                string? x = null;
                if (string.IsNullOrEmpty(x)) // would be nice... bad: always true
                {
                }

                string y = "";
                if (string.IsNullOrEmpty(y)) // would be nice... bad: always true
                {
                }

                if (args[1] != null)
                    y = "b";
                if (string.IsNullOrEmpty(y)) // good: non-constant
                {
                }

                string z = " ";
                if (string.IsNullOrEmpty(z)) // would be nice... bad: always false
                {
                }

                string a = "a";
                if (string.IsNullOrEmpty(a)) // would be nice... bad: always false
                {
                }

                if (args[1] != null)
                    a = "";
                if (string.IsNullOrEmpty(a)) // good: non-constant
                {
                }

                if (string.IsNullOrEmpty(null)) // bad: always true
                {
                }

                if (string.IsNullOrEmpty("")) // bad: always true
                {
                }

                if (string.IsNullOrEmpty(" ")) // bad: always false
                {
                }
            }
        }
    }
}