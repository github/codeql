using System.Collections.Generic;

class Bad
{
    public static void Main(string[] args)
    {
        var names = GetNames();
        var list = (List<string>) names;
        list.Add("Eve");
    }

    static IEnumerable<string> GetNames()
    {
        var ret = new List<string>()
        {
            "Alice",
            "Bob"
        };
        return ret;
    }
}
