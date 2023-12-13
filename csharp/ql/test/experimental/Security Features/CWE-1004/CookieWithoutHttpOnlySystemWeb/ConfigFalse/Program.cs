class Program
{
    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("sessionID"); // BAD: httpOnlyCookies is set to false in config
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
}
