namespace ASP
{
    using System;
    using System.IO;
    using System.Net;
    using System.Web;
    using System.Web.WebPages;

    public class _Page_Views_Home_Contact_cshtml : System.Web.Mvc.WebViewPage<dynamic>
    {
        public _Page_Views_Home_Contact_cshtml()
        {
        }

        public override void Execute()
        {
            Layout = "~/_SiteLayout.cshtml";
            Page.Title = "Contact";
            var sayHi = Request.QueryString["sayHi"]; // $ Source=sayHi
            if (sayHi.IsEmpty())
            {
                WriteLiteral("<script>alert(\"XSS via WriteLiteral\")</script>"); // GOOD: hard-coded, not user input
            }
            else
            {
                WriteLiteral(sayHi); // $ Alert=sayHi
                WriteLiteral(HttpUtility.HtmlEncode(sayHi)); // Good: user input is encoded before it flows to HTML
            }

            if (sayHi.IsEmpty())
            {
                WriteLiteralTo(Output, "<script > alert(\"XSS via WriteLiteralTo\")</script>"); // GOOD: hard-coded, not user input
            }
            else
            {
                WriteLiteralTo(Output, sayHi); // $ Alert=sayHi
                WriteLiteralTo(Output, Html.Encode(sayHi)); // Good: user input is encoded before it flows to HTML
            }

            BeginContext("~/Views/Home/Contact.cshtml", 288, 32, false);

            Write(Html.Raw("<script>alert(\"XSS via Html.Raw()\")</script>")); // GOOD: hard-coded, not user input
            var sayHi2 = Request.QueryString["sayHi"]; // $ Source=sayHi2
            Write(Html.Raw(sayHi2)); // $ Alert=sayHi2
            Write(Html.Raw(HttpContext.Current.Server.HtmlEncode(sayHi2))); // Good: user input is encoded before it flows to HTML
            EndContext("~/Views/Home/Contact.cshtml", 288, 32, false);
        }
    }
}
