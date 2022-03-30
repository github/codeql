using System.IO;
using System;

class ContainerSizeCmpZero
{
    private static FileStream MakeFile(String filename)
    {
        if (filename != null && filename.Length >= 0)
        {
            return File.Create(filename);
        }
        return File.Create("default.name");
    }
}
