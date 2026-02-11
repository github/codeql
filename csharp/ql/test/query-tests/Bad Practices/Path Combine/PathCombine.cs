using System.IO;

class PathCombine
{
    void bad()
    {
        Path.Combine(@"C:\Users", @"C:\Program Files");
    }

    void good()
    {
        Path.Join(@"C:\Users", @"C:\Program Files");
    }
}
