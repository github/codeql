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

    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("sessionID"); // $Alert // BAD: httpOnlyCookies is set to false by default
    }

    void CookieDefaultForgery()
    {
        var cookie = new System.Web.HttpCookie("anticsrftoken"); // GOOD: not an auth cookie
    }

    void CookieForgeryDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("antiforgerytoken");
        cookie.HttpOnly = false; // GOOD: not an auth cookie
    }

    void CookieDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("sessionID"); // $Alert 
        cookie.HttpOnly = false; // BAD
    }

    void CookieDirectFalseInitializer()
    {
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = false };  // $Alert // BAD
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
        var cookie = new System.Web.HttpCookie("sessionID"); // MISSING:Alert 
        bool v = false;
        cookie.HttpOnly = v; // BAD
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookie = new System.Web.HttpCookie("sessionID") { HttpOnly = v };  // $MISSING:Alert // BAD
    }
}
