public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDefault()
    {
        Response.Cookies.Append("auth", "value"); // $Alert // BAD: HttpOnly is set to false by default
    }

    public void CookieDefault2()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions(); // $Alert 
        Response.Cookies.Append("auth", "value", cookieOptions); // BAD: HttpOnly is set to false by default
    }

    public void CookieDelete()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Delete("auth", cookieOptions); // GOOD: Delete call
    }

    void CookieDirectFalseForgery()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        cookieOptions.HttpOnly = false;
        Response.Cookies.Append("antiforgerytoken", "secret", cookieOptions); // GOOD: not an auth cookie
    }

    void CookieDirectTrue()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        cookieOptions.HttpOnly = true;
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD
    }

    void CookieDirectTrueInitializer()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { HttpOnly = true };
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD
    }

    void CookieDirectFalse()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions(); // $Alert 
        cookieOptions.HttpOnly = false;
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD
    }

    void CookieDirectFalseInitializer()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { HttpOnly = false }; // $Alert 
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD
    }

    void CookieIntermediateTrue()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        bool v = true;
        cookieOptions.HttpOnly = v;
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD: should track local data flow
    }

    void CookieIntermediateTrueInitializer()
    {
        bool v = true;
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { HttpOnly = v };
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD: should track local data flow
    }

    void CookieIntermediateFalse()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions(); // $MISSING:Alert
        bool v = false;
        cookieOptions.HttpOnly = v;
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD, but not detected
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { HttpOnly = v }; // $MISSING:Alert 
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD, but not detected
    }
}
