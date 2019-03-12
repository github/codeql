// semmle-extractor-options: /r:System.Runtime.Extensions.dll /r:System.Collections.Specialized.dll ${testdir}/../../../resources/stubs/System.Web.cs ${testdir}/../../../resources/stubs/System.Windows.cs

using System;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String path = ctx.Request.QueryString["page"];

        // BAD: Uncontrolled format string.
        String.Format(path, "Do not do this");

        // BAD: Using an IFormatProvider.
        String.Format((IFormatProvider)null, path, "Do not do this");

        // GOOD: Not the format string.
        String.Format("Do not do this", path);

        // GOOD: Not the format string.
        String.Format((IFormatProvider)null, "Do not do this", path);
    }

    System.Windows.Forms.TextBox box1;

    void OnButtonClicked()
    {
        // BAD: Uncontrolled format string.
        String.Format(box1.Text, "Do not do this");
    }
}
