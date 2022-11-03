// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            namespace Cookies
            {
                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.ChunkingCookieManager` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ChunkingCookieManager : Microsoft.AspNetCore.Authentication.Cookies.ICookieManager
                {
                    public void AppendResponseCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, string value, Microsoft.AspNetCore.Http.CookieOptions options) => throw null;
                    public int? ChunkSize { get => throw null; set => throw null; }
                    public ChunkingCookieManager() => throw null;
                    public const int DefaultChunkSize = default;
                    public void DeleteCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, Microsoft.AspNetCore.Http.CookieOptions options) => throw null;
                    public string GetRequestCookie(Microsoft.AspNetCore.Http.HttpContext context, string key) => throw null;
                    public bool ThrowForPartialCookies { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationDefaults` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class CookieAuthenticationDefaults
                {
                    public static Microsoft.AspNetCore.Http.PathString AccessDeniedPath;
                    public const string AuthenticationScheme = default;
                    public static string CookiePrefix;
                    public static Microsoft.AspNetCore.Http.PathString LoginPath;
                    public static Microsoft.AspNetCore.Http.PathString LogoutPath;
                    public static string ReturnUrlParameter;
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationEvents` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieAuthenticationEvents
                {
                    public CookieAuthenticationEvents() => throw null;
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToAccessDenied { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToLogin { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToLogout { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>, System.Threading.Tasks.Task> OnRedirectToReturnUrl { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieSignedInContext, System.Threading.Tasks.Task> OnSignedIn { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieSigningInContext, System.Threading.Tasks.Task> OnSigningIn { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieSigningOutContext, System.Threading.Tasks.Task> OnSigningOut { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext, System.Threading.Tasks.Task> OnValidatePrincipal { get => throw null; set => throw null; }
                    public virtual System.Threading.Tasks.Task RedirectToAccessDenied(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task RedirectToLogin(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task RedirectToLogout(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task RedirectToReturnUrl(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> context) => throw null;
                    public virtual System.Threading.Tasks.Task SignedIn(Microsoft.AspNetCore.Authentication.Cookies.CookieSignedInContext context) => throw null;
                    public virtual System.Threading.Tasks.Task SigningIn(Microsoft.AspNetCore.Authentication.Cookies.CookieSigningInContext context) => throw null;
                    public virtual System.Threading.Tasks.Task SigningOut(Microsoft.AspNetCore.Authentication.Cookies.CookieSigningOutContext context) => throw null;
                    public virtual System.Threading.Tasks.Task ValidatePrincipal(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationHandler` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieAuthenticationHandler : Microsoft.AspNetCore.Authentication.SignInAuthenticationHandler<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public CookieAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder), default(Microsoft.AspNetCore.Authentication.ISystemClock)) => throw null;
                    protected override System.Threading.Tasks.Task<object> CreateEventsAsync() => throw null;
                    protected Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationEvents Events { get => throw null; set => throw null; }
                    protected virtual System.Threading.Tasks.Task FinishResponseAsync() => throw null;
                    protected override System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> HandleAuthenticateAsync() => throw null;
                    protected override System.Threading.Tasks.Task HandleChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task HandleForbiddenAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task HandleSignInAsync(System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task HandleSignOutAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task InitializeHandlerAsync() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieAuthenticationOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
                {
                    public Microsoft.AspNetCore.Http.PathString AccessDeniedPath { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.CookieBuilder Cookie { get => throw null; set => throw null; }
                    public CookieAuthenticationOptions() => throw null;
                    public Microsoft.AspNetCore.Authentication.Cookies.ICookieManager CookieManager { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.DataProtection.IDataProtectionProvider DataProtectionProvider { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationEvents Events { get => throw null; set => throw null; }
                    public System.TimeSpan ExpireTimeSpan { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.PathString LoginPath { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.PathString LogoutPath { get => throw null; set => throw null; }
                    public string ReturnUrlParameter { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Authentication.Cookies.ITicketStore SessionStore { get => throw null; set => throw null; }
                    public bool SlidingExpiration { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Authentication.ISecureDataFormat<Microsoft.AspNetCore.Authentication.AuthenticationTicket> TicketDataFormat { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieSignedInContext` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieSignedInContext : Microsoft.AspNetCore.Authentication.PrincipalContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public CookieSignedInContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieSigningInContext` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieSigningInContext : Microsoft.AspNetCore.Authentication.PrincipalContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public Microsoft.AspNetCore.Http.CookieOptions CookieOptions { get => throw null; set => throw null; }
                    public CookieSigningInContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Http.CookieOptions cookieOptions) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieSigningOutContext` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieSigningOutContext : Microsoft.AspNetCore.Authentication.PropertiesContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public Microsoft.AspNetCore.Http.CookieOptions CookieOptions { get => throw null; set => throw null; }
                    public CookieSigningOutContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Http.CookieOptions cookieOptions) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CookieValidatePrincipalContext : Microsoft.AspNetCore.Authentication.PrincipalContext<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public CookieValidatePrincipalContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                    public void RejectPrincipal() => throw null;
                    public void ReplacePrincipal(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                    public bool ShouldRenew { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.ICookieManager` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICookieManager
                {
                    void AppendResponseCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, string value, Microsoft.AspNetCore.Http.CookieOptions options);
                    void DeleteCookie(Microsoft.AspNetCore.Http.HttpContext context, string key, Microsoft.AspNetCore.Http.CookieOptions options);
                    string GetRequestCookie(Microsoft.AspNetCore.Http.HttpContext context, string key);
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.ITicketStore` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITicketStore
                {
                    System.Threading.Tasks.Task RemoveAsync(string key);
                    System.Threading.Tasks.Task RenewAsync(string key, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket);
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationTicket> RetrieveAsync(string key);
                    System.Threading.Tasks.Task<string> StoreAsync(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket);
                }

                // Generated from `Microsoft.AspNetCore.Authentication.Cookies.PostConfigureCookieAuthenticationOptions` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PostConfigureCookieAuthenticationOptions : Microsoft.Extensions.Options.IPostConfigureOptions<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions>
                {
                    public void PostConfigure(string name, Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions options) => throw null;
                    public PostConfigureCookieAuthenticationOptions(Microsoft.AspNetCore.DataProtection.IDataProtectionProvider dataProtection) => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.CookieExtensions` in `Microsoft.AspNetCore.Authentication.Cookies, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class CookieExtensions
            {
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, string displayName, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
            }

        }
    }
}
