// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.HstsBuilderExtensions` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HstsBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHsts(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.HstsServicesExtensions` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HstsServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHsts(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpsPolicy.HstsOptions> configureOptions) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.HttpsPolicyBuilderExtensions` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpsPolicyBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpsRedirection(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.HttpsRedirectionServicesExtensions` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpsRedirectionServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpsRedirection(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions> configureOptions) => throw null;
            }

        }
        namespace HttpsPolicy
        {
            // Generated from `Microsoft.AspNetCore.HttpsPolicy.HstsMiddleware` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HstsMiddleware
            {
                public HstsMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HstsOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public HstsMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HstsOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HttpsPolicy.HstsOptions` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HstsOptions
            {
                public System.Collections.Generic.IList<string> ExcludedHosts { get => throw null; }
                public HstsOptions() => throw null;
                public bool IncludeSubDomains { get => throw null; set => throw null; }
                public System.TimeSpan MaxAge { get => throw null; set => throw null; }
                public bool Preload { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionMiddleware` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpsRedirectionMiddleware
            {
                public HttpsRedirectionMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions> options, Microsoft.Extensions.Configuration.IConfiguration config, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Hosting.Server.Features.IServerAddressesFeature serverAddressesFeature) => throw null;
                public HttpsRedirectionMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions> options, Microsoft.Extensions.Configuration.IConfiguration config, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionOptions` in `Microsoft.AspNetCore.HttpsPolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpsRedirectionOptions
            {
                public int? HttpsPort { get => throw null; set => throw null; }
                public HttpsRedirectionOptions() => throw null;
                public int RedirectStatusCode { get => throw null; set => throw null; }
            }

        }
    }
}
