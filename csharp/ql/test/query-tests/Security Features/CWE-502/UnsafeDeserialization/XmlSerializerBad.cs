using System.Xml.Serialization;
using System.IO;
using System;

class BadXmlSerializer
{
    public static object Deserialize(Type type, Stream s)
    {
        var ds = new XmlSerializer(type);
        // BAD
        return ds.Deserialize(s);
    }
}
