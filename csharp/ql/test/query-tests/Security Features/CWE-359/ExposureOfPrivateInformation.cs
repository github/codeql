using System.Web;

public class Person
{
    public string getTelephone()
    {
        return "";
    }
}

public class ExposureOfPrivateInformationHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // BAD: Setting a cookie value or values with private data.
        ctx.Response.Cookies["MyCookie"].Value = ctx.Request.QueryString["postcode"];
        Person p = new Person();
        ctx.Response.Cookies["MyCookie"].Value = p.getTelephone();

        // BAD: Logging private data
        ILogger logger = new ILogger();
        logger.Warn(p.getTelephone());

        // GOOD: Don't write these values to sensitive locations in the first place
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

    System.Windows.Forms.TextBox postcode;

    void OnButtonClicked()
    {
        ILogger logger = new ILogger();
        logger.Warn(postcode.Text);
    }
}

class ILogger
{
    public void Warn(string message) { }
}
