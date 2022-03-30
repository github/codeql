using System.Web.UI.WebControls;
using System.Runtime.Serialization.Json;
using System.IO;
using System.Text;
using System;

class GoodDataContractJsonSerializer
{
    public static object Deserialize1(TextBox data)
    {
        // GOOD
        var ds = new DataContractJsonSerializer(typeof(GoodDataContractJsonSerializer));
        return ds.ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(data.Text)));
    }

    public static object Deserialize2(TextBox type)
    {
        var ds = new DataContractJsonSerializer(Type.GetType(type.Text));
        // GOOD
        return ds.ReadObject(new MemoryStream(Encoding.UTF8.GetBytes("hardcoded")));
    }
}
