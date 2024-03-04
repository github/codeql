// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Antiforgery, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Antiforgery
        {
            public class AntiforgeryOptions
            {
                public Microsoft.AspNetCore.Http.CookieBuilder Cookie { get => throw null; set { } }
                public AntiforgeryOptions() => throw null;
                public static readonly string DefaultCookiePrefix;
                public string FormFieldName { get => throw null; set { } }
                public string HeaderName { get => throw null; set { } }
                public bool SuppressXFrameOptionsHeader { get => throw null; set { } }
            }
            public class AntiforgeryTokenSet
            {
                public string CookieToken { get => throw null; }
                public AntiforgeryTokenSet(string requestToken, string cookieToken, string formFieldName, string headerName) => throw null;
                public string FormFieldName { get => throw null; }
                public string HeaderName { get => throw null; }
                public string RequestToken { get => throw null; }
            }
            public class AntiforgeryValidationException : System.Exception
            {
                public AntiforgeryValidationException(string message) => throw null;
                public AntiforgeryValidationException(string message, System.Exception innerException) => throw null;
            }
            public interface IAntiforgery
            {
                Microsoft.AspNetCore.Antiforgery.AntiforgeryTokenSet GetAndStoreTokens(Microsoft.AspNetCore.Http.HttpContext httpContext);
                Microsoft.AspNetCore.Antiforgery.AntiforgeryTokenSet GetTokens(Microsoft.AspNetCore.Http.HttpContext httpContext);
                System.Threading.Tasks.Task<bool> IsRequestValidAsync(Microsoft.AspNetCore.Http.HttpContext httpContext);
                void SetCookieTokenAndHeader(Microsoft.AspNetCore.Http.HttpContext httpContext);
                System.Threading.Tasks.Task ValidateRequestAsync(Microsoft.AspNetCore.Http.HttpContext httpContext);
            }
            public interface IAntiforgeryAdditionalDataProvider
            {
                string GetAdditionalData(Microsoft.AspNetCore.Http.HttpContext context);
                bool ValidateAdditionalData(Microsoft.AspNetCore.Http.HttpContext context, string additionalData);
            }
            [System.AttributeUsage((System.AttributeTargets)68)]
            public class RequireAntiforgeryTokenAttribute : System.Attribute, Microsoft.AspNetCore.Antiforgery.IAntiforgeryMetadata
            {
                public RequireAntiforgeryTokenAttribute(bool required = default(bool)) => throw null;
                public bool RequiresValidation { get => throw null; }
            }
        }
        namespace Builder
        {
            public static partial class AntiforgeryApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseAntiforgery(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class AntiforgeryServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAntiforgery(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAntiforgery(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Antiforgery.AntiforgeryOptions> setupAction) => throw null;
            }
        }
    }
}
