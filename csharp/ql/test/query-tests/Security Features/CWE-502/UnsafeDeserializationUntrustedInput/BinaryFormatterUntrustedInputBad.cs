using System.Web.UI.WebControls;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;
using System.Text;

class BadBinaryFormatter
{
    public static object Deserialize(TextBox textBox)
    {
        var ds = new BinaryFormatter();
        // BAD
        return ds.Deserialize(new MemoryStream(Encoding.UTF8.GetBytes(textBox.Text)));
    }
}
