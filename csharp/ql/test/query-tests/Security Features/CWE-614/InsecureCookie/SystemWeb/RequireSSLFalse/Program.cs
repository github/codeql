class Program
{
    void CookieDefault()
    {
        var cookie = new System.Web.HttpCookie("cookieName"); // $Alert // BAD: requireSSL is set to false by default
    }

    void CookieDirectTrue()
    {
        var cookie = new System.Web.HttpCookie("cookieName");
        cookie.Secure = true;  // GOOD
    }

    void CookieDirectTrueInitializer()
    {
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = true }; // GOOD
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

    void CookieDirectFalse()
    {
        var cookie = new System.Web.HttpCookie("cookieName"); // $Alert 
        cookie.Secure = false; // BAD
    }

    void CookieDirectFalseInitializer()
    {
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = false }; // $Alert // BAD
    }

        void CookieIntermediateFalse()
    {
        var cookie = new System.Web.HttpCookie("cookieName"); // $MISSING:Alert
        bool v = false;
        cookie.Secure = v; // BAD, but not detected
    }

    void CookieIntermediateFalseInitializer()
    {
        bool v = false;
        var cookie = new System.Web.HttpCookie("cookieName") { Secure = v }; // $MISSING:Alert // BAD, but not detected
    }
}
