using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

class Good
{
    public static object Deserialize(TextBox textBox)
    {
        JavaScriptSerializer sr = new JavaScriptSerializer();
        // GOOD: no unsafe type resolver
        return sr.DeserializeObject(textBox.Text);
    }
}
