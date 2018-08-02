// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

using System;
using System.Web;

namespace WebApp
{
    public class Global : HttpApplication
    {
        void Application_Error(object sender, EventArgs e)
        {
            Server.Transfer("HttpErrorPage.aspx");
        }
    }
}
