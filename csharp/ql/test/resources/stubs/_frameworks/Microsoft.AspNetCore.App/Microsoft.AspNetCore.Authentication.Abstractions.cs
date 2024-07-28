// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Authentication.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            public class AuthenticateResult
            {
                public Microsoft.AspNetCore.Authentication.AuthenticateResult Clone() => throw null;
                protected AuthenticateResult() => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(System.Exception failure) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(System.Exception failure, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(string failureMessage) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(string failureMessage, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public System.Exception Failure { get => throw null; set { } }
                public bool None { get => throw null; set { } }
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult NoResult() => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
                public bool Succeeded { get => throw null; }
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Success(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationTicket Ticket { get => throw null; set { } }
            }
            public class AuthenticationFailureException : System.Exception
            {
                public AuthenticationFailureException(string message) => throw null;
                public AuthenticationFailureException(string message, System.Exception innerException) => throw null;
            }
            public static partial class AuthenticationHttpContextExtensions
            {
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, string tokenName) => throw null;
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Http.HttpContext context, string tokenName) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
            }
            public class AuthenticationOptions
            {
                public void AddScheme(string name, System.Action<Microsoft.AspNetCore.Authentication.AuthenticationSchemeBuilder> configureBuilder) => throw null;
                public void AddScheme<THandler>(string name, string displayName) where THandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler => throw null;
                public AuthenticationOptions() => throw null;
                public string DefaultAuthenticateScheme { get => throw null; set { } }
                public string DefaultChallengeScheme { get => throw null; set { } }
                public string DefaultForbidScheme { get => throw null; set { } }
                public string DefaultScheme { get => throw null; set { } }
                public string DefaultSignInScheme { get => throw null; set { } }
                public string DefaultSignOutScheme { get => throw null; set { } }
                public bool RequireAuthenticatedSignIn { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Authentication.AuthenticationSchemeBuilder> SchemeMap { get => throw null; }
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationSchemeBuilder> Schemes { get => throw null; }
            }
            public class AuthenticationProperties
            {
                public bool? AllowRefresh { get => throw null; set { } }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Clone() => throw null;
                public AuthenticationProperties() => throw null;
                public AuthenticationProperties(System.Collections.Generic.IDictionary<string, string> items) => throw null;
                public AuthenticationProperties(System.Collections.Generic.IDictionary<string, string> items, System.Collections.Generic.IDictionary<string, object> parameters) => throw null;
                public System.DateTimeOffset? ExpiresUtc { get => throw null; set { } }
                protected bool? GetBool(string key) => throw null;
                protected System.DateTimeOffset? GetDateTimeOffset(string key) => throw null;
                public T GetParameter<T>(string key) => throw null;
                public string GetString(string key) => throw null;
                public bool IsPersistent { get => throw null; set { } }
                public System.DateTimeOffset? IssuedUtc { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> Items { get => throw null; }
                public System.Collections.Generic.IDictionary<string, object> Parameters { get => throw null; }
                public string RedirectUri { get => throw null; set { } }
                protected void SetBool(string key, bool? value) => throw null;
                protected void SetDateTimeOffset(string key, System.DateTimeOffset? value) => throw null;
                public void SetParameter<T>(string key, T value) => throw null;
                public void SetString(string key, string value) => throw null;
            }
            public class AuthenticationScheme
            {
                public AuthenticationScheme(string name, string displayName, System.Type handlerType) => throw null;
                public string DisplayName { get => throw null; }
                public System.Type HandlerType { get => throw null; }
                public string Name { get => throw null; }
            }
            public class AuthenticationSchemeBuilder
            {
                public Microsoft.AspNetCore.Authentication.AuthenticationScheme Build() => throw null;
                public AuthenticationSchemeBuilder(string name) => throw null;
                public string DisplayName { get => throw null; set { } }
                public System.Type HandlerType { get => throw null; set { } }
                public string Name { get => throw null; }
            }
            public class AuthenticationTicket
            {
                public string AuthenticationScheme { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationTicket Clone() => throw null;
                public AuthenticationTicket(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string authenticationScheme) => throw null;
                public AuthenticationTicket(System.Security.Claims.ClaimsPrincipal principal, string authenticationScheme) => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; }
            }
            public class AuthenticationToken
            {
                public AuthenticationToken() => throw null;
                public string Name { get => throw null; set { } }
                public string Value { get => throw null; set { } }
            }
            public static partial class AuthenticationTokenExtensions
            {
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Authentication.IAuthenticationService auth, Microsoft.AspNetCore.Http.HttpContext context, string tokenName) => throw null;
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Authentication.IAuthenticationService auth, Microsoft.AspNetCore.Http.HttpContext context, string scheme, string tokenName) => throw null;
                public static System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationToken> GetTokens(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static string GetTokenValue(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string tokenName) => throw null;
                public static void StoreTokens(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationToken> tokens) => throw null;
                public static bool UpdateTokenValue(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string tokenName, string tokenValue) => throw null;
            }
            public interface IAuthenticateResultFeature
            {
                Microsoft.AspNetCore.Authentication.AuthenticateResult AuthenticateResult { get; set; }
            }
            public interface IAuthenticationConfigurationProvider
            {
                Microsoft.Extensions.Configuration.IConfiguration AuthenticationConfiguration { get; }
            }
            public interface IAuthenticationFeature
            {
                Microsoft.AspNetCore.Http.PathString OriginalPath { get; set; }
                Microsoft.AspNetCore.Http.PathString OriginalPathBase { get; set; }
            }
            public interface IAuthenticationHandler
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync();
                System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task InitializeAsync(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Http.HttpContext context);
            }
            public interface IAuthenticationHandlerProvider
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.IAuthenticationHandler> GetHandlerAsync(Microsoft.AspNetCore.Http.HttpContext context, string authenticationScheme);
            }
            public interface IAuthenticationRequestHandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler
            {
                System.Threading.Tasks.Task<bool> HandleRequestAsync();
            }
            public interface IAuthenticationSchemeProvider
            {
                void AddScheme(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme);
                System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationScheme>> GetAllSchemesAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultAuthenticateSchemeAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultChallengeSchemeAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultForbidSchemeAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultSignInSchemeAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultSignOutSchemeAsync();
                System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationScheme>> GetRequestHandlerSchemesAsync();
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetSchemeAsync(string name);
                void RemoveScheme(string name);
                virtual bool TryAddScheme(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme) => throw null;
            }
            public interface IAuthenticationService
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme);
                System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task SignInAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task SignOutAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
            }
            public interface IAuthenticationSignInHandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler, Microsoft.AspNetCore.Authentication.IAuthenticationSignOutHandler
            {
                System.Threading.Tasks.Task SignInAsync(System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
            }
            public interface IAuthenticationSignOutHandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler
            {
                System.Threading.Tasks.Task SignOutAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
            }
            public interface IClaimsTransformation
            {
                System.Threading.Tasks.Task<System.Security.Claims.ClaimsPrincipal> TransformAsync(System.Security.Claims.ClaimsPrincipal principal);
            }
        }
    }
}
