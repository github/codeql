using System.Web.Script.Serialization;

class Bad
{
    public static object Deserialize(string s)
    {
        // BAD
        JavaScriptSerializer sr = new JavaScriptSerializer(new SimpleTypeResolver());
        return sr.DeserializeObject(s);
    }
}
