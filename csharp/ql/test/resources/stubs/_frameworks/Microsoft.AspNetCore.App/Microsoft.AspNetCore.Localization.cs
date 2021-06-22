// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.ApplicationBuilderExtensions` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestLocalization(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, params string[] cultures) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestLocalization(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Action<Microsoft.AspNetCore.Builder.RequestLocalizationOptions> optionsAction) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestLocalization(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.RequestLocalizationOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestLocalization(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.RequestLocalizationOptions` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequestLocalizationOptions
            {
                public Microsoft.AspNetCore.Builder.RequestLocalizationOptions AddSupportedCultures(params string[] cultures) => throw null;
                public Microsoft.AspNetCore.Builder.RequestLocalizationOptions AddSupportedUICultures(params string[] uiCultures) => throw null;
                public bool ApplyCurrentCultureToResponseHeaders { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Localization.RequestCulture DefaultRequestCulture { get => throw null; set => throw null; }
                public bool FallBackToParentCultures { get => throw null; set => throw null; }
                public bool FallBackToParentUICultures { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Localization.IRequestCultureProvider> RequestCultureProviders { get => throw null; set => throw null; }
                public RequestLocalizationOptions() => throw null;
                public Microsoft.AspNetCore.Builder.RequestLocalizationOptions SetDefaultCulture(string defaultCulture) => throw null;
                public System.Collections.Generic.IList<System.Globalization.CultureInfo> SupportedCultures { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<System.Globalization.CultureInfo> SupportedUICultures { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Builder.RequestLocalizationOptionsExtensions` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RequestLocalizationOptionsExtensions
            {
                public static Microsoft.AspNetCore.Builder.RequestLocalizationOptions AddInitialRequestCultureProvider(this Microsoft.AspNetCore.Builder.RequestLocalizationOptions requestLocalizationOptions, Microsoft.AspNetCore.Localization.RequestCultureProvider requestCultureProvider) => throw null;
            }

        }
        namespace Localization
        {
            // Generated from `Microsoft.AspNetCore.Localization.AcceptLanguageHeaderRequestCultureProvider` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AcceptLanguageHeaderRequestCultureProvider : Microsoft.AspNetCore.Localization.RequestCultureProvider
            {
                public AcceptLanguageHeaderRequestCultureProvider() => throw null;
                public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult> DetermineProviderCultureResult(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public int MaximumAcceptLanguageHeaderValuesToTry { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Localization.CookieRequestCultureProvider` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CookieRequestCultureProvider : Microsoft.AspNetCore.Localization.RequestCultureProvider
            {
                public string CookieName { get => throw null; set => throw null; }
                public CookieRequestCultureProvider() => throw null;
                public static string DefaultCookieName;
                public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult> DetermineProviderCultureResult(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public static string MakeCookieValue(Microsoft.AspNetCore.Localization.RequestCulture requestCulture) => throw null;
                public static Microsoft.AspNetCore.Localization.ProviderCultureResult ParseCookieValue(string value) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Localization.CustomRequestCultureProvider` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CustomRequestCultureProvider : Microsoft.AspNetCore.Localization.RequestCultureProvider
            {
                public CustomRequestCultureProvider(System.Func<Microsoft.AspNetCore.Http.HttpContext, System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult>> provider) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult> DetermineProviderCultureResult(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Localization.IRequestCultureFeature` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRequestCultureFeature
            {
                Microsoft.AspNetCore.Localization.IRequestCultureProvider Provider { get; }
                Microsoft.AspNetCore.Localization.RequestCulture RequestCulture { get; }
            }

            // Generated from `Microsoft.AspNetCore.Localization.IRequestCultureProvider` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRequestCultureProvider
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult> DetermineProviderCultureResult(Microsoft.AspNetCore.Http.HttpContext httpContext);
            }

            // Generated from `Microsoft.AspNetCore.Localization.ProviderCultureResult` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ProviderCultureResult
            {
                public System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> Cultures { get => throw null; }
                public ProviderCultureResult(System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> cultures, System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> uiCultures) => throw null;
                public ProviderCultureResult(System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> cultures) => throw null;
                public ProviderCultureResult(Microsoft.Extensions.Primitives.StringSegment culture, Microsoft.Extensions.Primitives.StringSegment uiCulture) => throw null;
                public ProviderCultureResult(Microsoft.Extensions.Primitives.StringSegment culture) => throw null;
                public System.Collections.Generic.IList<Microsoft.Extensions.Primitives.StringSegment> UICultures { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Localization.QueryStringRequestCultureProvider` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class QueryStringRequestCultureProvider : Microsoft.AspNetCore.Localization.RequestCultureProvider
            {
                public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult> DetermineProviderCultureResult(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public string QueryStringKey { get => throw null; set => throw null; }
                public QueryStringRequestCultureProvider() => throw null;
                public string UIQueryStringKey { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Localization.RequestCulture` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequestCulture
            {
                public System.Globalization.CultureInfo Culture { get => throw null; }
                public RequestCulture(string culture, string uiCulture) => throw null;
                public RequestCulture(string culture) => throw null;
                public RequestCulture(System.Globalization.CultureInfo culture, System.Globalization.CultureInfo uiCulture) => throw null;
                public RequestCulture(System.Globalization.CultureInfo culture) => throw null;
                public System.Globalization.CultureInfo UICulture { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Localization.RequestCultureFeature` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequestCultureFeature : Microsoft.AspNetCore.Localization.IRequestCultureFeature
            {
                public Microsoft.AspNetCore.Localization.IRequestCultureProvider Provider { get => throw null; }
                public Microsoft.AspNetCore.Localization.RequestCulture RequestCulture { get => throw null; }
                public RequestCultureFeature(Microsoft.AspNetCore.Localization.RequestCulture requestCulture, Microsoft.AspNetCore.Localization.IRequestCultureProvider provider) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Localization.RequestCultureProvider` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class RequestCultureProvider : Microsoft.AspNetCore.Localization.IRequestCultureProvider
            {
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult> DetermineProviderCultureResult(Microsoft.AspNetCore.Http.HttpContext httpContext);
                protected static System.Threading.Tasks.Task<Microsoft.AspNetCore.Localization.ProviderCultureResult> NullProviderCultureResult;
                public Microsoft.AspNetCore.Builder.RequestLocalizationOptions Options { get => throw null; set => throw null; }
                protected RequestCultureProvider() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Localization.RequestLocalizationMiddleware` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequestLocalizationMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public RequestLocalizationMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.RequestLocalizationOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.RequestLocalizationServiceCollectionExtensions` in `Microsoft.AspNetCore.Localization, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RequestLocalizationServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestLocalization<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.RequestLocalizationOptions, TService> configureOptions) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestLocalization(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.RequestLocalizationOptions> configureOptions) => throw null;
            }

        }
    }
}
