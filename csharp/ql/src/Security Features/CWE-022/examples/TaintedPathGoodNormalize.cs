using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string filename = ctx.Request.QueryString["path"];
        // GOOD: ensure that the filename has no path separators or parent directory references
        if (filename.Contains("..") || filename.Contains("/") || filename.Contains("\\"))
        {
            ctx.Response.StatusCode = 400;
            ctx.Response.StatusDescription = "Bad Request";
            ctx.Response.Write("Invalid path");
            return;
        }
        ctx.Response.Write(File.ReadAllText(filename));
    }
}
