using System.Runtime.Serialization.Formatters.Binary;
using System.IO;
using System.Text;

class GoodBinaryFormatter
{
    public static object Deserialize()
    {
        var ds = new BinaryFormatter();
        // GOOD
        return ds.Deserialize(new MemoryStream(Encoding.UTF8.GetBytes("hardcoded")));
    }
}
