using System.Web.UI.WebControls;
using System.Xml.Serialization;
using System.IO;
using System.Text;
using System;

class BadXmlSerializer
{
    public static object Deserialize(TextBox type, TextBox data)
    {
        var ds = new XmlSerializer(Type.GetType(type.Text));
        // BAD
        return ds.Deserialize(new MemoryStream(Encoding.UTF8.GetBytes(data.Text)));
    }
}
