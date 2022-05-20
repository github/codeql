using System;
using System.Web;

public class StackTraceHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext ctx)
    {
        try
        {
            doSomeWork();
        }
        catch (Exception ex)
        {
            // BAD: printing a stack trace back to the response
            ctx.Response.Write(ex.ToString());
            return;
        }

        try
        {
            doSomeWork();
        }
        catch (Exception ex)
        {
            // GOOD: log the stack trace, and send back a non-revealing response
            log("Exception occurred", ex);
            ctx.Response.Write("Exception occurred");
            return;
        }
    }
}
