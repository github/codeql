using System.Web.Script.Serialization;

class Good
{
    public static object Deserialize(string s)
    {
        // GOOD
        JavaScriptSerializer sr = new JavaScriptSerializer();
        return sr.DeserializeObject(s);
    }
}
