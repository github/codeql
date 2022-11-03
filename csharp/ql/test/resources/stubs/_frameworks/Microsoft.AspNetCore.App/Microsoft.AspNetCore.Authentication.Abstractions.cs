// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticateResult` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthenticateResult
            {
                protected AuthenticateResult() => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticateResult Clone() => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(string failureMessage, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(string failureMessage) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(System.Exception failure, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Fail(System.Exception failure) => throw null;
                public System.Exception Failure { get => throw null; set => throw null; }
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult NoResult() => throw null;
                public bool None { get => throw null; set => throw null; }
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
                public bool Succeeded { get => throw null; }
                public static Microsoft.AspNetCore.Authentication.AuthenticateResult Success(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationTicket Ticket { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationHttpContextExtensions` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class AuthenticationHttpContextExtensions
            {
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task ChallengeAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task ForbidAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Http.HttpContext context, string tokenName) => throw null;
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, string tokenName) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task SignInAsync(this Microsoft.AspNetCore.Http.HttpContext context, System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static System.Threading.Tasks.Task SignOutAsync(this Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationOptions` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthenticationOptions
            {
                public void AddScheme<THandler>(string name, string displayName) where THandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler => throw null;
                public void AddScheme(string name, System.Action<Microsoft.AspNetCore.Authentication.AuthenticationSchemeBuilder> configureBuilder) => throw null;
                public AuthenticationOptions() => throw null;
                public string DefaultAuthenticateScheme { get => throw null; set => throw null; }
                public string DefaultChallengeScheme { get => throw null; set => throw null; }
                public string DefaultForbidScheme { get => throw null; set => throw null; }
                public string DefaultScheme { get => throw null; set => throw null; }
                public string DefaultSignInScheme { get => throw null; set => throw null; }
                public string DefaultSignOutScheme { get => throw null; set => throw null; }
                public bool RequireAuthenticatedSignIn { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Authentication.AuthenticationSchemeBuilder> SchemeMap { get => throw null; }
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationSchemeBuilder> Schemes { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationProperties` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthenticationProperties
            {
                public bool? AllowRefresh { get => throw null; set => throw null; }
                public AuthenticationProperties(System.Collections.Generic.IDictionary<string, string> items, System.Collections.Generic.IDictionary<string, object> parameters) => throw null;
                public AuthenticationProperties(System.Collections.Generic.IDictionary<string, string> items) => throw null;
                public AuthenticationProperties() => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Clone() => throw null;
                public System.DateTimeOffset? ExpiresUtc { get => throw null; set => throw null; }
                protected bool? GetBool(string key) => throw null;
                protected System.DateTimeOffset? GetDateTimeOffset(string key) => throw null;
                public T GetParameter<T>(string key) => throw null;
                public string GetString(string key) => throw null;
                public bool IsPersistent { get => throw null; set => throw null; }
                public System.DateTimeOffset? IssuedUtc { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, string> Items { get => throw null; }
                public System.Collections.Generic.IDictionary<string, object> Parameters { get => throw null; }
                public string RedirectUri { get => throw null; set => throw null; }
                protected void SetBool(string key, bool? value) => throw null;
                protected void SetDateTimeOffset(string key, System.DateTimeOffset? value) => throw null;
                public void SetParameter<T>(string key, T value) => throw null;
                public void SetString(string key, string value) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationScheme` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthenticationScheme
            {
                public AuthenticationScheme(string name, string displayName, System.Type handlerType) => throw null;
                public string DisplayName { get => throw null; }
                public System.Type HandlerType { get => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationSchemeBuilder` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthenticationSchemeBuilder
            {
                public AuthenticationSchemeBuilder(string name) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationScheme Build() => throw null;
                public string DisplayName { get => throw null; set => throw null; }
                public System.Type HandlerType { get => throw null; set => throw null; }
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationTicket` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthenticationTicket
            {
                public string AuthenticationScheme { get => throw null; }
                public AuthenticationTicket(System.Security.Claims.ClaimsPrincipal principal, string authenticationScheme) => throw null;
                public AuthenticationTicket(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string authenticationScheme) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationTicket Clone() => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationToken` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AuthenticationToken
            {
                public AuthenticationToken() => throw null;
                public string Name { get => throw null; set => throw null; }
                public string Value { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Authentication.AuthenticationTokenExtensions` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class AuthenticationTokenExtensions
            {
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Authentication.IAuthenticationService auth, Microsoft.AspNetCore.Http.HttpContext context, string tokenName) => throw null;
                public static System.Threading.Tasks.Task<string> GetTokenAsync(this Microsoft.AspNetCore.Authentication.IAuthenticationService auth, Microsoft.AspNetCore.Http.HttpContext context, string scheme, string tokenName) => throw null;
                public static string GetTokenValue(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string tokenName) => throw null;
                public static System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationToken> GetTokens(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static void StoreTokens(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationToken> tokens) => throw null;
                public static bool UpdateTokenValue(this Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string tokenName, string tokenValue) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationFeature` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthenticationFeature
            {
                Microsoft.AspNetCore.Http.PathString OriginalPath { get; set; }
                Microsoft.AspNetCore.Http.PathString OriginalPathBase { get; set; }
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationHandler` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthenticationHandler
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync();
                System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task InitializeAsync(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Http.HttpContext context);
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationHandlerProvider` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthenticationHandlerProvider
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.IAuthenticationHandler> GetHandlerAsync(Microsoft.AspNetCore.Http.HttpContext context, string authenticationScheme);
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationRequestHandler` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthenticationRequestHandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler
            {
                System.Threading.Tasks.Task<bool> HandleRequestAsync();
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
                bool TryAddScheme(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationService` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthenticationService
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme);
                System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task SignInAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                System.Threading.Tasks.Task SignOutAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationSignInHandler` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthenticationSignInHandler : Microsoft.AspNetCore.Authentication.IAuthenticationSignOutHandler, Microsoft.AspNetCore.Authentication.IAuthenticationHandler
            {
                System.Threading.Tasks.Task SignInAsync(System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IAuthenticationSignOutHandler` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IAuthenticationSignOutHandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler
            {
                System.Threading.Tasks.Task SignOutAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
            }

            // Generated from `Microsoft.AspNetCore.Authentication.IClaimsTransformation` in `Microsoft.AspNetCore.Authentication.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IClaimsTransformation
            {
                System.Threading.Tasks.Task<System.Security.Claims.ClaimsPrincipal> TransformAsync(System.Security.Claims.ClaimsPrincipal principal);
            }

        }
    }
}
