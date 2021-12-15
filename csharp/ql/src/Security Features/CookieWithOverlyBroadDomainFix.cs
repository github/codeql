class CookieWithOverlyBroadDomainFix
{
    static public void AddCookie()
    {
        HttpCookie cookie = new HttpCookie("sessionID");
        cookie.Domain = "ebanking.online-bank.com";
    }
}
