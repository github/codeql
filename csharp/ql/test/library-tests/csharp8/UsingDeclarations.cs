using System;
using System.IO;

class UsingDeclarations
{
    void TestUsingDeclarations()
    {
        using FileStream file1 = new FileStream("...", FileMode.Open), file2 = new FileStream("...", FileMode.Open);

        using(FileStream file3 = new FileStream("...", FileMode.Open), file4 = new FileStream("...", FileMode.Open))
        {
        }

        using(new FileStream("...", FileMode.Open))
            ;
    }
}
