using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Web.UI.WebControls;

class BadBinaryFormatter1
{
    public static object Deserialize(TextBox textBox)
    {
        var ds = new BinaryFormatter();
        // BAD
        return ds.Deserialize(new MemoryStream(Encoding.UTF8.GetBytes(textBox.Text))); // $ Alert[cs/unsafe-deserialization-untrusted-input]
    }
}

class BadBinaryFormatter2
{
    public static object Deserialize(TextBox type, TextBox data)
    {
        var ds = new BinaryFormatter();
        // BAD
        return ds.Deserialize(new MemoryStream(Convert.FromBase64String(data.Text))); // $ Alert[cs/unsafe-deserialization-untrusted-input]
    }
}
