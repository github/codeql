using System;
using System.Text;
using System.IO;
using System.Web;

public class TaintedPathHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        String path = ctx.Request.QueryString["page"]; // $ Source

        // BAD: Uncontrolled format string.
        String.Format(path, "Do not do this"); // $ Alert

        // BAD: Using an IFormatProvider.
        String.Format((IFormatProvider)null, path, "Do not do this"); // $ Alert

        // GOOD: Not the format string.
        String.Format("Do not do this", path);

        // GOOD: Not the format string.
        String.Format((IFormatProvider)null, "Do not do this", path);

        // GOOD: Not a formatting call
        Console.WriteLine(path);

        // BAD: Uncontrolled format string.
        CompositeFormat.Parse(path); // $ Alert
    }

    System.Windows.Forms.TextBox box1;

    void OnButtonClicked()
    {
        // BAD: Uncontrolled format string.
        String.Format(box1.Text, "Do not do this"); // $ Alert
    }
}
