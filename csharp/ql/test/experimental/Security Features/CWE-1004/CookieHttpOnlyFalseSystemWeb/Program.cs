// semmle-extractor-options: ${testdir}/../../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

class Program
{
    void CookieDirectTrue()
    {
        var cookie = new System.Web.HttpCookie("sessionID");
        cookie.HttpOnly = true;  // GOOD
    }

    void CookieDirectTrueInitializer()
    {
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = true }; // GOOD
    }

    void CookieForgeryDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("antiforgerytoken");
        cookie.HttpOnly = false; // GOOD: not an auth cookie
    }

    void CookieDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("sessionID");
        cookie.HttpOnly = false; // BAD
    }

    void CookieDirectFalseInitializer()
    {
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = false }; // BAD
    }

    void CookieIntermediateTrue()
    {
        var cookie = new System.Web.HttpCookie("sessionID");
        bool v = true;
        cookie.HttpOnly = v; // GOOD: should track local data flow
    }

    void CookieIntermediateTrueInitializer()
    {
        bool v = true;
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = v }; // GOOD: should track local data flow
    }

    void CookieIntermediateFalse()
    {
        var cookie = new System.Web.HttpCookie("sessionID");
        bool v = false;
        cookie.HttpOnly = v; // BAD
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = v }; // BAD
    }
}
