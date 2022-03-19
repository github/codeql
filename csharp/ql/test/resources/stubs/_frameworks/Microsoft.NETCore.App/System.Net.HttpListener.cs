// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        // Generated from `System.Net.AuthenticationSchemeSelector` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public delegate System.Net.AuthenticationSchemes AuthenticationSchemeSelector(System.Net.HttpListenerRequest httpRequest);

        // Generated from `System.Net.HttpListener` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListener : System.IDisposable
        {
            // Generated from `System.Net.HttpListener+ExtendedProtectionSelector` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public delegate System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy ExtendedProtectionSelector(System.Net.HttpListenerRequest request);


            public void Abort() => throw null;
            public System.Net.AuthenticationSchemeSelector AuthenticationSchemeSelectorDelegate { get => throw null; set => throw null; }
            public System.Net.AuthenticationSchemes AuthenticationSchemes { get => throw null; set => throw null; }
            public System.IAsyncResult BeginGetContext(System.AsyncCallback callback, object state) => throw null;
            public void Close() => throw null;
            public System.Security.Authentication.ExtendedProtection.ServiceNameCollection DefaultServiceNames { get => throw null; }
            void System.IDisposable.Dispose() => throw null;
            public System.Net.HttpListenerContext EndGetContext(System.IAsyncResult asyncResult) => throw null;
            public System.Security.Authentication.ExtendedProtection.ExtendedProtectionPolicy ExtendedProtectionPolicy { get => throw null; set => throw null; }
            public System.Net.HttpListener.ExtendedProtectionSelector ExtendedProtectionSelectorDelegate { get => throw null; set => throw null; }
            public System.Net.HttpListenerContext GetContext() => throw null;
            public System.Threading.Tasks.Task<System.Net.HttpListenerContext> GetContextAsync() => throw null;
            public HttpListener() => throw null;
            public bool IgnoreWriteExceptions { get => throw null; set => throw null; }
            public bool IsListening { get => throw null; }
            public static bool IsSupported { get => throw null; }
            public System.Net.HttpListenerPrefixCollection Prefixes { get => throw null; }
            public string Realm { get => throw null; set => throw null; }
            public void Start() => throw null;
            public void Stop() => throw null;
            public System.Net.HttpListenerTimeoutManager TimeoutManager { get => throw null; }
            public bool UnsafeConnectionNtlmAuthentication { get => throw null; set => throw null; }
        }

        // Generated from `System.Net.HttpListenerBasicIdentity` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListenerBasicIdentity : System.Security.Principal.GenericIdentity
        {
            public HttpListenerBasicIdentity(string username, string password) : base(default(System.Security.Principal.GenericIdentity)) => throw null;
            public virtual string Password { get => throw null; }
        }

        // Generated from `System.Net.HttpListenerContext` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListenerContext
        {
            public System.Threading.Tasks.Task<System.Net.WebSockets.HttpListenerWebSocketContext> AcceptWebSocketAsync(string subProtocol) => throw null;
            public System.Threading.Tasks.Task<System.Net.WebSockets.HttpListenerWebSocketContext> AcceptWebSocketAsync(string subProtocol, System.TimeSpan keepAliveInterval) => throw null;
            public System.Threading.Tasks.Task<System.Net.WebSockets.HttpListenerWebSocketContext> AcceptWebSocketAsync(string subProtocol, int receiveBufferSize, System.TimeSpan keepAliveInterval) => throw null;
            public System.Threading.Tasks.Task<System.Net.WebSockets.HttpListenerWebSocketContext> AcceptWebSocketAsync(string subProtocol, int receiveBufferSize, System.TimeSpan keepAliveInterval, System.ArraySegment<System.Byte> internalBuffer) => throw null;
            public System.Net.HttpListenerRequest Request { get => throw null; }
            public System.Net.HttpListenerResponse Response { get => throw null; }
            public System.Security.Principal.IPrincipal User { get => throw null; }
        }

        // Generated from `System.Net.HttpListenerException` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListenerException : System.ComponentModel.Win32Exception
        {
            public override int ErrorCode { get => throw null; }
            public HttpListenerException() => throw null;
            protected HttpListenerException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public HttpListenerException(int errorCode) => throw null;
            public HttpListenerException(int errorCode, string message) => throw null;
        }

        // Generated from `System.Net.HttpListenerPrefixCollection` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListenerPrefixCollection : System.Collections.Generic.ICollection<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.IEnumerable
        {
            public void Add(string uriPrefix) => throw null;
            public void Clear() => throw null;
            public bool Contains(string uriPrefix) => throw null;
            public void CopyTo(System.Array array, int offset) => throw null;
            public void CopyTo(string[] array, int offset) => throw null;
            public int Count { get => throw null; }
            public System.Collections.Generic.IEnumerator<string> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            public bool Remove(string uriPrefix) => throw null;
        }

        // Generated from `System.Net.HttpListenerRequest` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListenerRequest
        {
            public string[] AcceptTypes { get => throw null; }
            public System.IAsyncResult BeginGetClientCertificate(System.AsyncCallback requestCallback, object state) => throw null;
            public int ClientCertificateError { get => throw null; }
            public System.Text.Encoding ContentEncoding { get => throw null; }
            public System.Int64 ContentLength64 { get => throw null; }
            public string ContentType { get => throw null; }
            public System.Net.CookieCollection Cookies { get => throw null; }
            public System.Security.Cryptography.X509Certificates.X509Certificate2 EndGetClientCertificate(System.IAsyncResult asyncResult) => throw null;
            public System.Security.Cryptography.X509Certificates.X509Certificate2 GetClientCertificate() => throw null;
            public System.Threading.Tasks.Task<System.Security.Cryptography.X509Certificates.X509Certificate2> GetClientCertificateAsync() => throw null;
            public bool HasEntityBody { get => throw null; }
            public System.Collections.Specialized.NameValueCollection Headers { get => throw null; }
            public string HttpMethod { get => throw null; }
            public System.IO.Stream InputStream { get => throw null; }
            public bool IsAuthenticated { get => throw null; }
            public bool IsLocal { get => throw null; }
            public bool IsSecureConnection { get => throw null; }
            public bool IsWebSocketRequest { get => throw null; }
            public bool KeepAlive { get => throw null; }
            public System.Net.IPEndPoint LocalEndPoint { get => throw null; }
            public System.Version ProtocolVersion { get => throw null; }
            public System.Collections.Specialized.NameValueCollection QueryString { get => throw null; }
            public string RawUrl { get => throw null; }
            public System.Net.IPEndPoint RemoteEndPoint { get => throw null; }
            public System.Guid RequestTraceIdentifier { get => throw null; }
            public string ServiceName { get => throw null; }
            public System.Net.TransportContext TransportContext { get => throw null; }
            public System.Uri Url { get => throw null; }
            public System.Uri UrlReferrer { get => throw null; }
            public string UserAgent { get => throw null; }
            public string UserHostAddress { get => throw null; }
            public string UserHostName { get => throw null; }
            public string[] UserLanguages { get => throw null; }
        }

        // Generated from `System.Net.HttpListenerResponse` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListenerResponse : System.IDisposable
        {
            public void Abort() => throw null;
            public void AddHeader(string name, string value) => throw null;
            public void AppendCookie(System.Net.Cookie cookie) => throw null;
            public void AppendHeader(string name, string value) => throw null;
            public void Close() => throw null;
            public void Close(System.Byte[] responseEntity, bool willBlock) => throw null;
            public System.Text.Encoding ContentEncoding { get => throw null; set => throw null; }
            public System.Int64 ContentLength64 { get => throw null; set => throw null; }
            public string ContentType { get => throw null; set => throw null; }
            public System.Net.CookieCollection Cookies { get => throw null; set => throw null; }
            public void CopyFrom(System.Net.HttpListenerResponse templateResponse) => throw null;
            void System.IDisposable.Dispose() => throw null;
            public System.Net.WebHeaderCollection Headers { get => throw null; set => throw null; }
            public bool KeepAlive { get => throw null; set => throw null; }
            public System.IO.Stream OutputStream { get => throw null; }
            public System.Version ProtocolVersion { get => throw null; set => throw null; }
            public void Redirect(string url) => throw null;
            public string RedirectLocation { get => throw null; set => throw null; }
            public bool SendChunked { get => throw null; set => throw null; }
            public void SetCookie(System.Net.Cookie cookie) => throw null;
            public int StatusCode { get => throw null; set => throw null; }
            public string StatusDescription { get => throw null; set => throw null; }
        }

        // Generated from `System.Net.HttpListenerTimeoutManager` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HttpListenerTimeoutManager
        {
            public System.TimeSpan DrainEntityBody { get => throw null; set => throw null; }
            public System.TimeSpan EntityBody { get => throw null; set => throw null; }
            public System.TimeSpan HeaderWait { get => throw null; set => throw null; }
            public System.TimeSpan IdleConnection { get => throw null; set => throw null; }
            public System.Int64 MinSendBytesPerSecond { get => throw null; set => throw null; }
            public System.TimeSpan RequestQueue { get => throw null; set => throw null; }
        }

        namespace WebSockets
        {
            // Generated from `System.Net.WebSockets.HttpListenerWebSocketContext` in `System.Net.HttpListener, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class HttpListenerWebSocketContext : System.Net.WebSockets.WebSocketContext
            {
                public override System.Net.CookieCollection CookieCollection { get => throw null; }
                public override System.Collections.Specialized.NameValueCollection Headers { get => throw null; }
                public override bool IsAuthenticated { get => throw null; }
                public override bool IsLocal { get => throw null; }
                public override bool IsSecureConnection { get => throw null; }
                public override string Origin { get => throw null; }
                public override System.Uri RequestUri { get => throw null; }
                public override string SecWebSocketKey { get => throw null; }
                public override System.Collections.Generic.IEnumerable<string> SecWebSocketProtocols { get => throw null; }
                public override string SecWebSocketVersion { get => throw null; }
                public override System.Security.Principal.IPrincipal User { get => throw null; }
                public override System.Net.WebSockets.WebSocket WebSocket { get => throw null; }
            }

        }
    }
}
