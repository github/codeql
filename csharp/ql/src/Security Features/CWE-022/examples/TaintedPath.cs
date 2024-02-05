using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String path = ctx.Request.QueryString["path"];
        // BAD: This could read any file on the filesystem.
        ctx.Response.Write(File.ReadAllText(path));

        // BAD: This could still read any file on the filesystem.
        ctx.Response.Write(File.ReadAllText("/home/user/" + path));

        // GOOD: MapPath ensures the path is safe to read from.
        string safePath = ctx.Request.MapPath(path, ctx.Request.ApplicationPath, false);
        ctx.Response.Write(File.ReadAllText(safePath));
    }
}
