// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

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
}

class ILogger
{
    public void Warn(string message) { }
}
