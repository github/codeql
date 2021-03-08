using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

class Good
{
    public static object Deserialize(TextBox textBox)
    {
        JavaScriptSerializer sr = new JavaScriptSerializer(new SimpleTypeResolver());
        // GOOD
        return sr.DeserializeObject("hardcoded");
    }
}
