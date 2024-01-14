using A;
using B;

namespace A
{
    public interface ILogger
    {
        void Log(string s);
    }
}

namespace B
{
    public interface ILogger
    {
        void Log(string s);
    }
}

public class C
{
    public ILogger logger;

    private void M(string s)
    {
        logger.Log(s);
    }

    private static void Main()
    {
        new C().logger.Log("abc");
    }
}