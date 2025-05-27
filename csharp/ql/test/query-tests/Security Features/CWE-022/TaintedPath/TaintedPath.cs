using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        String path = ctx.Request.QueryString["page"];
        // BAD: Used via a File.Create... call.
        using (StreamWriter sw = File.CreateText(path))
        {
            sw.WriteLine("Hello");
        }
        // BAD: Used via StreamWriter constructor
        using (StreamWriter sw = new StreamWriter(path))
        {
            sw.WriteLine("Hello");
        }

        // BAD: Check is insufficient, text is read.
        if (!path.StartsWith("../"))
        {
            File.ReadAllText(path);
        }

        // BAD: Check is insufficient, text is read.
        if (!string.IsNullOrEmpty(path))
        {
            File.ReadAllText(path);
        }

        // BAD: Check is insufficient, text is read.
        string badPath = "/home/user/" + path;
        if (File.Exists(badPath))
        {
            ctx.Response.Write(File.ReadAllText(badPath));
        }

        // GOOD: Tainted path is passed through MapPath
        string safePath = ctx.Request.MapPath(path, ctx.Request.ApplicationPath, false);
        File.ReadAllText(safePath);

        // GOOD: Check against explicit paths
        if (path == "foo")
        {
            File.ReadAllText(path);
        }

        Directory.Exists(path);

        // GOOD: A Guid.
        File.ReadAllText(new Guid(path).ToString());

        // GOOD: A simple type.
        File.ReadAllText(int.Parse(path).ToString());

        string fullPath = Path.GetFullPath(path);
        if (fullPath.StartsWith("C:\\Foo"))
        {
            File.ReadAllText(fullPath); // GOOD
        }
        
        // This test ensures that we can flow through `Path.GetFullPath` and still get a result.
        ctx.Response.Write(File.ReadAllText(path)); // BAD

        string absolutePath = ctx.Request.MapPath("~MyTempFile");
        string fullPath2 = Path.Combine(absolutePath, path);
        if (fullPath2.StartsWith(absolutePath + Path.DirectorySeparatorChar)) {
            File.ReadAllText(fullPath2); // GOOD [FALSE POSITIVE]
        }
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
