// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.HttpOverrides, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class CertificateForwardingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseCertificateForwarding(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
            public static partial class ForwardedHeadersExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseForwardedHeaders(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseForwardedHeaders(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, Microsoft.AspNetCore.Builder.ForwardedHeadersOptions options) => throw null;
            }
            public class ForwardedHeadersOptions
            {
                public System.Collections.Generic.IList<string> AllowedHosts { get => throw null; set { } }
                public ForwardedHeadersOptions() => throw null;
                public string ForwardedForHeaderName { get => throw null; set { } }
                public Microsoft.AspNetCore.HttpOverrides.ForwardedHeaders ForwardedHeaders { get => throw null; set { } }
                public string ForwardedHostHeaderName { get => throw null; set { } }
                public string ForwardedPrefixHeaderName { get => throw null; set { } }
                public string ForwardedProtoHeaderName { get => throw null; set { } }
                public int? ForwardLimit { get => throw null; set { } }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.HttpOverrides.IPNetwork> KnownNetworks { get => throw null; }
                public System.Collections.Generic.IList<System.Net.IPAddress> KnownProxies { get => throw null; }
                public string OriginalForHeaderName { get => throw null; set { } }
                public string OriginalHostHeaderName { get => throw null; set { } }
                public string OriginalPrefixHeaderName { get => throw null; set { } }
                public string OriginalProtoHeaderName { get => throw null; set { } }
                public bool RequireHeaderSymmetry { get => throw null; set { } }
            }
            public static partial class HttpMethodOverrideExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpMethodOverride(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpMethodOverride(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, Microsoft.AspNetCore.Builder.HttpMethodOverrideOptions options) => throw null;
            }
            public class HttpMethodOverrideOptions
            {
                public HttpMethodOverrideOptions() => throw null;
                public string FormFieldName { get => throw null; set { } }
            }
        }
        namespace HttpOverrides
        {
            public class CertificateForwardingMiddleware
            {
                public CertificateForwardingMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpOverrides.CertificateForwardingOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
            }
            public class CertificateForwardingOptions
            {
                public string CertificateHeader { get => throw null; set { } }
                public CertificateForwardingOptions() => throw null;
                public System.Func<string, System.Security.Cryptography.X509Certificates.X509Certificate2> HeaderConverter;
            }
            [System.Flags]
            public enum ForwardedHeaders
            {
                None = 0,
                XForwardedFor = 1,
                XForwardedHost = 2,
                XForwardedProto = 4,
                XForwardedPrefix = 8,
                All = 15,
            }
            public static class ForwardedHeadersDefaults
            {
                public static string XForwardedForHeaderName { get => throw null; }
                public static string XForwardedHostHeaderName { get => throw null; }
                public static string XForwardedPrefixHeaderName { get => throw null; }
                public static string XForwardedProtoHeaderName { get => throw null; }
                public static string XOriginalForHeaderName { get => throw null; }
                public static string XOriginalHostHeaderName { get => throw null; }
                public static string XOriginalPrefixHeaderName { get => throw null; }
                public static string XOriginalProtoHeaderName { get => throw null; }
            }
            public class ForwardedHeadersMiddleware
            {
                public void ApplyForwarders(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public ForwardedHeadersMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.ForwardedHeadersOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
            public class HttpMethodOverrideMiddleware
            {
                public HttpMethodOverrideMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.HttpMethodOverrideOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
            public class IPNetwork
            {
                public bool Contains(System.Net.IPAddress address) => throw null;
                public IPNetwork(System.Net.IPAddress prefix, int prefixLength) => throw null;
                public static Microsoft.AspNetCore.HttpOverrides.IPNetwork Parse(System.ReadOnlySpan<char> networkSpan) => throw null;
                public System.Net.IPAddress Prefix { get => throw null; }
                public int PrefixLength { get => throw null; }
                public static bool TryParse(System.ReadOnlySpan<char> networkSpan, out Microsoft.AspNetCore.HttpOverrides.IPNetwork network) => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class CertificateForwardingServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddCertificateForwarding(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpOverrides.CertificateForwardingOptions> configure) => throw null;
            }
        }
    }
}
