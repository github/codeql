using System.Runtime.Serialization.Json;
using System.IO;
using System;

class BadDataContractJsonSerializer
{
    public static object Deserialize(Type type, Stream s)
    {
        var ds = new DataContractJsonSerializer(type);
        // BAD
        return ds.ReadObject(s);
    }
}
