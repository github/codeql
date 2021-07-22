// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            // Generated from `Microsoft.AspNetCore.Hosting.WebHostBuilderHttpSysExtensions` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class WebHostBuilderHttpSysExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseHttpSys(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder, System.Action<Microsoft.AspNetCore.Server.HttpSys.HttpSysOptions> options) => throw null;
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseHttpSys(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) => throw null;
            }

        }
        namespace Server
        {
            namespace HttpSys
            {
                // Generated from `Microsoft.AspNetCore.Server.HttpSys.AuthenticationManager` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthenticationManager
                {
                    public bool AllowAnonymous { get => throw null; set => throw null; }
                    public string AuthenticationDisplayName { get => throw null; set => throw null; }
                    public bool AutomaticAuthentication { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.HttpSys.AuthenticationSchemes Schemes { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.AuthenticationSchemes` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                [System.Flags]
                public enum AuthenticationSchemes
                {
                    Basic,
                    Kerberos,
                    NTLM,
                    Negotiate,
                    None,
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.ClientCertificateMethod` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum ClientCertificateMethod
                {
                    AllowCertificate,
                    AllowRenegotation,
                    NoCertificate,
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.DelegationRule` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DelegationRule : System.IDisposable
                {
                    public void Dispose() => throw null;
                    public string QueueName { get => throw null; }
                    public string UrlPrefix { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.Http503VerbosityLevel` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum Http503VerbosityLevel
                {
                    Basic,
                    Full,
                    Limited,
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.HttpSysDefaults` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HttpSysDefaults
                {
                    public const string AuthenticationScheme = default;
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.HttpSysException` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpSysException : System.ComponentModel.Win32Exception
                {
                    public override int ErrorCode { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.HttpSysOptions` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
                    public Microsoft.AspNetCore.Server.HttpSys.UrlPrefixCollection UrlPrefixes { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.IHttpSysRequestDelegationFeature` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpSysRequestDelegationFeature
                {
                    bool CanDelegate { get; }
                    void DelegateRequest(Microsoft.AspNetCore.Server.HttpSys.DelegationRule destination);
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.IHttpSysRequestInfoFeature` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpSysRequestInfoFeature
                {
                    System.Collections.Generic.IReadOnlyDictionary<int, System.ReadOnlyMemory<System.Byte>> RequestInfo { get; }
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.IServerDelegationFeature` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IServerDelegationFeature
                {
                    Microsoft.AspNetCore.Server.HttpSys.DelegationRule CreateDelegationRule(string queueName, string urlPrefix);
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.RequestQueueMode` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum RequestQueueMode
                {
                    Attach,
                    Create,
                    CreateOrAttach,
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.TimeoutManager` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TimeoutManager
                {
                    public System.TimeSpan DrainEntityBody { get => throw null; set => throw null; }
                    public System.TimeSpan EntityBody { get => throw null; set => throw null; }
                    public System.TimeSpan HeaderWait { get => throw null; set => throw null; }
                    public System.TimeSpan IdleConnection { get => throw null; set => throw null; }
                    public System.Int64 MinSendBytesPerSecond { get => throw null; set => throw null; }
                    public System.TimeSpan RequestQueue { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.UrlPrefix` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UrlPrefix
                {
                    public static Microsoft.AspNetCore.Server.HttpSys.UrlPrefix Create(string scheme, string host, string port, string path) => throw null;
                    public static Microsoft.AspNetCore.Server.HttpSys.UrlPrefix Create(string scheme, string host, int? portValue, string path) => throw null;
                    public static Microsoft.AspNetCore.Server.HttpSys.UrlPrefix Create(string prefix) => throw null;
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

                // Generated from `Microsoft.AspNetCore.Server.HttpSys.UrlPrefixCollection` in `Microsoft.AspNetCore.Server.HttpSys, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UrlPrefixCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Server.HttpSys.UrlPrefix>, System.Collections.Generic.ICollection<Microsoft.AspNetCore.Server.HttpSys.UrlPrefix>
                {
                    public void Add(string prefix) => throw null;
                    public void Add(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix item) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix item) => throw null;
                    public void CopyTo(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix[] array, int arrayIndex) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Server.HttpSys.UrlPrefix> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public bool Remove(string prefix) => throw null;
                    public bool Remove(Microsoft.AspNetCore.Server.HttpSys.UrlPrefix item) => throw null;
                }

            }
        }
    }
}
