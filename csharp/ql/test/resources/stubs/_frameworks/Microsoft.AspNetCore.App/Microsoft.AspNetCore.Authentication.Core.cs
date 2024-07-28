// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Authentication.Core, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            public class AuthenticationFeature : Microsoft.AspNetCore.Authentication.IAuthenticationFeature
            {
                public AuthenticationFeature() => throw null;
                public Microsoft.AspNetCore.Http.PathString OriginalPath { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.PathString OriginalPathBase { get => throw null; set { } }
            }
            public class AuthenticationHandlerProvider : Microsoft.AspNetCore.Authentication.IAuthenticationHandlerProvider
            {
                public AuthenticationHandlerProvider(Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider schemes) => throw null;
                public System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.IAuthenticationHandler> GetHandlerAsync(Microsoft.AspNetCore.Http.HttpContext context, string authenticationScheme) => throw null;
                public Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider Schemes { get => throw null; }
            }
            public class AuthenticationSchemeProvider : Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider
            {
                public virtual void AddScheme(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme) => throw null;
                public AuthenticationSchemeProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Authentication.AuthenticationOptions> options) => throw null;
                protected AuthenticationSchemeProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Authentication.AuthenticationOptions> options, System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Authentication.AuthenticationScheme> schemes) => throw null;
                public virtual System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationScheme>> GetAllSchemesAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultAuthenticateSchemeAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultChallengeSchemeAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultForbidSchemeAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultSignInSchemeAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetDefaultSignOutSchemeAsync() => throw null;
                public virtual System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationScheme>> GetRequestHandlerSchemesAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationScheme> GetSchemeAsync(string name) => throw null;
                public virtual void RemoveScheme(string name) => throw null;
                public virtual bool TryAddScheme(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme) => throw null;
            }
            public class AuthenticationService : Microsoft.AspNetCore.Authentication.IAuthenticationService
            {
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme) => throw null;
                public virtual System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public AuthenticationService(Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider schemes, Microsoft.AspNetCore.Authentication.IAuthenticationHandlerProvider handlers, Microsoft.AspNetCore.Authentication.IClaimsTransformation transform, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Authentication.AuthenticationOptions> options) => throw null;
                public virtual System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public Microsoft.AspNetCore.Authentication.IAuthenticationHandlerProvider Handlers { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationOptions Options { get => throw null; }
                public Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider Schemes { get => throw null; }
                public virtual System.Threading.Tasks.Task SignInAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public virtual System.Threading.Tasks.Task SignOutAsync(Microsoft.AspNetCore.Http.HttpContext context, string scheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public Microsoft.AspNetCore.Authentication.IClaimsTransformation Transform { get => throw null; }
            }
            public class NoopClaimsTransformation : Microsoft.AspNetCore.Authentication.IClaimsTransformation
            {
                public NoopClaimsTransformation() => throw null;
                public virtual System.Threading.Tasks.Task<System.Security.Claims.ClaimsPrincipal> TransformAsync(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class AuthenticationCoreServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthenticationCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddAuthenticationCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authentication.AuthenticationOptions> configureOptions) => throw null;
            }
        }
    }
}
