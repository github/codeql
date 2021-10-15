class CookieWithOverlyBroadPathFix
{
    static public void AddCookie()
    {
        HttpCookie cookie = new HttpCookie("sessionID");
        cookie.Path = "/ebanking";
    }
}
