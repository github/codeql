// semmle-extractor-options: /r:System.Dynamic.Runtime.dll /r:System.Runtime.Extensions.dll /r:System.Linq.Expressions.dll
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
            var sayHi = Request.QueryString["sayHi"];
            if (sayHi.IsEmpty())
            {
                WriteLiteral("<script>alert(\"XSS via WriteLiteral\")</script>"); // GOOD: hard-coded, not user input
            }
            else
            {
                WriteLiteral(sayHi); // BAD: user input flows to HTML unencoded
                WriteLiteral(HttpUtility.HtmlEncode(sayHi)); // Good: user input is encoded before it flows to HTML
            }

            if (sayHi.IsEmpty())
            {
                WriteLiteralTo(Output, "<script > alert(\"XSS via WriteLiteralTo\")</script>"); // GOOD: hard-coded, not user input
            }
            else
            {
                WriteLiteralTo(Output, sayHi); // BAD: user input flows to HTML unencoded
                WriteLiteralTo(Output, Html.Encode(sayHi)); // Good: user input is encoded before it flows to HTML
            }

            BeginContext("~/Views/Home/Contact.cshtml", 288, 32, false);

            Write(Html.Raw("<script>alert(\"XSS via Html.Raw()\")</script>")); // GOOD: hard-coded, not user input
            Write(Html.Raw(Request.QueryString["sayHi"])); // BAD: user input flows to HTML unencoded
            Write(Html.Raw(HttpContext.Current.Server.HtmlEncode(Request.QueryString["sayHi"]))); // Good: user input is encoded before it flows to HTML
            EndContext("~/Views/Home/Contact.cshtml", 288, 32, false);
        }
    }
}

// source-extractor-options: /r:${testdir}/../../../../../packages/Microsoft.AspNet.WebPages.3.2.3/lib/net45/System.Web.WebPages.dll /r:${testdir}/../../../../../packages/Microsoft.AspNet.Mvc.5.2.3/lib/net45/System.Web.Mvc.dll /r:System.Dynamic.Runtime.dll /r:System.Runtime.Extensions.dll /r:System.Linq.Expressions.dll /r:System.Web.dll /r:C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Web.dll /r:System.Collections.Specialized.dll
