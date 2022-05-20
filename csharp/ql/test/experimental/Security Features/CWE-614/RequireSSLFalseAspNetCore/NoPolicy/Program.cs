// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Http.cs ${testdir}/../../../../../resources/stubs/Microsoft.AspNetCore.Mvc.cs

public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDelete()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        Response.Cookies.Delete("name", cookieOptions); // GOOD: Delete call
    }

    void CookieDirectTrue()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        cookieOptions.Secure = true;
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD
    }

    void CookieDirectTrueInitializer()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { Secure = true };
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD
    }

    void CookieDirectFalse()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        cookieOptions.Secure = false;
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD
    }

    void CookieDirectFalseInitializer()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { Secure = false };
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD
    }

    void CookieIntermediateTrue()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        bool v = true;
        cookieOptions.Secure = v;
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD: should track local data flow
    }

    void CookieIntermediateTrueInitializer()
    {
        bool v = true;
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { Secure = v };
        Response.Cookies.Append("auth", "secret", cookieOptions); // GOOD: should track local data flow
    }

    void CookieIntermediateFalse()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions();
        bool v = false;
        cookieOptions.Secure = v;
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { Secure = v };
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD
    }
}
