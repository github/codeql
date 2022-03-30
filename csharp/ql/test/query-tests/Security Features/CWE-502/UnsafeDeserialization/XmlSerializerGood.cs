using System.Xml.Serialization;
using System.IO;
using System;

class GoodXmlSerializer
{
    public static object Deserialize(Stream s)
    {
        // Good: type is hardcoded
        var ds = new XmlSerializer(typeof(GoodXmlSerializer));
        return ds.Deserialize(s);
    }
}
