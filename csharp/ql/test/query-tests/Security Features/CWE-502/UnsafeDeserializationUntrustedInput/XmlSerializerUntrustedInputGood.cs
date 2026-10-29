using System.Web.UI.WebControls;
using System.Xml.Serialization;
using System.IO;
using System.Text;
using System;

class GoodXmlSerializer
{
    public static object Deserialize1(TextBox data)
    {
        // GOOD
        var ds = new XmlSerializer(typeof(GoodXmlSerializer));
        return ds.Deserialize(new MemoryStream(Encoding.UTF8.GetBytes(data.Text)));
    }

    public static object Deserialize2(TextBox type)
    {
        var ds = new XmlSerializer(Type.GetType(type.Text));
        // GOOD
        return ds.Deserialize(new MemoryStream(Encoding.UTF8.GetBytes("hardcoded")));
    }
}
