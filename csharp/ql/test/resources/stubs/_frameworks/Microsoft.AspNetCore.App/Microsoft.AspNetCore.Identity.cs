// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Identity, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Identity
        {
            public class AspNetRoleManager<TRole> : Microsoft.AspNetCore.Identity.RoleManager<TRole>, System.IDisposable where TRole : class
            {
                protected override System.Threading.CancellationToken CancellationToken { get => throw null; }
                public AspNetRoleManager(Microsoft.AspNetCore.Identity.IRoleStore<TRole> store, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IRoleValidator<TRole>> roleValidators, Microsoft.AspNetCore.Identity.ILookupNormalizer keyNormalizer, Microsoft.AspNetCore.Identity.IdentityErrorDescriber errors, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.RoleManager<TRole>> logger, Microsoft.AspNetCore.Http.IHttpContextAccessor contextAccessor) : base(default(Microsoft.AspNetCore.Identity.IRoleStore<TRole>), default(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IRoleValidator<TRole>>), default(Microsoft.AspNetCore.Identity.ILookupNormalizer), default(Microsoft.AspNetCore.Identity.IdentityErrorDescriber), default(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.RoleManager<TRole>>)) => throw null;
            }
            public class AspNetUserManager<TUser> : Microsoft.AspNetCore.Identity.UserManager<TUser>, System.IDisposable where TUser : class
            {
                protected override System.Threading.CancellationToken CancellationToken { get => throw null; }
                public AspNetUserManager(Microsoft.AspNetCore.Identity.IUserStore<TUser> store, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.IdentityOptions> optionsAccessor, Microsoft.AspNetCore.Identity.IPasswordHasher<TUser> passwordHasher, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IUserValidator<TUser>> userValidators, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IPasswordValidator<TUser>> passwordValidators, Microsoft.AspNetCore.Identity.ILookupNormalizer keyNormalizer, Microsoft.AspNetCore.Identity.IdentityErrorDescriber errors, System.IServiceProvider services, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.UserManager<TUser>> logger) : base(default(Microsoft.AspNetCore.Identity.IUserStore<TUser>), default(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.IdentityOptions>), default(Microsoft.AspNetCore.Identity.IPasswordHasher<TUser>), default(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IUserValidator<TUser>>), default(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Identity.IPasswordValidator<TUser>>), default(Microsoft.AspNetCore.Identity.ILookupNormalizer), default(Microsoft.AspNetCore.Identity.IdentityErrorDescriber), default(System.IServiceProvider), default(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.UserManager<TUser>>)) => throw null;
            }
            namespace Data
            {
                public sealed class ForgotPasswordRequest
                {
                    public ForgotPasswordRequest() => throw null;
                    public string Email { get => throw null; set { } }
                }
                public sealed class InfoRequest
                {
                    public InfoRequest() => throw null;
                    public string NewEmail { get => throw null; set { } }
                    public string NewPassword { get => throw null; set { } }
                    public string OldPassword { get => throw null; set { } }
                }
                public sealed class InfoResponse
                {
                    public InfoResponse() => throw null;
                    public string Email { get => throw null; set { } }
                    public bool IsEmailConfirmed { get => throw null; set { } }
                }
                public sealed class LoginRequest
                {
                    public LoginRequest() => throw null;
                    public string Email { get => throw null; set { } }
                    public string Password { get => throw null; set { } }
                    public string TwoFactorCode { get => throw null; set { } }
                    public string TwoFactorRecoveryCode { get => throw null; set { } }
                }
                public sealed class RefreshRequest
                {
                    public RefreshRequest() => throw null;
                    public string RefreshToken { get => throw null; set { } }
                }
                public sealed class RegisterRequest
                {
                    public RegisterRequest() => throw null;
                    public string Email { get => throw null; set { } }
                    public string Password { get => throw null; set { } }
                }
                public sealed class ResendConfirmationEmailRequest
                {
                    public ResendConfirmationEmailRequest() => throw null;
                    public string Email { get => throw null; set { } }
                }
                public sealed class ResetPasswordRequest
                {
                    public ResetPasswordRequest() => throw null;
                    public string Email { get => throw null; set { } }
                    public string NewPassword { get => throw null; set { } }
                    public string ResetCode { get => throw null; set { } }
                }
                public sealed class TwoFactorRequest
                {
                    public TwoFactorRequest() => throw null;
                    public bool? Enable { get => throw null; set { } }
                    public bool ForgetMachine { get => throw null; set { } }
                    public bool ResetRecoveryCodes { get => throw null; set { } }
                    public bool ResetSharedKey { get => throw null; set { } }
                    public string TwoFactorCode { get => throw null; set { } }
                }
                public sealed class TwoFactorResponse
                {
                    public TwoFactorResponse() => throw null;
                    public bool IsMachineRemembered { get => throw null; set { } }
                    public bool IsTwoFactorEnabled { get => throw null; set { } }
                    public string[] RecoveryCodes { get => throw null; set { } }
                    public int RecoveryCodesLeft { get => throw null; set { } }
                    public string SharedKey { get => throw null; set { } }
                }
            }
            public class DataProtectionTokenProviderOptions
            {
                public DataProtectionTokenProviderOptions() => throw null;
                public string Name { get => throw null; set { } }
                public System.TimeSpan TokenLifespan { get => throw null; set { } }
            }
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
            public class ExternalLoginInfo : Microsoft.AspNetCore.Identity.UserLoginInfo
            {
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties AuthenticationProperties { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationToken> AuthenticationTokens { get => throw null; set { } }
                public ExternalLoginInfo(System.Security.Claims.ClaimsPrincipal principal, string loginProvider, string providerKey, string displayName) : base(default(string), default(string), default(string)) => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set { } }
            }
            public static partial class IdentityBuilderExtensions
            {
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddApiEndpoints(this Microsoft.AspNetCore.Identity.IdentityBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddDefaultTokenProviders(this Microsoft.AspNetCore.Identity.IdentityBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddSignInManager(this Microsoft.AspNetCore.Identity.IdentityBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddSignInManager<TSignInManager>(this Microsoft.AspNetCore.Identity.IdentityBuilder builder) where TSignInManager : class => throw null;
            }
            public class IdentityConstants
            {
                public static readonly string ApplicationScheme;
                public static readonly string BearerScheme;
                public IdentityConstants() => throw null;
                public static readonly string ExternalScheme;
                public static readonly string TwoFactorRememberMeScheme;
                public static readonly string TwoFactorUserIdScheme;
            }
            public static partial class IdentityCookieAuthenticationBuilderExtensions
            {
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddApplicationCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddExternalCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityCookiesBuilder AddIdentityCookies(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityCookiesBuilder AddIdentityCookies(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, System.Action<Microsoft.AspNetCore.Identity.IdentityCookiesBuilder> configureCookies) => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddTwoFactorRememberMeCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
                public static Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> AddTwoFactorUserIdCookie(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder) => throw null;
            }
            public class IdentityCookiesBuilder
            {
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> ApplicationCookie { get => throw null; set { } }
                public IdentityCookiesBuilder() => throw null;
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> ExternalCookie { get => throw null; set { } }
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> TwoFactorRememberMeCookie { get => throw null; set { } }
                public Microsoft.Extensions.Options.OptionsBuilder<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> TwoFactorUserIdCookie { get => throw null; set { } }
            }
            public interface IEmailSender<TUser> where TUser : class
            {
                System.Threading.Tasks.Task SendConfirmationLinkAsync(TUser user, string email, string confirmationLink);
                System.Threading.Tasks.Task SendPasswordResetCodeAsync(TUser user, string email, string resetCode);
                System.Threading.Tasks.Task SendPasswordResetLinkAsync(TUser user, string email, string resetLink);
            }
            public interface ISecurityStampValidator
            {
                System.Threading.Tasks.Task ValidateAsync(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context);
            }
            public interface ITwoFactorSecurityStampValidator : Microsoft.AspNetCore.Identity.ISecurityStampValidator
            {
            }
            public class SecurityStampRefreshingPrincipalContext
            {
                public SecurityStampRefreshingPrincipalContext() => throw null;
                public System.Security.Claims.ClaimsPrincipal CurrentPrincipal { get => throw null; set { } }
                public System.Security.Claims.ClaimsPrincipal NewPrincipal { get => throw null; set { } }
            }
            public class SecurityStampValidator<TUser> : Microsoft.AspNetCore.Identity.ISecurityStampValidator where TUser : class
            {
                public Microsoft.AspNetCore.Authentication.ISystemClock Clock { get => throw null; }
                public SecurityStampValidator(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions> options, Microsoft.AspNetCore.Identity.SignInManager<TUser> signInManager, Microsoft.AspNetCore.Authentication.ISystemClock clock, Microsoft.Extensions.Logging.ILoggerFactory logger) => throw null;
                public SecurityStampValidator(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions> options, Microsoft.AspNetCore.Identity.SignInManager<TUser> signInManager, Microsoft.Extensions.Logging.ILoggerFactory logger) => throw null;
                public Microsoft.Extensions.Logging.ILogger Logger { get => throw null; set { } }
                public Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions Options { get => throw null; }
                protected virtual System.Threading.Tasks.Task SecurityStampVerified(TUser user, Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                public Microsoft.AspNetCore.Identity.SignInManager<TUser> SignInManager { get => throw null; }
                public System.TimeProvider TimeProvider { get => throw null; }
                public virtual System.Threading.Tasks.Task ValidateAsync(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                protected virtual System.Threading.Tasks.Task<TUser> VerifySecurityStamp(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }
            public static class SecurityStampValidator
            {
                public static System.Threading.Tasks.Task ValidateAsync<TValidator>(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) where TValidator : Microsoft.AspNetCore.Identity.ISecurityStampValidator => throw null;
                public static System.Threading.Tasks.Task ValidatePrincipalAsync(Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
            }
            public class SecurityStampValidatorOptions
            {
                public SecurityStampValidatorOptions() => throw null;
                public System.Func<Microsoft.AspNetCore.Identity.SecurityStampRefreshingPrincipalContext, System.Threading.Tasks.Task> OnRefreshingPrincipal { get => throw null; set { } }
                public System.TimeProvider TimeProvider { get => throw null; set { } }
                public System.TimeSpan ValidationInterval { get => throw null; set { } }
            }
            public class SignInManager<TUser> where TUser : class
            {
                public string AuthenticationScheme { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task<bool> CanSignInAsync(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> CheckPasswordSignInAsync(TUser user, string password, bool lockoutOnFailure) => throw null;
                public Microsoft.AspNetCore.Identity.IUserClaimsPrincipalFactory<TUser> ClaimsFactory { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationProperties ConfigureExternalAuthenticationProperties(string provider, string redirectUrl, string userId = default(string)) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task<System.Security.Claims.ClaimsPrincipal> CreateUserPrincipalAsync(TUser user) => throw null;
                public SignInManager(Microsoft.AspNetCore.Identity.UserManager<TUser> userManager, Microsoft.AspNetCore.Http.IHttpContextAccessor contextAccessor, Microsoft.AspNetCore.Identity.IUserClaimsPrincipalFactory<TUser> claimsFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.IdentityOptions> optionsAccessor, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Identity.SignInManager<TUser>> logger, Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider schemes, Microsoft.AspNetCore.Identity.IUserConfirmation<TUser> confirmation) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> ExternalLoginSignInAsync(string loginProvider, string providerKey, bool isPersistent) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> ExternalLoginSignInAsync(string loginProvider, string providerKey, bool isPersistent, bool bypassTwoFactor) => throw null;
                public virtual System.Threading.Tasks.Task ForgetTwoFactorClientAsync() => throw null;
                public virtual System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.AuthenticationScheme>> GetExternalAuthenticationSchemesAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.ExternalLoginInfo> GetExternalLoginInfoAsync(string expectedXsrf = default(string)) => throw null;
                public virtual System.Threading.Tasks.Task<TUser> GetTwoFactorAuthenticationUserAsync() => throw null;
                protected virtual System.Threading.Tasks.Task<bool> IsLockedOut(TUser user) => throw null;
                public virtual bool IsSignedIn(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public virtual System.Threading.Tasks.Task<bool> IsTwoFactorClientRememberedAsync(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task<bool> IsTwoFactorEnabledAsync(TUser user) => throw null;
                protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> LockedOut(TUser user) => throw null;
                public virtual Microsoft.Extensions.Logging.ILogger Logger { get => throw null; set { } }
                public Microsoft.AspNetCore.Identity.IdentityOptions Options { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> PasswordSignInAsync(TUser user, string password, bool isPersistent, bool lockoutOnFailure) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> PasswordSignInAsync(string userName, string password, bool isPersistent, bool lockoutOnFailure) => throw null;
                protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> PreSignInCheck(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task RefreshSignInAsync(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task RememberTwoFactorClientAsync(TUser user) => throw null;
                protected virtual System.Threading.Tasks.Task ResetLockout(TUser user) => throw null;
                public virtual System.Threading.Tasks.Task SignInAsync(TUser user, bool isPersistent, string authenticationMethod = default(string)) => throw null;
                public virtual System.Threading.Tasks.Task SignInAsync(TUser user, Microsoft.AspNetCore.Authentication.AuthenticationProperties authenticationProperties, string authenticationMethod = default(string)) => throw null;
                protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> SignInOrTwoFactorAsync(TUser user, bool isPersistent, string loginProvider = default(string), bool bypassTwoFactor = default(bool)) => throw null;
                public virtual System.Threading.Tasks.Task SignInWithClaimsAsync(TUser user, bool isPersistent, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> additionalClaims) => throw null;
                public virtual System.Threading.Tasks.Task SignInWithClaimsAsync(TUser user, Microsoft.AspNetCore.Authentication.AuthenticationProperties authenticationProperties, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> additionalClaims) => throw null;
                public virtual System.Threading.Tasks.Task SignOutAsync() => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> TwoFactorAuthenticatorSignInAsync(string code, bool isPersistent, bool rememberClient) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> TwoFactorRecoveryCodeSignInAsync(string recoveryCode) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.SignInResult> TwoFactorSignInAsync(string provider, string code, bool isPersistent, bool rememberClient) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> UpdateExternalAuthenticationTokensAsync(Microsoft.AspNetCore.Identity.ExternalLoginInfo externalLogin) => throw null;
                public Microsoft.AspNetCore.Identity.UserManager<TUser> UserManager { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task<TUser> ValidateSecurityStampAsync(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public virtual System.Threading.Tasks.Task<bool> ValidateSecurityStampAsync(TUser user, string securityStamp) => throw null;
                public virtual System.Threading.Tasks.Task<TUser> ValidateTwoFactorSecurityStampAsync(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }
            public class TwoFactorSecurityStampValidator<TUser> : Microsoft.AspNetCore.Identity.SecurityStampValidator<TUser>, Microsoft.AspNetCore.Identity.ISecurityStampValidator, Microsoft.AspNetCore.Identity.ITwoFactorSecurityStampValidator where TUser : class
            {
                public TwoFactorSecurityStampValidator(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions> options, Microsoft.AspNetCore.Identity.SignInManager<TUser> signInManager, Microsoft.AspNetCore.Authentication.ISystemClock clock, Microsoft.Extensions.Logging.ILoggerFactory logger) : base(default(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions>), default(Microsoft.AspNetCore.Identity.SignInManager<TUser>), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                public TwoFactorSecurityStampValidator(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions> options, Microsoft.AspNetCore.Identity.SignInManager<TUser> signInManager, Microsoft.Extensions.Logging.ILoggerFactory logger) : base(default(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Identity.SecurityStampValidatorOptions>), default(Microsoft.AspNetCore.Identity.SignInManager<TUser>), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                protected override System.Threading.Tasks.Task SecurityStampVerified(TUser user, Microsoft.AspNetCore.Authentication.Cookies.CookieValidatePrincipalContext context) => throw null;
                protected override System.Threading.Tasks.Task<TUser> VerifySecurityStamp(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }
            namespace UI
            {
                namespace Services
                {
                    public interface IEmailSender
                    {
                        System.Threading.Tasks.Task SendEmailAsync(string email, string subject, string htmlMessage);
                    }
                    public sealed class NoOpEmailSender : Microsoft.AspNetCore.Identity.UI.Services.IEmailSender
                    {
                        public NoOpEmailSender() => throw null;
                        public System.Threading.Tasks.Task SendEmailAsync(string email, string subject, string htmlMessage) => throw null;
                    }
                }
            }
        }
        namespace Routing
        {
            public static partial class IdentityApiEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapIdentityApi<TUser>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) where TUser : class, new() => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class IdentityServiceCollectionExtensions
            {
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddIdentity<TUser, TRole>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TUser : class where TRole : class => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddIdentity<TUser, TRole>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Identity.IdentityOptions> setupAction) where TUser : class where TRole : class => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddIdentityApiEndpoints<TUser>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TUser : class, new() => throw null;
                public static Microsoft.AspNetCore.Identity.IdentityBuilder AddIdentityApiEndpoints<TUser>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Identity.IdentityOptions> configure) where TUser : class, new() => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureApplicationCookie(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureExternalCookie(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationOptions> configure) => throw null;
            }
        }
    }
}
