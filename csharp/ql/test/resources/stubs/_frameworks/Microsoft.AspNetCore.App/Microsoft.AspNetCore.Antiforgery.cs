// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Antiforgery
        {
            // Generated from `Microsoft.AspNetCore.Antiforgery.AntiforgeryOptions` in `Microsoft.AspNetCore.Antiforgery, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AntiforgeryOptions
            {
                public AntiforgeryOptions() => throw null;
                public Microsoft.AspNetCore.Http.CookieBuilder Cookie { get => throw null; set => throw null; }
                public static string DefaultCookiePrefix;
                public string FormFieldName { get => throw null; set => throw null; }
                public string HeaderName { get => throw null; set => throw null; }
                public bool SuppressXFrameOptionsHeader { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Antiforgery.AntiforgeryTokenSet` in `Microsoft.AspNetCore.Antiforgery, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AntiforgeryTokenSet
            {
                public AntiforgeryTokenSet(string requestToken, string cookieToken, string formFieldName, string headerName) => throw null;
                public string CookieToken { get => throw null; }
                public string FormFieldName { get => throw null; }
                public string HeaderName { get => throw null; }
                public string RequestToken { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Antiforgery.AntiforgeryValidationException` in `Microsoft.AspNetCore.Antiforgery, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AntiforgeryValidationException : System.Exception
            {
                public AntiforgeryValidationException(string message, System.Exception innerException) => throw null;
                public AntiforgeryValidationException(string message) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Antiforgery.IAntiforgery` in `Microsoft.AspNetCore.Antiforgery, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAntiforgery
            {
                Microsoft.AspNetCore.Antiforgery.AntiforgeryTokenSet GetAndStoreTokens(Microsoft.AspNetCore.Http.HttpContext httpContext);
                Microsoft.AspNetCore.Antiforgery.AntiforgeryTokenSet GetTokens(Microsoft.AspNetCore.Http.HttpContext httpContext);
                System.Threading.Tasks.Task<bool> IsRequestValidAsync(Microsoft.AspNetCore.Http.HttpContext httpContext);
                void SetCookieTokenAndHeader(Microsoft.AspNetCore.Http.HttpContext httpContext);
                System.Threading.Tasks.Task ValidateRequestAsync(Microsoft.AspNetCore.Http.HttpContext httpContext);
            }

            // Generated from `Microsoft.AspNetCore.Antiforgery.IAntiforgeryAdditionalDataProvider` in `Microsoft.AspNetCore.Antiforgery, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAntiforgeryAdditionalDataProvider
            {
                string GetAdditionalData(Microsoft.AspNetCore.Http.HttpContext context);
                bool ValidateAdditionalData(Microsoft.AspNetCore.Http.HttpContext context, string additionalData);
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.AntiforgeryServiceCollectionExtensions` in `Microsoft.AspNetCore.Antiforgery, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class AntiforgeryServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAntiforgery(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Antiforgery.AntiforgeryOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAntiforgery(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
