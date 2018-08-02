class CookieWithOverlyBroadDomain
{
    static public void AddCookie()
    {
        HttpCookie cookie1 = new HttpCookie("sessionID");
        cookie1.Domain = "online-bank.com";

        HttpCookie cookie2 = new HttpCookie("sessionID");
        cookie2.Domain = ".ebanking.online-bank.com";
    }
}
