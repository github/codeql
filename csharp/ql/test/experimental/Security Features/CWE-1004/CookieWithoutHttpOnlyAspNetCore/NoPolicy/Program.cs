// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Http.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Mvc.cs

public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDefault()
    {
        Response.Cookies.Append("auth", "secret"); // BAD: HttpOnly is set to false by default
    }

    public void CookieDefaultForgery()
    {
        Response.Cookies.Append("antiforgerytoken", "secret"); // GOOD: not an auth cookie
    }

    public void CookieDefault2()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD: HttpOnly is set to false by default
    }

    public void CookieDelete()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Delete("auth", cookieOptions); // GOOD: Delete call
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
}
