using System;
using System.Web;

namespace System.Web
{
    public class HttpCookie
    {
        public HttpCookie(string name) { }
        public string Value { set { } }
        public DateTime Expires { set { } }
    }
}

namespace PersistentCookie
{
    class Main
    {
        static public void AddCookie()
        {
            HttpCookie aCookie = new HttpCookie("lastVisit");
            aCookie.Value = DateTime.Now.ToString();
            aCookie.Expires = DateTime.Now.AddDays(1);  // BAD
            aCookie.Expires = DateTime.Now.Add(new TimeSpan(1000));  // BAD
            aCookie.Expires = DateTime.Now.AddMinutes(10);  // BAD
            aCookie.Expires = DateTime.Now.AddMinutes(-10.9);  // GOOD
            aCookie.Expires = DateTime.Now.AddSeconds(109);  // GOOD
            aCookie.Expires = DateTime.Now;  // GOOD
        }
    }
}
