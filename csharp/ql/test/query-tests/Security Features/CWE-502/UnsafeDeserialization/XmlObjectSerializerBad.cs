using System.Runtime.Serialization;
using System.IO;
using System;

class BadXmlObjectSerializer
{
    public static object Deserialize(Type type, Stream s)
    {
        XmlObjectSerializer ds = new DataContractSerializer(type);
        // BAD
        return ds.ReadObject(s);
    }
}
