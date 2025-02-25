using System.IO;

class EmptyCatchBlock
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
