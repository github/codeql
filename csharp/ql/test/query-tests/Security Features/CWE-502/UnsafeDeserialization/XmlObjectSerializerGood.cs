using System.Runtime.Serialization;
using System.IO;
using System;

class GoodXmlObjectSerializer
{
    public static object Deserialize(Stream s)
    {
        // Good: type is hardcoded
        XmlObjectSerializer ds = new DataContractSerializer(typeof(GoodXmlObjectSerializer));
        return ds.ReadObject(s);
    }
}
