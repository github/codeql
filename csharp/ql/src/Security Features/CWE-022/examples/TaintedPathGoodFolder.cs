using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string filename = ctx.Request.QueryString["path"];
        
        string user = ctx.User.Identity.Name;
        string publicFolder = Path.GetFullPath("/home/" + user + "/public");
        string filePath = Path.GetFullPath(Path.Combine(publicFolder, filename));

        // GOOD: ensure that the path stays within the public folder
        if (!filePath.StartsWith(publicFolder + Path.DirectorySeparatorChar))
        {
            ctx.Response.StatusCode = 400;
            ctx.Response.StatusDescription = "Bad Request";
            ctx.Response.Write("Invalid path");
            return;
        }
        ctx.Response.Write(File.ReadAllText(filename));
    }
}
