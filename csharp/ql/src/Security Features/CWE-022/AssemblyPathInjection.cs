using System;
using System.Web;
using System.Reflection;

public void ProcessRequest(HttpContext ctx)
{
    string libraryName = ctx.Request.QueryString["libraryName"];

    // BAD: Load DLL based on user input
    var badDLL = Assembly.LoadFile(libraryName);
}