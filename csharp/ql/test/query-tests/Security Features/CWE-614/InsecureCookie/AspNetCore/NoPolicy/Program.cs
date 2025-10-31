public class MyController : Microsoft.AspNetCore.Mvc.Controller
{
    public void CookieDefault()
    {
        Response.Cookies.Append("name", "value"); // $Alert // BAD: Secure is set to false by default
    }

    public void CookieDefault2()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions(); // $Alert 
        Response.Cookies.Append("name", "value", cookieOptions); // BAD: Secure is set to false by default
    }

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
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions(); // $Alert 
        cookieOptions.Secure = false;
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD
    }

    void CookieDirectFalseInitializer()
    {
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { Secure = false }; // $Alert 
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
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions(); // $MISSING:Alert
        bool v = false;
        cookieOptions.Secure = v;
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD, but not detected
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookieOptions = new Microsoft.AspNetCore.Http.CookieOptions() { Secure = v }; // $MISSING:Alert 
        Response.Cookies.Append("auth", "secret", cookieOptions); // BAD, but not detected
    }
}
