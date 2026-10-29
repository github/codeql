using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

class Bad
{
    public static object Deserialize(TextBox textBox)
    {
        JavaScriptSerializer sr = new JavaScriptSerializer(new SimpleTypeResolver());
        // BAD
        return sr.DeserializeObject(textBox.Text);
    }
}
