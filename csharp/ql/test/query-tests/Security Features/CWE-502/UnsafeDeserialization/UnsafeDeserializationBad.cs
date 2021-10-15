using System.Web.Script.Serialization;

class Bad
{
    public static object Deserialize(string s)
    {
        JavaScriptSerializer sr = new JavaScriptSerializer(new SimpleTypeResolver());
        // BAD
        return sr.DeserializeObject(s);
    }
}
