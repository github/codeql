using System;
using System.IO;

class Bad
{
    public bool DoPrint(string s) => true;

    public void IgnoreOne()
    {
        if (DoPrint("A"))
            Console.WriteLine("A");
        if (DoPrint("B"))
            Console.WriteLine("B");
        if (DoPrint("C"))
            Console.WriteLine("C");
        if (DoPrint("D"))
            Console.WriteLine("D");
        if (DoPrint("E"))
            Console.WriteLine("E");
        if (DoPrint("F"))
            Console.WriteLine("F");
        if (DoPrint("G"))
            Console.WriteLine("G");
        if (DoPrint("H"))
            Console.WriteLine("H");
        if (DoPrint("I"))
            Console.WriteLine("I");

        DoPrint("J");
    }

    void IgnoreRead(string path)
    {
        var file = new byte[10];
        using (var f = new FileStream(path, FileMode.Open))
            f.Read(file, 0, file.Length);
    }
}
