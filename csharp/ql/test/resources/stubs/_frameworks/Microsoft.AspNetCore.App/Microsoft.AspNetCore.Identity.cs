// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Identity
        {
            // Generated from `Microsoft.AspNetCore.Identity.AspNetRoleManager<>` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AspNetRoleManager<TRole> : Microsoft.AspNetCore.Identity.RoleManager<TRole>, System.IDisposable where TRole : class
            {
                public AspNetRoleManager(Microsoft.AspNetCore.Identity.IRoleStore<TRole> store, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IRoleValidator<TRole>> roleValidators, Microsoft.AspNetCore.Identity.ILookupNormalizer keyNormalizer, Microsoft.AspNetCore.Identity.IdentityErrorDescriber errors, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.RoleManager<TRole>> logger, Microsoft.AspNetCore.Http.IHttpContextAccessor contextAccessor) : base(default(Microsoft.AspNetCore.Identity.IRoleStore<TRole>), default(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IRoleValidator<TRole>>), default(Microsoft.AspNetCore.Identity.ILookupNormalizer), default(Microsoft.AspNetCore.Identity.IdentityErrorDescriber), default(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.RoleManager<TRole>>)) => throw null;
                protected override System.Threading.CancellationToken CancellationToken { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.AspNetUserManager<>` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AspNetUserManager<TUser> : Microsoft.AspNetCore.Identity.UserManager<TUser>, System.IDisposable where TUser : class
            {
                public AspNetUserManager(Microsoft.AspNetCore.Identity.IUserStore<TUser> store, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.IdentityOptions> optionsAccessor, Microsoft.AspNetCore.Identity.IPasswordHasher<TUser> passwordHasher, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IUserValidator<TUser>> userValidators, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IPasswordValidator<TUser>> passwordValidators, Microsoft.AspNetCore.Identity.ILookupNormalizer keyNormalizer, Microsoft.AspNetCore.Identity.IdentityErrorDescriber errors, System.IServiceProvider services, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.UserManager<TUser>> logger) : base(default(Microsoft.AspNetCore.Identity.IUserStore<TUser>), default(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.IdentityOptions>), default(Microsoft.AspNetCore.Identity.IPasswordHasher<TUser>), default(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IUserValidator<TUser>>), default(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IPasswordValidator<TUser>>), default(Microsoft.AspNetCore.Identity.ILookupNormalizer), default(Microsoft.AspNetCore.Identity.IdentityErrorDescriber), default(System.IServiceProvider), default(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.UserManager<TUser>>)) => throw null;
                protected override System.Threading.CancellationToken CancellationToken { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.DataProtectionTokenProviderOptions` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DataProtectionTokenProviderOptions
            {
                public DataProtectionTokenProviderOptions() => throw null;
                public string Name { get => throw null; set => throw null; }
                public System.TimeSpan TokenLifespan { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.DataProtectorTokenProvider<>` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DataProtectorTokenProvider<TUser> : Microsoft.AspNetCore.Identity.IUserTwoFactorTokenProvider<TUser> where TUser : class
            {
                public virtual System.Threading.Tasks.Task<bool> CanGenerateTwoFactorTokenAsync(Microsoft.AspNetCore.Identity.UserManager<TUser> manager, TUser user) => throw null;
                public DataProtectorTokenProvider(Microsoft.AspNetCore.DataProtection.IDataProtectionProvider dataProtectionProvider, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.DataProtectionTokenProviderOptions> options, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.DataProtectorTokenProvider<TUser>> logger) => throw null;
                public virtual System.Threading.Tasks.Task<string> GenerateAsync(string purpose, Microsoft.AspNetCore.Identity.UserManager<TUser> manager, TUser user) => throw null;
                public Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.DataProtectorTokenProvider<TUser>> Logger { get => throw null; }
                public string Name { get => throw null; }
                protected Microsoft.AspNetCore.Identity.DataProtectionTokenProviderOptions Options { get => throw null; }
                protected Microsoft.AspNetCore.DataProtection.IDataProtector Protector { get => throw null; }
                public virtual System.Threading.Tasks.Task<bool> ValidateAsync(string purpose, string token, Microsoft.AspNetCore.Identity.UserManager<TUser> manager, TUser user) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.ExternalLoginInfo` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ExternalLoginInfo : Microsoft.AspNetCore.Identity.UserLoginInfo
            {
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties AuthenticationProperties { get => throw null; set => throw null; }
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationToken> AuthenticationTokens { get => throw null; set => throw null; }
                public ExternalLoginInfo(System.Security.Claims.ClaimsPrincipal principal, string loginProvider, string providerKey, string displayName) : base(default(string), default(string), default(string)) => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.ISecurityStampValidator` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ISecurityStampValidator
            {
                System.Threading.Tasks.Task ValidateAsync(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context);
            }

            // Generated from `Microsoft.AspNetCore.Identity.ITwoFactorSecurityStampValidator` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ITwoFactorSecurityStampValidator : Microsoft.AspNetCore.Identity.ISecurityStampValidator
            {
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityBuilderExtensions` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class IdentityBuilderExtensions
            {
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddDefaultTokenProviders(this Microsoft.AspNetCore.Identity.IdentityBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddSignInManager<TSignInManager>(this Microsoft.AspNetCore.Identity.IdentityBuilder builder) where TSignInManager : class => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddSignInManager(this Microsoft.AspNetCore.Identity.IdentityBuilder builder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityConstants` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityConstants
            {
                public static string ApplicationScheme;
                public static string ExternalScheme;
                public IdentityConstants() => throw null;
                public static string TwoFactorRememberMeScheme;
                public static string TwoFactorUserIdScheme;
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityCookieAuthenticationBuilderExtensions` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class IdentityCookieAuthenticationBuilderExtensions
            {
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddApplicationCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddExternalCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityCookiesBuilder AddIdentityCookies(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, System.Action<Microsoft.AspNetCore.Identity.IdentityCookiesBuilder> configureCookies) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityCookiesBuilder AddIdentityCookies(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddTwoFactorRememberMeCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddTwoFactorUserIdCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityCookiesBuilder` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityCookiesBuilder
            {
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> ApplicationCookie { get => throw null; set => throw null; }
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> ExternalCookie { get => throw null; set => throw null; }
                public IdentityCookiesBuilder() => throw null;
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> TwoFactorRememberMeCookie { get => throw null; set => throw null; }
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> TwoFactorUserIdCookie { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.SecurityStampRefreshingPrincipalContext` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SecurityStampRefreshingPrincipalContext
            {
                public System.Security.Claims.ClaimsPrincipal CurrentPrincipal { get => throw null; set => throw null; }
                public System.Security.Claims.ClaimsPrincipal NewPrincipal { get => throw null; set => throw null; }
                public SecurityStampRefreshingPrincipalContext() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.SecurityStampValidator` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class SecurityStampValidator
            {
                public static System.Threading.Tasks.Task ValidateAsync<TValidator>(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) where TValidator : Microsoft.AspNetCore.Identity.ISecurityStampValidator => throw null;
                public static System.Threading.Tasks.Task ValidatePrincipalAsync(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.SecurityStampValidator<>` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SecurityStampValidator<TUser> : Microsoft.AspNetCore.Identity.ISecurityStampValidator where TUser : class
            {
                public Microsoft.AspNetCore.Authentication.ISystemClock Clock { get => throw null; }
                public Microsoft.Extensions.Logging.ILogger Logger { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions Options { get => throw null; }
                public SecurityStampValidator(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions> options, Microsoft.AspNetCore.Identity.SignInManager<TUser> signInManager, Microsoft.AspNetCore.Authentication.ISystemClock clock, Microsoft.Extensions.Logging.ILoggerFactory logger) => throw null;
                protected virtual System.Threading.Tasks.Task SecurityStampVerified(TUser user, Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                public Microsoft.AspNetCore.Identity.SignInManager<TUser> SignInManager { get => throw null; }
                public virtual System.Threading.Tasks.Task ValidateAsync(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                protected virtual System.Threading.Tasks.Task<TUser> VerifySecurityStamp(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SecurityStampValidatorOptions
            {
                public System.Func<Microsoft.AspNetCore.Identity.SecurityStampRefreshingPrincipalContext, System.Threading.Tasks.Task> OnRefreshingPrincipal { get => throw null; set => throw null; }
                public SecurityStampValidatorOptions() => throw null;
                public System.TimeSpan ValidationInterval { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.SignInManager<>` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SignInManager<TUser> where TUser : class
            {
                public virtual System.Threading.Tasks.Task<bool> CanSignInAsync(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> CheckPasswordSignInAsync(TUser user, string password, bool lockoutOnFailure) => throw null;
                public Microsoft.AspNetCore.Identity.IUserClaimsPrincipalFactory<TUser> ClaimsFactory { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationProperties ConfigureExternalAuthenticationProperties(string provider, string redirectUrl, string userId = default(string)) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; set => throw null; }
                public virtual System.Threading.Tasks.Task<System.Security.Claims.ClaimsPrincipal> CreateUserPrincipalAsync(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> ExternalLoginSignInAsync(string loginProvider, string providerKey, bool isPersistent, bool bypassTwoFactor) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> ExternalLoginSignInAsync(string loginProvider, string providerKey, bool isPersistent) => throw null;
                public virtual System.Threading.Tasks.Task ForgetTwoFactorClientAsync() => throw null;
                public virtual System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationScheme>> GetExternalAuthenticationSchemesAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.ExternalLoginInfo> GetExternalLoginInfoAsync(string expectedXsrf = default(string)) => throw null;
                public virtual System.Threading.Tasks.Task<TUser> GetTwoFactorAuthenticationUserAsync() => throw null;
                protected virtual System.Threading.Tasks.Task<bool> IsLockedOut(TUser user) => throw null;
                public virtual bool IsSignedIn(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public virtual System.Threading.Tasks.Task<bool> IsTwoFactorClientRememberedAsync(TUser user) => throw null;
                protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> LockedOut(TUser user) => throw null;
                public virtual Microsoft.Extensions.Logging.ILogger Logger { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Identity.IdentityOptions Options { get => throw null; set => throw null; }
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> PasswordSignInAsync(string userName, string password, bool isPersistent, bool lockoutOnFailure) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> PasswordSignInAsync(TUser user, string password, bool isPersistent, bool lockoutOnFailure) => throw null;
                protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> PreSignInCheck(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task RefreshSignInAsync(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task RememberTwoFactorClientAsync(TUser user) => throw null;
                protected virtual System.Threading.Tasks.Task ResetLockout(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task SignInAsync(TUser user, bool isPersistent, string authenticationMethod = default(string)) => throw null;
                public virtual System.Threading.Tasks.Task SignInAsync(TUser user, Microsoft.AspNetCore.Authentication.AuthenticationProperties authenticationProperties, string authenticationMethod = default(string)) => throw null;
                public SignInManager(Microsoft.AspNetCore.Identity.UserManager<TUser> userManager, Microsoft.AspNetCore.Http.IHttpContextAccessor contextAccessor, Microsoft.AspNetCore.Identity.IUserClaimsPrincipalFactory<TUser> claimsFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.IdentityOptions> optionsAccessor, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.SignInManager<TUser>> logger, Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider schemes, Microsoft.AspNetCore.Identity.IUserConfirmation<TUser> confirmation) => throw null;
                protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> SignInOrTwoFactorAsync(TUser user, bool isPersistent, string loginProvider = default(string), bool bypassTwoFactor = default(bool)) => throw null;
                public virtual System.Threading.Tasks.Task SignInWithClaimsAsync(TUser user, bool isPersistent, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> additionalClaims) => throw null;
                public virtual System.Threading.Tasks.Task SignInWithClaimsAsync(TUser user, Microsoft.AspNetCore.Authentication.AuthenticationProperties authenticationProperties, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> additionalClaims) => throw null;
                public virtual System.Threading.Tasks.Task SignOutAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> TwoFactorAuthenticatorSignInAsync(string code, bool isPersistent, bool rememberClient) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> TwoFactorRecoveryCodeSignInAsync(string recoveryCode) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> TwoFactorSignInAsync(string provider, string code, bool isPersistent, bool rememberClient) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> UpdateExternalAuthenticationTokensAsync(Microsoft.AspNetCore.Identity.ExternalLoginInfo externalLogin) => throw null;
                public Microsoft.AspNetCore.Identity.UserManager<TUser> UserManager { get => throw null; set => throw null; }
                public virtual System.Threading.Tasks.Task<bool> ValidateSecurityStampAsync(TUser user, string securityStamp) => throw null;
                public virtual System.Threading.Tasks.Task<TUser> ValidateSecurityStampAsync(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public virtual System.Threading.Tasks.Task<TUser> ValidateTwoFactorSecurityStampAsync(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.TwoFactorSecurityStampValidator<>` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class TwoFactorSecurityStampValidator<TUser> : Microsoft.AspNetCore.Identity.SecurityStampValidator<TUser>, Microsoft.AspNetCore.Identity.ITwoFactorSecurityStampValidator, Microsoft.AspNetCore.Identity.ISecurityStampValidator where TUser : class
            {
                protected override System.Threading.Tasks.Task SecurityStampVerified(TUser user, Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                public TwoFactorSecurityStampValidator(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions> options, Microsoft.AspNetCore.Identity.SignInManager<TUser> signInManager, Microsoft.AspNetCore.Authentication.ISystemClock clock, Microsoft.Extensions.Logging.ILoggerFactory logger) : base(default(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions>), default(Microsoft.AspNetCore.Identity.SignInManager<TUser>), default(Microsoft.AspNetCore.Authentication.ISystemClock), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                protected override System.Threading.Tasks.Task<TUser> VerifySecurityStamp(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.IdentityServiceCollectionExtensions` in `Microsoft.AspNetCore.Identity, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60; Microsoft.Extensions.Identity.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static partial class IdentityServiceCollectionExtensions
            {
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddIdentity<TUser, TRole>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Identity.IdentityOptions> setupAction) where TRole : class where TUser : class => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddIdentity<TUser, TRole>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TRole : class where TUser : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureApplicationCookie(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureExternalCookie(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configure) => throw null;
            }

        }
    }
}
