using System.Resources;
using System.IO;
using System;

class BadResourceReader
{
    public static void Deserialize(Stream s)
    {
        var ds = new ResourceReader(s);
        // BAD
        var dict = ds.GetEnumerator();
        while (dict.MoveNext())
            Console.WriteLine("   {0}: '{1}' (Type {2})", 
                            dict.Key, dict.Value, dict.Value.GetType().Name);
        ds.Close();
    }
}
