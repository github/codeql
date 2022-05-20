using System;
using System.Web;
using System.Diagnostics;

public class CommandInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string param = ctx.Request.QueryString["param"];
        Process.Start("process.exe", "/c " + param);
    }
}
