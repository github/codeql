using System;
using System.Web;
using System.Reflection;

public class AssemblyPathInjectionHandler : IHttpHandler {
  public void ProcessRequest(HttpContext ctx) {
    string assemblyPath = ctx.Request.QueryString["assemblyPath"];

    // BAD: Load assembly based on user input
    var badAssembly = Assembly.LoadFile(assemblyPath);

    // Method called on loaded assembly. If the user can control the loaded assembly, then this
    // could result in a remote code execution vulnerability
    MethodInfo m = badAssembly.GetType("Config").GetMethod("GetCustomPath");
    Object customPath = m.Invoke(null, null);
    // ...
  }
}