using System.IO;

class PathCombine
{
    void bad()
    {
        Path.Combine(@"C:\Users", @"C:\Program Files"); // $ Alert
    }

    void good()
    {
        Path.Join(@"C:\Users", @"C:\Program Files");
    }
}
