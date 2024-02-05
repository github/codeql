using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String filename = ctx.Request.QueryString["path"];
        // BAD: This could read any file on the filesystem.
        ctx.Response.Write(File.ReadAllText(filename));
    }
}
