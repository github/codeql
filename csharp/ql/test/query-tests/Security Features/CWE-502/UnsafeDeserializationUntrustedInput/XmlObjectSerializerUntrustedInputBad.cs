using System.Web.UI.WebControls;
using System.Runtime.Serialization;
using System.IO;
using System.Text;
using System;

class BadXmlObjectSerializer
{
    public static object Deserialize(TextBox type, TextBox data)
    {
        XmlObjectSerializer ds = new DataContractSerializer(Type.GetType(type.Text));
        // BAD
        return ds.ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(data.Text)));
    }
}
