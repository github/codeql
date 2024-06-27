// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.HttpsPolicy, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class HstsBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHsts(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
            public static partial class HstsServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHsts(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpsPolicy.HstsOptions> configureOptions) => throw null;
            }
            public static partial class HttpsPolicyBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpsRedirection(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
            public static partial class HttpsRedirectionServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpsRedirection(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions> configureOptions) => throw null;
            }
        }
        namespace HttpsPolicy
        {
            public class HstsMiddleware
            {
                public HstsMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HstsOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public HstsMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HstsOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
            public class HstsOptions
            {
                public HstsOptions() => throw null;
                public System.Collections.Generic.IList<string> ExcludedHosts { get => throw null; }
                public bool IncludeSubDomains { get => throw null; set { } }
                public System.TimeSpan MaxAge { get => throw null; set { } }
                public bool Preload { get => throw null; set { } }
            }
            public class HttpsRedirectionMiddleware
            {
                public HttpsRedirectionMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions> options, Microsoft.Extensions.Configuration.IConfiguration config, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public HttpsRedirectionMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions> options, Microsoft.Extensions.Configuration.IConfiguration config, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Hosting.Server.Features.IServerAddressesFeature serverAddressesFeature) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
            public class HttpsRedirectionOptions
            {
                public HttpsRedirectionOptions() => throw null;
                public int? HttpsPort { get => throw null; set { } }
                public int RedirectStatusCode { get => throw null; set { } }
            }
        }
    }
}
