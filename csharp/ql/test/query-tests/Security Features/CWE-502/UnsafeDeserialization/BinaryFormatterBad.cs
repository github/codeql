using System.Runtime.Serialization.Formatters.Binary;
using System.IO;

class BadBinaryFormatter
{
    public static object Deserialize(Stream s)
    {
        var ds = new BinaryFormatter();
        // BAD
        return ds.Deserialize(s);
    }
}
