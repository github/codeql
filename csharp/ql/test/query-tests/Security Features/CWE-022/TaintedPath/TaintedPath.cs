using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        String path = ctx.Request.QueryString["page"]; // $ Source=r1 Source=r2 Source=r3 Source=r4 Source=r5 Source=r6 Source=r7
        // BAD: Used via a File.Create... call.
        using (StreamWriter sw = File.CreateText(path)) // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7
        {
            sw.WriteLine("Hello");
        }
        // BAD: Used via StreamWriter constructor
        using (StreamWriter sw = new StreamWriter(path)) // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7
        {
            sw.WriteLine("Hello");
        }

        // BAD: Check is insufficient, text is read.
        if (!path.StartsWith("../"))
        {
            File.ReadAllText(path); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7
        }

        // BAD: Check is insufficient, text is read.
        if (!string.IsNullOrEmpty(path))
        {
            File.ReadAllText(path); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7
        }

        // BAD: Check is insufficient, text is read.
        string badPath = "/home/user/" + path;
        if (File.Exists(badPath)) // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7
        {
            ctx.Response.Write(File.ReadAllText(badPath)); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7
        }

        // GOOD: Tainted path is passed through MapPath
        string safePath = ctx.Request.MapPath(path, ctx.Request.ApplicationPath, false);
        File.ReadAllText(safePath);

        // GOOD: Check against explicit paths
        if (path == "foo")
        {
            File.ReadAllText(path);
        }

        Directory.Exists(path); // $ Alert=r1 Alert=r2 Alert=r3 Alert=r4 Alert=r5 Alert=r6 Alert=r7

        // GOOD: A Guid.
        File.ReadAllText(new Guid(path).ToString());

        // GOOD: A simple type.
        File.ReadAllText(int.Parse(path).ToString());
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
