using System.IO;
using System;

class ContainerSizeCmpZero
{
    private static FileStream MakeFile(String filename)
    {
        if (filename != null && !(String.IsNullOrEmpty(filename)))
        {
            return File.Create(filename);
        }
        return File.Create("default.name");
    }
}
