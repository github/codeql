// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.HttpSys, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            public static class WebHostBuilderHttpSysExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseHttpSys(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseHttpSys(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Server.HttpSys.HttpSysOptions> options) => throw null;
            }

        }
        namespace Server
        {
            namespace HttpSys
            {
                public class AuthenticationManager
                {
                    public bool AllowAnonymous { get => throw null; set => throw null; }
                    public string AuthenticationDisplayName { get => throw null; set => throw null; }
                    public bool AutomaticAuthentication { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.AuthenticationSchemes Schemes { get => throw null; set => throw null; }
                }

                [System.Flags]
                public enum AuthenticationSchemes : int
                {
                    Basic = 1,
                    Kerberos = 16,
                    NTLM = 4,
                    Negotiate = 8,
                    None = 0,
                }

                public enum ClientCertificateMethod : int
                {
                    AllowCertificate = 1,
                    AllowRenegotation = 2,
                    NoCertificate = 0,
                }

                public class DelegationRule : System.IDisposable
                {
                    public void Dispose() => throw null;
                    public string QueueName { get => throw null; }
                    public string UrlPrefix { get => throw null; }
                }

                public enum Http503VerbosityLevel : long
                {
                    Basic = 0,
                    Full = 2,
                    Limited = 1,
                }

                public static class HttpSysDefaults
                {
                    public const string AuthenticationScheme = default;
                }

                public class HttpSysException : System.ComponentModel.Win32Exception
                {
                    public override int ErrorCode { get => throw null; }
                }

                public class HttpSysOptions
                {
                    public bool AllowSynchronousIO { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.AuthenticationManager Authentication { get => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.ClientCertificateMethod ClientCertificateMethod { get => throw null; set => throw null; }
                    public bool EnableResponseCaching { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.Http503VerbosityLevel Http503Verbosity { get => throw null; set => throw null; }
                    public HttpSysOptions() => throw null;
                    public int MaxAccepts { get => throw null; set => throw null; }
                    public System.Int64? MaxConnections { get => throw null; set => throw null; }
                    public System.Int64? MaxRequestBodySize { get => throw null; set => throw null; }
                    public System.Int64 RequestQueueLimit { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.RequestQueueMode RequestQueueMode { get => throw null; set => throw null; }
                    public string RequestQueueName { get => throw null; set => throw null; }
                    public bool ThrowWriteExceptions { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.TimeoutManager Timeouts { get => throw null; }
                    public bool UnsafePreferInlineScheduling { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.UrlPrefixCollection UrlPrefixes { get => throw null; }
                    public bool UseLatin1RequestHeaders { get => throw null; set => throw null; }
                }

                public interface IHttpSysRequestDelegationFeature
                {
                    bool CanDelegate { get; }
                    void DelegateRequest(Microsoft.AspNetCore.Server.HttpSys.DelegationRule destination);
                }

                public interface IHttpSysRequestInfoFeature
                {
                    System.Collections.Generic.IReadOnlyDictionary<int, System.ReadOnlyMemory<System.Byte>> RequestInfo { get; }
                }

                public interface IServerDelegationFeature
                {
                    Microsoft.AspNetCore.Server.HttpSys.DelegationRule CreateDelegationRule(string queueName, string urlPrefix);
                }

                public enum RequestQueueMode : int
                {
                    Attach = 1,
                    Create = 0,
                    CreateOrAttach = 2,
                }

                public class TimeoutManager
                {
                    public System.TimeSpan DrainEntityBody { get => throw null; set => throw null; }
                    public System.TimeSpan EntityBody { get => throw null; set => throw null; }
                    public System.TimeSpan HeaderWait { get => throw null; set => throw null; }
                    public System.TimeSpan IdleConnection { get => throw null; set => throw null; }
                    public System.Int64 MinSendBytesPerSecond { get => throw null; set => throw null; }
                    public System.TimeSpan RequestQueue { get => throw null; set => throw null; }
                }

                public class UrlPrefix
                {
                    public static Microsoft.AspNetCore.Server.HttpSys.UrlPrefix Create(string prefix) => throw null;
                    public static Microsoft.AspNetCore.Server.HttpSys.UrlPrefix Create(string scheme, string host, int? portValue, string path) => throw null;
                    public static Microsoft.AspNetCore.Server.HttpSys.UrlPrefix Create(string scheme, string host, string port, string path) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public string FullPrefix { get => throw null; }
                    public override int GetHashCode() => throw null;
                    public string Host { get => throw null; }
                    public bool IsHttps { get => throw null; }
                    public string Path { get => throw null; }
                    public string Port { get => throw null; }
                    public int PortValue { get => throw null; }
                    public string Scheme { get => throw null; }
                    public override string ToString() => throw null;
                }

                public class UrlPrefixCollection : System.Collections.Generic.ICollection<Microsoft.AspNetCore.Server.HttpSys.UrlPrefix>, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Server.HttpSys.UrlPrefix>, System.Collections.IEnumerable
                {
                    public void Add(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix item) => throw null;
                    public void Add(string prefix) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix item) => throw null;
                    public void CopyTo(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix[] array, int arrayIndex) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Server.HttpSys.UrlPrefix> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public bool Remove(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix item) => throw null;
                    public bool Remove(string prefix) => throw null;
                }

            }
        }
    }
}
