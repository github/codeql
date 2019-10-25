using System;
using System.Web;
using System.Reflection;

public class AssemblyPathInjectionHandler : IHttpHandler {
  public void ProcessRequest(HttpContext ctx) {
    string configType = ctx.Request.QueryString["configType"];

    if (configType.equals("configType1") || configType.equals("configType2")) {
      // GOOD: Loaded assembly is one of the two known safe options
      var safeAssembly = Assembly.LoadFile(@"C:\SafeLibraries\" + configType + ".dll");

      // Code execution is limited to one of two known and vetted assemblies
      MethodInfo m = safeAssembly.GetType("Config").GetMethod("GetCustomPath");
      Object customPath = m.Invoke(null, null);
      // ...
    }
  }
}