// semmle-extractor-options: /nostdlib /noconfig /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\mscorlib.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.Web.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.dll

using System;
using System.Web;
using System.Reflection;

public class DLLInjectionHandler : IHttpHandler {
  public void ProcessRequest(HttpContext ctx) {
    string libraryName = ctx.Request.QueryString["libraryName"];

    // BAD: Load DLL based on user input
    var badDLL = Assembly.LoadFile(libraryName);

    // GOOD: Load DLL using fixed string
    var goodDLL = Assembly.LoadFile(@"C:\visual studio 2012\Projects\ConsoleApplication1\ConsoleApplication1\DLL.dll");
  }

  public bool IsReusable {
    get {
      return true;
    }
  }
}
