// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.CertificateForwardingBuilderExtensions` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class CertificateForwardingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseCertificateForwarding(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.ForwardedHeadersExtensions` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ForwardedHeadersExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseForwardedHeaders(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, Microsoft.AspNetCore.Builder.ForwardedHeadersOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseForwardedHeaders(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.ForwardedHeadersOptions` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ForwardedHeadersOptions
            {
                public System.Collections.Generic.IList<string> AllowedHosts { get => throw null; set => throw null; }
                public int? ForwardLimit { get => throw null; set => throw null; }
                public string ForwardedForHeaderName { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.HttpOverrides.ForwardedHeaders ForwardedHeaders { get => throw null; set => throw null; }
                public ForwardedHeadersOptions() => throw null;
                public string ForwardedHostHeaderName { get => throw null; set => throw null; }
                public string ForwardedProtoHeaderName { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.HttpOverrides.IPNetwork> KnownNetworks { get => throw null; }
                public System.Collections.Generic.IList<System.Net.IPAddress> KnownProxies { get => throw null; }
                public string OriginalForHeaderName { get => throw null; set => throw null; }
                public string OriginalHostHeaderName { get => throw null; set => throw null; }
                public string OriginalProtoHeaderName { get => throw null; set => throw null; }
                public bool RequireHeaderSymmetry { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Builder.HttpMethodOverrideExtensions` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpMethodOverrideExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpMethodOverride(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder, Microsoft.AspNetCore.Builder.HttpMethodOverrideOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpMethodOverride(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.HttpMethodOverrideOptions` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpMethodOverrideOptions
            {
                public string FormFieldName { get => throw null; set => throw null; }
                public HttpMethodOverrideOptions() => throw null;
            }

        }
        namespace HttpOverrides
        {
            // Generated from `Microsoft.AspNetCore.HttpOverrides.CertificateForwardingMiddleware` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CertificateForwardingMiddleware
            {
                public CertificateForwardingMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpOverrides.CertificateForwardingOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HttpOverrides.CertificateForwardingOptions` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CertificateForwardingOptions
            {
                public CertificateForwardingOptions() => throw null;
                public string CertificateHeader { get => throw null; set => throw null; }
                public System.Func<string, System.Security.Cryptography.X509Certificates.X509Certificate2> HeaderConverter;
            }

            // Generated from `Microsoft.AspNetCore.HttpOverrides.ForwardedHeaders` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            [System.Flags]
            public enum ForwardedHeaders
            {
                All,
                None,
                XForwardedFor,
                XForwardedHost,
                XForwardedProto,
            }

            // Generated from `Microsoft.AspNetCore.HttpOverrides.ForwardedHeadersDefaults` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ForwardedHeadersDefaults
            {
                public static string XForwardedForHeaderName { get => throw null; }
                public static string XForwardedHostHeaderName { get => throw null; }
                public static string XForwardedProtoHeaderName { get => throw null; }
                public static string XOriginalForHeaderName { get => throw null; }
                public static string XOriginalHostHeaderName { get => throw null; }
                public static string XOriginalProtoHeaderName { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.HttpOverrides.ForwardedHeadersMiddleware` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ForwardedHeadersMiddleware
            {
                public void ApplyForwarders(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public ForwardedHeadersMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.ForwardedHeadersOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HttpOverrides.HttpMethodOverrideMiddleware` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpMethodOverrideMiddleware
            {
                public HttpMethodOverrideMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.HttpMethodOverrideOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HttpOverrides.IPNetwork` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IPNetwork
            {
                public bool Contains(System.Net.IPAddress address) => throw null;
                public IPNetwork(System.Net.IPAddress prefix, int prefixLength) => throw null;
                public System.Net.IPAddress Prefix { get => throw null; }
                public int PrefixLength { get => throw null; }
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.CertificateForwardingServiceExtensions` in `Microsoft.AspNetCore.HttpOverrides, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class CertificateForwardingServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddCertificateForwarding(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpOverrides.CertificateForwardingOptions> configure) => throw null;
            }

        }
    }
}
