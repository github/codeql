using Newtonsoft;
using Newtonsoft.Json;
using System.Web.UI.WebControls;

class Test
{
    public static object Deserialize1(TextBox data)
    {
        return JsonConvert.DeserializeObject(data.Text, new JsonSerializerSettings
        {
            TypeNameHandling = TypeNameHandling.None // OK
        });
    }

    public static object Deserialize2(TextBox data)
    {
        return JsonConvert.DeserializeObject(data.Text, new JsonSerializerSettings // $ Alert[cs/unsafe-deserialization-untrusted-input]
        {
            TypeNameHandling = TypeNameHandling.Auto
        });
    }

    public static object Deserialize(TextBox data)
    {
        return JsonConvert.DeserializeObject(data.Text); // OK, not checking if JsonSerializerSettings is set globally with unsafe settings
    }
}
