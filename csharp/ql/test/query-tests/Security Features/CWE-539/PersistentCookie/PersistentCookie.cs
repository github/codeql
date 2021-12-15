using System;

class PersistentCookie
{
    void M(System.Web.HttpCookie cookie)
    {
        cookie.Expires = DateTime.Now.AddMonths(12); // BAD
        cookie.Expires = DateTime.Now.AddMinutes(3); // GOOD
        cookie.Expires = DateTime.Now.AddSeconds(301); // BAD
    }
}
