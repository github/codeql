// semmle-extractor-options: ${testdir}/../../../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll

class Program
{
    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("sessionID"); // BAD: httpOnlyCookies is set to false by default
    }

    void CookieDefaultForgery()
    {
        var cookie = new System.Web.HttpCookie("anticsrftoken"); // GOOD: not an auth cookie
    }

    void CookieDirectTrue()
    {
        var cookie = new System.Web.HttpCookie("sessionID");
        cookie.HttpOnly = true;  // GOOD
    }

    void CookieDirectTrueInitializer()
    {
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = true }; // GOOD
    }

    void CookieDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("sessionID");
        cookie.HttpOnly = false; // GOOD: separate query for setting `false`
    }

    void CookieDirectFalseInitializer()
    {
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = false }; // GOOD: separate query for setting `false`
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
        cookie.HttpOnly = v; // GOOD: separate query for setting `false`
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = v }; // GOOD: separate query for setting `false`
    }
}
