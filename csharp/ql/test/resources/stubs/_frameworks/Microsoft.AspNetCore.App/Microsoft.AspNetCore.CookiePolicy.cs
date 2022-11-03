// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.CookiePolicyAppBuilderExtensions` in `Microsoft.AspNetCore.CookiePolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class CookiePolicyAppBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseCookiePolicy(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.CookiePolicyOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseCookiePolicy(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.CookiePolicyOptions` in `Microsoft.AspNetCore.CookiePolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CookiePolicyOptions
            {
                public System.Func<Microsoft.AspNetCore.Http.HttpContext, bool> CheckConsentNeeded { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.CookieBuilder ConsentCookie { get => throw null; set => throw null; }
                public CookiePolicyOptions() => throw null;
                public Microsoft.AspNetCore.CookiePolicy.HttpOnlyPolicy HttpOnly { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.SameSiteMode MinimumSameSitePolicy { get => throw null; set => throw null; }
                public System.Action<Microsoft.AspNetCore.CookiePolicy.AppendCookieContext> OnAppendCookie { get => throw null; set => throw null; }
                public System.Action<Microsoft.AspNetCore.CookiePolicy.DeleteCookieContext> OnDeleteCookie { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.CookieSecurePolicy Secure { get => throw null; set => throw null; }
            }

        }
        namespace CookiePolicy
        {
            // Generated from `Microsoft.AspNetCore.CookiePolicy.AppendCookieContext` in `Microsoft.AspNetCore.CookiePolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AppendCookieContext
            {
                public AppendCookieContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Http.CookieOptions options, string name, string value) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; }
                public string CookieName { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.CookieOptions CookieOptions { get => throw null; }
                public string CookieValue { get => throw null; set => throw null; }
                public bool HasConsent { get => throw null; }
                public bool IsConsentNeeded { get => throw null; }
                public bool IssueCookie { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.CookiePolicy.CookiePolicyMiddleware` in `Microsoft.AspNetCore.CookiePolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CookiePolicyMiddleware
            {
                public CookiePolicyMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.CookiePolicyOptions> options, Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
                public CookiePolicyMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.CookiePolicyOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public Microsoft.AspNetCore.Builder.CookiePolicyOptions Options { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.CookiePolicy.DeleteCookieContext` in `Microsoft.AspNetCore.CookiePolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DeleteCookieContext
            {
                public Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; }
                public string CookieName { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.CookieOptions CookieOptions { get => throw null; }
                public DeleteCookieContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Http.CookieOptions options, string name) => throw null;
                public bool HasConsent { get => throw null; }
                public bool IsConsentNeeded { get => throw null; }
                public bool IssueCookie { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.CookiePolicy.HttpOnlyPolicy` in `Microsoft.AspNetCore.CookiePolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum HttpOnlyPolicy
            {
                Always,
                None,
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.CookiePolicyServiceCollectionExtensions` in `Microsoft.AspNetCore.CookiePolicy, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class CookiePolicyServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddCookiePolicy<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.CookiePolicyOptions, TService> configureOptions) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddCookiePolicy(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.CookiePolicyOptions> configureOptions) => throw null;
            }

        }
    }
}
