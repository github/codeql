using System;
using System.Web;
using System.Web.UI.WebControls;

public class StackTraceHandler : IHttpHandler
{
    bool b;
    TextBox textBox;

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
            // BAD: implicitly printing a stack trace back to the response
            ctx.Response.Write(ex);
            // BAD: writing StackTrace property to response
            ctx.Response.Write(ex.StackTrace);
            // GOOD: writing Message property to response
            ctx.Response.Write(ex.Message);
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

            textBox.Text = ex.InnerException.StackTrace; // BAD
            textBox.Text = ex.StackTrace; // BAD
            textBox.Text = ex.ToString(); // BAD
            textBox.Text = ex.Message; // GOOD
            return;
        }

        // BAD: printing a stack trace back to the response for a custom exception
        ctx.Response.Write(new MyException().ToString());
    }

    class MyException : Exception
    {
        private Exception nested;
        string ToString()
        {
            // IGNORED - the outer ToString() should be reported, not this nested call
            return nested.ToString();
        }
    }

    // Method that may throw an exception
    public void doSomeWork()
    {
        if (b)
            throw new Exception();
    }

    public void log(string s, Exception e)
    {
        // logging stub
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }
}
