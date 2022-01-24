using System;
using System.Web;

public class AddXFrameOptions : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        // GOOD: X-Frame-Options added
        ctx.Response.AddHeader("X-Frame-Options", "DENY");
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
