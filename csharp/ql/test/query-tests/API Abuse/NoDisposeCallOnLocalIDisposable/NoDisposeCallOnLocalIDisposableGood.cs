using System;
using System.IO;

class Good
{
    long GetLength(string file)
    {
        using (var stream = new FileStream(file, FileMode.Open))
            return stream.Length;
    }
}
