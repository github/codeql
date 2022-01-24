using System.Runtime.Serialization;
using System.IO;
using System;

class GoodDataContractSerializer
{
    public static object Deserialize(Stream s)
    {
        // Good: type is hardcoded
        var ds = new DataContractSerializer(typeof(GoodDataContractSerializer));
        return ds.ReadObject(s);
    }
}
