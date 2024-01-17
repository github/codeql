class Program
{
    void CookieDirectTrue()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        cookie.Secure = true;  // GOOD
    }

    void CookieDirectTrueInitializer()
    {
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = true }; // GOOD
    }

    void CookieDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        cookie.Secure = false; // BAD
    }

    void CookieDirectFalseInitializer()
    {
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = false }; // BAD
    }

    void CookieIntermediateTrue()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        bool v = true;
        cookie.Secure = v; // GOOD: should track local data flow
    }

    void CookieIntermediateTrueInitializer()
    {
        bool v = true;
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = v }; // GOOD: should track local data flow
    }

    void CookieIntermediateFalse()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        bool v = false;
        cookie.Secure = v; // BAD
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = v }; // BAD
    }
}
