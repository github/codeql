using System.Web;

public class HttpHandler : IHttpHandler
{
    string Surname, Forenames, FormattedName;

    public void ProcessRequest(HttpContext ctx)
    {
        string format = ctx.Request.QueryString["nameformat"]; // $ Source

        // BAD: Uncontrolled format string.
        FormattedName = string.Format(format, Surname, Forenames); // $ Alert
    }
}
