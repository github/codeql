using System.Web.UI.WebControls;
using System.Runtime.Serialization.Json;
using System.IO;
using System.Text;
using System;

class BadDataContractJsonSerializer
{
    public static object Deserialize(TextBox type, TextBox data)
    {
        var ds = new DataContractJsonSerializer(Type.GetType(type.Text));
        // BAD
        return ds.ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(data.Text)));
    }
}
