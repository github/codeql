using System.Runtime.Serialization.Json;
using System.IO;
using System;

class BadDataContractJsonSerializer
{
    public static object Deserialize(string type, Stream s)
    {
        // BAD: stream and type are potentially untrusted
        var ds = new DataContractJsonSerializer(Type.GetType(type));
        return ds.ReadObject(s);
    }
}
