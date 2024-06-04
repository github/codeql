// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Authentication.Cookies, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            namespace Cookies
            {
                public class ChunkingCookieManager : Microsoft.AspNetCore.Authentication.Cookies.ICookieManager
                {
                    public void AppendResponseCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, string value, Microsoft.AspNetCore.Http.CookieOptions options) => throw null;
                    public int? ChunkSize { get => throw null; set { } }
                    public ChunkingCookieManager() => throw null;
                    public const int DefaultChunkSize = 4050;
                    public void DeleteCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, Microsoft.AspNetCore.Http.CookieOptions options) => throw null;
                    public string GetRequestCookie(Microsoft.AspNetCore.Http.HttpContext context, string key) => throw null;
                    public bool ThrowForPartialCookies { get => throw null; set { } }
                }
                public static class CookieAuthenticationDefaults
                {
                    public static readonly Microsoft.AspNetCore.Http.PathString AccessDeniedPath;
                    public const string AuthenticationScheme = default;
                    public static readonly string CookiePrefix;
                    public static readonly Microsoft.AspNetCore.Http.PathString LoginPath;
                    public static readonly Microsoft.AspNetCore.Http.PathString LogoutPath;
                    public static readonly string ReturnUrlParameter;
                }
                public class CookieAuthenticationEvents
                {
                    public virtual System.Threading.Tasks.Task CheckSlidingExpiration(Microsoft.AspNetCore.Authentication.Cookies.CookieSlidingExpirationContext context) => throw null;
                    public CookieAuthenticationEvents() => throw null;
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieSlidingExpirationContext, System.Threading.Tasks.Task> OnCheckSlidingExpiration { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToAccessDenied { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToLogin { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToLogout { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToReturnUrl { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieSignedInContext, System.Threading.Tasks.Task> OnSignedIn { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieSigningInContext, System.Threading.Tasks.Task> OnSigningIn { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieSigningOutContext, System.Threading.Tasks.Task> OnSigningOut { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext, System.Threading.Tasks.Task> OnValidatePrincipal { get => throw null; set { } }
                    public virtual System.Threading.Tasks.Task RedirectToAccessDenied(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task RedirectToLogin(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task RedirectToLogout(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task RedirectToReturnUrl(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task SignedIn(Microsoft.AspNetCore.Authentication.Cookies.CookieSignedInContext context) => throw null;
                    public virtual System.Threading.Tasks.Task SigningIn(Microsoft.AspNetCore.Authentication.Cookies.CookieSigningInContext context) => throw null;
                    public virtual System.Threading.Tasks.Task SigningOut(Microsoft.AspNetCore.Authentication.Cookies.CookieSigningOutContext context) => throw null;
                    public virtual System.Threading.Tasks.Task ValidatePrincipal(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                }
                public class CookieAuthenticationHandler : Microsoft.AspNetCore.Authentication.SignInAuthenticationHandler<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    protected override System.Threading.Tasks.Task<object> CreateEventsAsync() => throw null;
                    public CookieAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                    public CookieAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                    protected Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationEvents Events { get => throw null; set { } }
                    protected virtual System.Threading.Tasks.Task FinishResponseAsync() => throw null;
                    protected override System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> HandleAuthenticateAsync() => throw null;
                    protected override System.Threading.Tasks.Task HandleChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task HandleForbiddenAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task HandleSignInAsync(System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task HandleSignOutAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task InitializeHandlerAsync() => throw null;
                }
                public class CookieAuthenticationOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
                {
                    public Microsoft.AspNetCore.Http.PathString AccessDeniedPath { get => throw null; set { } }
                    public Microsoft.AspNetCore.Http.CookieBuilder Cookie { get => throw null; set { } }
                    public Microsoft.AspNetCore.Authentication.Cookies.ICookieManager CookieManager { get => throw null; set { } }
                    public CookieAuthenticationOptions() => throw null;
                    public Microsoft.AspNetCore.DataProtection.IDataProtectionProvider DataProtectionProvider { get => throw null; set { } }
                    public Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationEvents Events { get => throw null; set { } }
                    public System.TimeSpan ExpireTimeSpan { get => throw null; set { } }
                    public Microsoft.AspNetCore.Http.PathString LoginPath { get => throw null; set { } }
                    public Microsoft.AspNetCore.Http.PathString LogoutPath { get => throw null; set { } }
                    public string ReturnUrlParameter { get => throw null; set { } }
                    public Microsoft.AspNetCore.Authentication.Cookies.ITicketStore SessionStore { get => throw null; set { } }
                    public bool SlidingExpiration { get => throw null; set { } }
                    public Microsoft.AspNetCore.Authentication.ISecureDataFormat<Microsoft.AspNetCore.Authentication.AuthenticationTicket> TicketDataFormat { get => throw null; set { } }
                }
                public class CookieSignedInContext : Microsoft.AspNetCore.Authentication.PrincipalContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public CookieSignedInContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                }
                public class CookieSigningInContext : Microsoft.AspNetCore.Authentication.PrincipalContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public Microsoft.AspNetCore.Http.CookieOptions CookieOptions { get => throw null; set { } }
                    public CookieSigningInContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Http.CookieOptions cookieOptions) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                }
                public class CookieSigningOutContext : Microsoft.AspNetCore.Authentication.PropertiesContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public Microsoft.AspNetCore.Http.CookieOptions CookieOptions { get => throw null; set { } }
                    public CookieSigningOutContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Http.CookieOptions cookieOptions) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                }
                public class CookieSlidingExpirationContext : Microsoft.AspNetCore.Authentication.PrincipalContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public CookieSlidingExpirationContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket, System.TimeSpan elapsedTime, System.TimeSpan remainingTime) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                    public System.TimeSpan ElapsedTime { get => throw null; }
                    public System.TimeSpan RemainingTime { get => throw null; }
                    public bool ShouldRenew { get => throw null; set { } }
                }
                public class CookieValidatePrincipalContext : Microsoft.AspNetCore.Authentication.PrincipalContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public CookieValidatePrincipalContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                    public void RejectPrincipal() => throw null;
                    public void ReplacePrincipal(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                    public bool ShouldRenew { get => throw null; set { } }
                }
                public interface ICookieManager
                {
                    void AppendResponseCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, string value, Microsoft.AspNetCore.Http.CookieOptions options);
                    void DeleteCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, Microsoft.AspNetCore.Http.CookieOptions options);
                    string GetRequestCookie(Microsoft.AspNetCore.Http.HttpContext context, string key);
                }
                public interface ITicketStore
                {
                    System.Threading.Tasks.Task RemoveAsync(string key);
                    virtual System.Threading.Tasks.Task RemoveAsync(string key, System.Threading.CancellationToken cancellationToken) => throw null;
                    virtual System.Threading.Tasks.Task RemoveAsync(string key, Microsoft.AspNetCore.Http.HttpContext httpContext, System.Threading.CancellationToken cancellationToken) => throw null;
                    System.Threading.Tasks.Task RenewAsync(string key, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket);
                    virtual System.Threading.Tasks.Task RenewAsync(string key, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket, System.Threading.CancellationToken cancellationToken) => throw null;
                    virtual System.Threading.Tasks.Task RenewAsync(string key, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket, Microsoft.AspNetCore.Http.HttpContext httpContext, System.Threading.CancellationToken cancellationToken) => throw null;
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationTicket> RetrieveAsync(string key);
                    virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationTicket> RetrieveAsync(string key, System.Threading.CancellationToken cancellationToken) => throw null;
                    virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationTicket> RetrieveAsync(string key, Microsoft.AspNetCore.Http.HttpContext httpContext, System.Threading.CancellationToken cancellationToken) => throw null;
                    System.Threading.Tasks.Task<string> StoreAsync(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket);
                    virtual System.Threading.Tasks.Task<string> StoreAsync(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket, System.Threading.CancellationToken cancellationToken) => throw null;
                    virtual System.Threading.Tasks.Task<string> StoreAsync(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket, Microsoft.AspNetCore.Http.HttpContext httpContext, System.Threading.CancellationToken cancellationToken) => throw null;
                }
                public class PostConfigureCookieAuthenticationOptions : Microsoft.Extensions.Options.IPostConfigureOptions<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public PostConfigureCookieAuthenticationOptions(Microsoft.AspNetCore.DataProtection.IDataProtectionProvider dataProtection) => throw null;
                    public void PostConfigure(string name, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options) => throw null;
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class CookieExtensions
            {
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, string displayName, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configureOptions) => throw null;
            }
        }
    }
}
