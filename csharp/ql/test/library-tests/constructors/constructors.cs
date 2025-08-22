namespace Constructors
{
    class Class
    {
        public Class()
        {
        }
        public Class(int i)
        {
        }
        static Class()
        {
        }
        ~Class()
        {
            int i = 0;
        }
    }
}

namespace PrimaryConstructors
{
    public class C1(object o, string s)
    {
        public C1(object o) : this(o, "default") { }
    }

    public class C2(object o, string s, int i) : C1(o, s) { }
}
