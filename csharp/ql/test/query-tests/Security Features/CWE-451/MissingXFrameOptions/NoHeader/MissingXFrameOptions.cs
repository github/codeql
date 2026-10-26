using System;
using System.Web;

public class AddXFrameOptions : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
