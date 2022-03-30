using System.Runtime.Serialization;
using System.IO;
using System;

class BadDataContractSerializer
{
    public static object Deserialize(Type type, Stream s)
    {
        var ds = new DataContractSerializer(type);
        // BAD
        return ds.ReadObject(s);
    }
}
