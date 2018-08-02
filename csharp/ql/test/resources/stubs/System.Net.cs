
namespace System.Net
{
    class HttpListener : IDisposable
    {
        void IDisposable.Dispose()
        {
        }

        public HttpListenerContext GetContext() => null;
    }

    public class HttpListenerContext
    {
        public HttpListenerResponse Response => null;
    }

    public class HttpListenerResponse
    {
        public System.IO.Stream OutputStream => null;
    }

    public class WebUtility
    {
        public static string UrlEncode(string value) => null;
        public static string UrlDecode(string value) => null;
        public static string HtmlEncode(string value) => null;
    }

    public class IPAddress
    {
        public static IPAddress Parse(string ipString) => null;
    }

    public class IPHostEntry
    {
        public string HostName { get; set; }
    }

    public class Dns
    {
        public static IPHostEntry GetHostByAddress(IPAddress address) => null;
    }
}

namespace System.Net.Http
{
    public class StringContent
    {
        public StringContent(string s) { }
    }
}

namespace System.Net.Mail
{
    public class MailMessage : IDisposable
    {
        public MailMessage(string from, string to, string subject, string body) { }
        void IDisposable.Dispose() { }
        public string Body { get; set; }
        public string Subject { get; set; }
    }
}
