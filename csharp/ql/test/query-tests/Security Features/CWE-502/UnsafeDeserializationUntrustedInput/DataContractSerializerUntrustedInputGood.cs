using System.Web.UI.WebControls;
using System.Runtime.Serialization;
using System.IO;
using System.Text;
using System;

class GoodDataContractSerializer
{
    public static object Deserialize1(TextBox data)
    {
        // GOOD
        var ds = new DataContractSerializer(typeof(GoodDataContractSerializer));
        return ds.ReadObject(new MemoryStream(Encoding.UTF8.GetBytes(data.Text)));
    }

    public static object Deserialize2(TextBox type)
    {
        var ds = new DataContractSerializer(Type.GetType(type.Text));
        // GOOD
        return ds.ReadObject(new MemoryStream(Encoding.UTF8.GetBytes("hardcoded")));
    }
}
