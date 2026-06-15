using System.Threading.Tasks;

namespace ConstantIsNullOrEmpty
{
    internal class Program
    {
        static void Main(string[] args)
        {
            {
                // All of the IsNullOrEmpty constant checks have been descoped
                // from the query as it didn't seem worth the effort to keep them.

                if (string.IsNullOrEmpty(nameof(args))) // Missing Alert (always false)
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

                if (string.IsNullOrEmpty(null)) // Missing Alert
                {
                }

                if (string.IsNullOrEmpty("")) // Missing Alert
                {
                }

                if (string.IsNullOrEmpty(" ")) // Missing Alert
                {
                }
            }
        }
    }
}
