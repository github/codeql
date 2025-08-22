using A;
using B;

namespace A
{
    public interface ILogger { }
}

namespace B
{
    public interface ILogger { }
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