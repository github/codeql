// semmle-extractor-options: /r:${testdir}/../../../../resources/assemblies/System.Web.dll /r:${testdir}/../../../../resources/assemblies/System.Web.Mvc.dll /r:System.Collections.Specialized.dll /r:${testdir}/../../../../resources/assemblies/System.Net.Http.dll
using System;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
namespace Test
{
    class XSS
    {
        TextBox categoryTextBox;
        Calendar calendar;
        Table table;
        Label label;
        string connectionString;
        public Button button;

        public void WebUIXSS()
        {
            // BAD: Reading from textbox, then writing an amended value to a control that does not HTML encode
            StringBuilder userInput = new StringBuilder();
            userInput.AppendFormat("{0} test", categoryTextBox.Text); // $ Source=r1 $ Source=r2 $ Source=r3
            calendar.Caption = userInput.ToString(); // $ Alert=r1 $ Alert=r2 $ Alert=r3
            table.Caption = userInput.ToString(); // $ Alert=r2 $ Alert=r1 $ Alert=r3
            label.Text = userInput.ToString(); // $ Alert=r3 $ Alert=r1 $ Alert=r2

            // GOOD: Reading from textbox, then writing an amended value to a control that does HTML encode
            categoryTextBox.Text = userInput.ToString();
        }

        public void processRequest(HttpContext context)
        {
            // BAD: Read user input from a request, write it straight to a response
            string name = context.Request.QueryString["name"]; // $ Source=r4
            context.Response.Write(name); // $ Alert=r4

            // GOOD: Read user input from a request, but encode it before writing to the response
            string name2 = context.Request.QueryString["name"];
            name2 = HttpUtility.HtmlEncode(name2);
            context.Response.Write(name2);
        }

        public void processNumber(HttpContext context)
        {
            // GOOD: Read user input from a request, but parse it
            string stringCount = context.Request.QueryString["count"];
            int count = int.Parse(stringCount);
            context.Response.Write(count.ToString());
        }

        public void mvcProcess(HttpContext context)
        {
            // BAD: Mimic what happens in cshtml pages
            string name = context.Request.Unvalidated.QueryString["name"]; // $ Source=r5
            HtmlHelper html = new HtmlHelper(null, null);
            html.Raw(name); // $ Alert=r5
        }

        public void listener(HttpContext context)
        {
            // BAD: Writing user input directly to a HttpListenerResponse
            string name = context.Request.Unvalidated.QueryString["name"];
            HttpListener listener = new HttpListener();
            HttpListenerContext listenerContext = listener.GetContext();
            byte[] data = Encoding.ASCII.GetBytes(name);
            listenerContext.Response.OutputStream.Write(data, 0, data.Length);
        }

        public void contextBase(HttpContextBase context)
        {
            // BAD: Writing user input directly to a HttpListenerResponse
            string name = context.Request.QueryString["name"]; // $ Source=r6
            context.Response.Write(name); // $ Alert=r6
            // BAD: Writing user input directly to a HttpListenerResponse
            string name2 = context.Request["name"]; // $ Source=r7
            context.Response.Write(name2); // $ Alert=r7
        }

        public void htmlStrings(HttpContextBase context)
        {
            // BAD: Writing user input into a HtmlString without encoding
            string name = context.Request.QueryString["name"]; // $ Source=r8 $ Source=r9
            new HtmlString(name); // $ Alert=r8 $ Alert=r9
            new MvcHtmlString(name); // $ Alert=r9 $ Alert=r8
            new MyHtmlString(context.Request);
        }

        public void WebContent(HttpContextBase context)
        {
            // BAD: Writing user input into a StringContent without encoding
            string name = context.Request.QueryString["name"]; // $ Source=r10
            new StringContent(name); // $ Alert=r10
        }

        public void HtmlEncoded(HttpContextBase context)
        {
            // GOOD: HTML encoding
            string name = context.Request.QueryString["name"];
            new StringContent(HttpUtility.HtmlEncode(name));

            // GOOD: Implicit HTML encoding
            string html = context.Request.QueryString["html"];
            button.Attributes.Add("data-href", html);
        }

        public void UrlEncoded(HttpContextBase context)
        {
            // GOOD: URL encoding
            string name = context.Request.QueryString["name"];
            new StringContent(HttpUtility.UrlEncode(name));
        }
    }

    class XSSPage : Page
    {
        string someJavascript()
        {
            // actually testing this sink involves putting local paths into the results
            //return Request.QueryString["yolo"];
            return "someJavascript";
        }

        private string Field { get; set; }
    }

    class MyHtmlString : IHtmlString
    {
        private HttpRequestBase Request { get; set; }
        public MyHtmlString(HttpRequestBase request)
        {
            this.Request = request;
        }

        public string ToHtmlString()
        {
            return Request.RawUrl; // $ Alert=r11 $ Alert=r11
        }
    }
}
