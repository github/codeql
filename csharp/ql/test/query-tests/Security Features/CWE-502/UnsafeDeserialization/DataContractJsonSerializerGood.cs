using System.Runtime.Serialization.Json;
using System.IO;
using System;

class GoodDataContractJsonSerializer
{
    public static object Deserialize(Stream s)
    {
        // Good: type is hardcoded
        var ds = new DataContractJsonSerializer(typeof(GoodDataContractJsonSerializer));
        return ds.ReadObject(s);
    }
}
