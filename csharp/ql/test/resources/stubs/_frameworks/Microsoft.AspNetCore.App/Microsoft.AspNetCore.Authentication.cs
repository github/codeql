// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Authentication, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            public class AccessDeniedContext : Microsoft.AspNetCore.Authentication.HandleRequestContext<Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions>
            {
                public Microsoft.AspNetCore.Http.PathString AccessDeniedPath { get => throw null; set { } }
                public AccessDeniedContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions options) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions)) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
                public string ReturnUrl { get => throw null; set { } }
                public string ReturnUrlParameter { get => throw null; set { } }
            }
            public class AuthenticationBuilder
            {
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddPolicyScheme(string authenticationScheme, string displayName, System.Action<Microsoft.AspNetCore.Authentication.PolicySchemeOptions> configureOptions) => throw null;
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddRemoteScheme<TOptions, THandler>(string authenticationScheme, string displayName, System.Action<TOptions> configureOptions) where TOptions : Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions, new() where THandler : Microsoft.AspNetCore.Authentication.RemoteAuthenticationHandler<TOptions> => throw null;
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddScheme<TOptions, THandler>(string authenticationScheme, string displayName, System.Action<TOptions> configureOptions) where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions, new() where THandler : Microsoft.AspNetCore.Authentication.AuthenticationHandler<TOptions> => throw null;
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddScheme<TOptions, THandler>(string authenticationScheme, System.Action<TOptions> configureOptions) where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions, new() where THandler : Microsoft.AspNetCore.Authentication.AuthenticationHandler<TOptions> => throw null;
                public AuthenticationBuilder(Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public virtual Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get => throw null; }
            }
            public static partial class AuthenticationConfigurationProviderExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfiguration GetSchemeConfiguration(this Microsoft.AspNetCore.Authentication.IAuthenticationConfigurationProvider provider, string authenticationScheme) => throw null;
            }
            public abstract class AuthenticationHandler<TOptions> : Microsoft.AspNetCore.Authentication.IAuthenticationHandler where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions, new()
            {
                public System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync() => throw null;
                protected string BuildRedirectUri(string targetPath) => throw null;
                public System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected virtual string ClaimsIssuer { get => throw null; }
                protected Microsoft.AspNetCore.Authentication.ISystemClock Clock { get => throw null; }
                protected Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; }
                protected virtual System.Threading.Tasks.Task<object> CreateEventsAsync() => throw null;
                protected AuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) => throw null;
                protected AuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder) => throw null;
                protected string CurrentUri { get => throw null; }
                protected virtual object Events { get => throw null; set { } }
                public System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> HandleAuthenticateAsync();
                protected System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> HandleAuthenticateOnceAsync() => throw null;
                protected System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> HandleAuthenticateOnceSafeAsync() => throw null;
                protected virtual System.Threading.Tasks.Task HandleChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected virtual System.Threading.Tasks.Task HandleForbiddenAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public System.Threading.Tasks.Task InitializeAsync(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                protected virtual System.Threading.Tasks.Task InitializeEventsAsync() => throw null;
                protected virtual System.Threading.Tasks.Task InitializeHandlerAsync() => throw null;
                protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                public TOptions Options { get => throw null; }
                protected Microsoft.Extensions.Options.IOptionsMonitor<TOptions> OptionsMonitor { get => throw null; }
                protected Microsoft.AspNetCore.Http.PathString OriginalPath { get => throw null; }
                protected Microsoft.AspNetCore.Http.PathString OriginalPathBase { get => throw null; }
                protected Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
                protected virtual string ResolveTarget(string scheme) => throw null;
                protected Microsoft.AspNetCore.Http.HttpResponse Response { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationScheme Scheme { get => throw null; }
                protected System.TimeProvider TimeProvider { get => throw null; }
                protected System.Text.Encodings.Web.UrlEncoder UrlEncoder { get => throw null; }
            }
            public class AuthenticationMiddleware
            {
                public AuthenticationMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider schemes) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider Schemes { get => throw null; set { } }
            }
            public class AuthenticationSchemeOptions
            {
                public string ClaimsIssuer { get => throw null; set { } }
                public AuthenticationSchemeOptions() => throw null;
                public object Events { get => throw null; set { } }
                public System.Type EventsType { get => throw null; set { } }
                public string ForwardAuthenticate { get => throw null; set { } }
                public string ForwardChallenge { get => throw null; set { } }
                public string ForwardDefault { get => throw null; set { } }
                public System.Func<Microsoft.AspNetCore.Http.HttpContext, string> ForwardDefaultSelector { get => throw null; set { } }
                public string ForwardForbid { get => throw null; set { } }
                public string ForwardSignIn { get => throw null; set { } }
                public string ForwardSignOut { get => throw null; set { } }
                public System.TimeProvider TimeProvider { get => throw null; set { } }
                public virtual void Validate() => throw null;
                public virtual void Validate(string scheme) => throw null;
            }
            public static class Base64UrlTextEncoder
            {
                public static byte[] Decode(string text) => throw null;
                public static string Encode(byte[] data) => throw null;
            }
            public abstract class BaseContext<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                protected BaseContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, TOptions options) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public TOptions Options { get => throw null; }
                public Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
                public Microsoft.AspNetCore.Http.HttpResponse Response { get => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationScheme Scheme { get => throw null; }
            }
            public class HandleRequestContext<TOptions> : Microsoft.AspNetCore.Authentication.BaseContext<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                protected HandleRequestContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, TOptions options) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(TOptions)) => throw null;
                public void HandleResponse() => throw null;
                public Microsoft.AspNetCore.Authentication.HandleRequestResult Result { get => throw null; set { } }
                public void SkipHandler() => throw null;
            }
            public class HandleRequestResult : Microsoft.AspNetCore.Authentication.AuthenticateResult
            {
                public HandleRequestResult() => throw null;
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult Fail(System.Exception failure) => throw null;
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult Fail(System.Exception failure, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult Fail(string failureMessage) => throw null;
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult Fail(string failureMessage, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult Handle() => throw null;
                public bool Handled { get => throw null; }
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult NoResult() => throw null;
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult SkipHandler() => throw null;
                public bool Skipped { get => throw null; }
                public static Microsoft.AspNetCore.Authentication.HandleRequestResult Success(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) => throw null;
            }
            public interface IDataSerializer<TModel>
            {
                TModel Deserialize(byte[] data);
                byte[] Serialize(TModel model);
            }
            public interface ISecureDataFormat<TData>
            {
                string Protect(TData data);
                string Protect(TData data, string purpose);
                TData Unprotect(string protectedText);
                TData Unprotect(string protectedText, string purpose);
            }
            public interface ISystemClock
            {
                System.DateTimeOffset UtcNow { get; }
            }
            public static partial class JsonDocumentAuthExtensions
            {
                public static string GetString(this System.Text.Json.JsonElement element, string key) => throw null;
            }
            public class PolicySchemeHandler : Microsoft.AspNetCore.Authentication.SignInAuthenticationHandler<Microsoft.AspNetCore.Authentication.PolicySchemeOptions>
            {
                public PolicySchemeHandler(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.PolicySchemeOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.PolicySchemeOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                public PolicySchemeHandler(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.PolicySchemeOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.Authentication.PolicySchemeOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                protected override System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> HandleAuthenticateAsync() => throw null;
                protected override System.Threading.Tasks.Task HandleChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected override System.Threading.Tasks.Task HandleForbiddenAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected override System.Threading.Tasks.Task HandleSignInAsync(System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected override System.Threading.Tasks.Task HandleSignOutAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
            }
            public class PolicySchemeOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                public PolicySchemeOptions() => throw null;
            }
            public abstract class PrincipalContext<TOptions> : Microsoft.AspNetCore.Authentication.PropertiesContext<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                protected PrincipalContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, TOptions options, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(TOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                public virtual System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set { } }
            }
            public abstract class PropertiesContext<TOptions> : Microsoft.AspNetCore.Authentication.BaseContext<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                protected PropertiesContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, TOptions options, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(TOptions)) => throw null;
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
            }
            public class PropertiesDataFormat : Microsoft.AspNetCore.Authentication.SecureDataFormat<Microsoft.AspNetCore.Authentication.AuthenticationProperties>
            {
                public PropertiesDataFormat(Microsoft.AspNetCore.DataProtection.IDataProtector protector) : base(default(Microsoft.AspNetCore.Authentication.IDataSerializer<Microsoft.AspNetCore.Authentication.AuthenticationProperties>), default(Microsoft.AspNetCore.DataProtection.IDataProtector)) => throw null;
            }
            public class PropertiesSerializer : Microsoft.AspNetCore.Authentication.IDataSerializer<Microsoft.AspNetCore.Authentication.AuthenticationProperties>
            {
                public PropertiesSerializer() => throw null;
                public static Microsoft.AspNetCore.Authentication.PropertiesSerializer Default { get => throw null; }
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationProperties Deserialize(byte[] data) => throw null;
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationProperties Read(System.IO.BinaryReader reader) => throw null;
                public virtual byte[] Serialize(Microsoft.AspNetCore.Authentication.AuthenticationProperties model) => throw null;
                public virtual void Write(System.IO.BinaryWriter writer, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
            }
            public class RedirectContext<TOptions> : Microsoft.AspNetCore.Authentication.PropertiesContext<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                public RedirectContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, TOptions options, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string redirectUri) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(TOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                public string RedirectUri { get => throw null; set { } }
            }
            public abstract class RemoteAuthenticationContext<TOptions> : Microsoft.AspNetCore.Authentication.HandleRequestContext<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                protected RemoteAuthenticationContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, TOptions options, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(TOptions)) => throw null;
                public void Fail(System.Exception failure) => throw null;
                public void Fail(string failureMessage) => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
                public void Success() => throw null;
            }
            public class RemoteAuthenticationEvents
            {
                public virtual System.Threading.Tasks.Task AccessDenied(Microsoft.AspNetCore.Authentication.AccessDeniedContext context) => throw null;
                public RemoteAuthenticationEvents() => throw null;
                public System.Func<Microsoft.AspNetCore.Authentication.AccessDeniedContext, System.Threading.Tasks.Task> OnAccessDenied { get => throw null; set { } }
                public System.Func<Microsoft.AspNetCore.Authentication.RemoteFailureContext, System.Threading.Tasks.Task> OnRemoteFailure { get => throw null; set { } }
                public System.Func<Microsoft.AspNetCore.Authentication.TicketReceivedContext, System.Threading.Tasks.Task> OnTicketReceived { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task RemoteFailure(Microsoft.AspNetCore.Authentication.RemoteFailureContext context) => throw null;
                public virtual System.Threading.Tasks.Task TicketReceived(Microsoft.AspNetCore.Authentication.TicketReceivedContext context) => throw null;
            }
            public abstract class RemoteAuthenticationHandler<TOptions> : Microsoft.AspNetCore.Authentication.AuthenticationHandler<TOptions>, Microsoft.AspNetCore.Authentication.IAuthenticationHandler, Microsoft.AspNetCore.Authentication.IAuthenticationRequestHandler where TOptions : Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions, new()
            {
                protected override System.Threading.Tasks.Task<object> CreateEventsAsync() => throw null;
                protected RemoteAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                protected RemoteAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                protected Microsoft.AspNetCore.Authentication.RemoteAuthenticationEvents Events { get => throw null; set { } }
                protected virtual void GenerateCorrelationId(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.HandleRequestResult> HandleAccessDeniedErrorAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected override System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> HandleAuthenticateAsync() => throw null;
                protected override System.Threading.Tasks.Task HandleForbiddenAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                protected abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.HandleRequestResult> HandleRemoteAuthenticateAsync();
                public virtual System.Threading.Tasks.Task<bool> HandleRequestAsync() => throw null;
                public virtual System.Threading.Tasks.Task<bool> ShouldHandleRequestAsync() => throw null;
                protected string SignInScheme { get => throw null; }
                protected virtual bool ValidateCorrelationId(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
            }
            public class RemoteAuthenticationOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                public Microsoft.AspNetCore.Http.PathString AccessDeniedPath { get => throw null; set { } }
                public System.Net.Http.HttpClient Backchannel { get => throw null; set { } }
                public System.Net.Http.HttpMessageHandler BackchannelHttpHandler { get => throw null; set { } }
                public System.TimeSpan BackchannelTimeout { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.PathString CallbackPath { get => throw null; set { } }
                public Microsoft.AspNetCore.Http.CookieBuilder CorrelationCookie { get => throw null; set { } }
                public RemoteAuthenticationOptions() => throw null;
                public Microsoft.AspNetCore.DataProtection.IDataProtectionProvider DataProtectionProvider { get => throw null; set { } }
                public Microsoft.AspNetCore.Authentication.RemoteAuthenticationEvents Events { get => throw null; set { } }
                public System.TimeSpan RemoteAuthenticationTimeout { get => throw null; set { } }
                public string ReturnUrlParameter { get => throw null; set { } }
                public bool SaveTokens { get => throw null; set { } }
                public string SignInScheme { get => throw null; set { } }
                public override void Validate(string scheme) => throw null;
                public override void Validate() => throw null;
            }
            public class RemoteFailureContext : Microsoft.AspNetCore.Authentication.HandleRequestContext<Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions>
            {
                public RemoteFailureContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions options, System.Exception failure) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions)) => throw null;
                public System.Exception Failure { get => throw null; set { } }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
            }
            public class RequestPathBaseCookieBuilder : Microsoft.AspNetCore.Http.CookieBuilder
            {
                protected virtual string AdditionalPath { get => throw null; }
                public override Microsoft.AspNetCore.Http.CookieOptions Build(Microsoft.AspNetCore.Http.HttpContext context, System.DateTimeOffset expiresFrom) => throw null;
                public RequestPathBaseCookieBuilder() => throw null;
            }
            public abstract class ResultContext<TOptions> : Microsoft.AspNetCore.Authentication.BaseContext<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions
            {
                protected ResultContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, TOptions options) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(TOptions)) => throw null;
                public void Fail(System.Exception failure) => throw null;
                public void Fail(string failureMessage) => throw null;
                public void NoResult() => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set { } }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
                public Microsoft.AspNetCore.Authentication.AuthenticateResult Result { get => throw null; }
                public void Success() => throw null;
            }
            public class SecureDataFormat<TData> : Microsoft.AspNetCore.Authentication.ISecureDataFormat<TData>
            {
                public SecureDataFormat(Microsoft.AspNetCore.Authentication.IDataSerializer<TData> serializer, Microsoft.AspNetCore.DataProtection.IDataProtector protector) => throw null;
                public string Protect(TData data) => throw null;
                public string Protect(TData data, string purpose) => throw null;
                public TData Unprotect(string protectedText) => throw null;
                public TData Unprotect(string protectedText, string purpose) => throw null;
            }
            public abstract class SignInAuthenticationHandler<TOptions> : Microsoft.AspNetCore.Authentication.SignOutAuthenticationHandler<TOptions>, Microsoft.AspNetCore.Authentication.IAuthenticationHandler, Microsoft.AspNetCore.Authentication.IAuthenticationSignInHandler, Microsoft.AspNetCore.Authentication.IAuthenticationSignOutHandler where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions, new()
            {
                public SignInAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                public SignInAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                protected abstract System.Threading.Tasks.Task HandleSignInAsync(System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                public virtual System.Threading.Tasks.Task SignInAsync(System.Security.Claims.ClaimsPrincipal user, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
            }
            public abstract class SignOutAuthenticationHandler<TOptions> : Microsoft.AspNetCore.Authentication.AuthenticationHandler<TOptions>, Microsoft.AspNetCore.Authentication.IAuthenticationHandler, Microsoft.AspNetCore.Authentication.IAuthenticationSignOutHandler where TOptions : Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions, new()
            {
                public SignOutAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                public SignOutAuthenticationHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                protected abstract System.Threading.Tasks.Task HandleSignOutAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties);
                public virtual System.Threading.Tasks.Task SignOutAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
            }
            public class SystemClock : Microsoft.AspNetCore.Authentication.ISystemClock
            {
                public SystemClock() => throw null;
                public System.DateTimeOffset UtcNow { get => throw null; }
            }
            public class TicketDataFormat : Microsoft.AspNetCore.Authentication.SecureDataFormat<Microsoft.AspNetCore.Authentication.AuthenticationTicket>
            {
                public TicketDataFormat(Microsoft.AspNetCore.DataProtection.IDataProtector protector) : base(default(Microsoft.AspNetCore.Authentication.IDataSerializer<Microsoft.AspNetCore.Authentication.AuthenticationTicket>), default(Microsoft.AspNetCore.DataProtection.IDataProtector)) => throw null;
            }
            public class TicketReceivedContext : Microsoft.AspNetCore.Authentication.RemoteAuthenticationContext<Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions>
            {
                public TicketReceivedContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions options, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions), default(Microsoft.AspNetCore.Authentication.AuthenticationProperties)) => throw null;
                public string ReturnUri { get => throw null; set { } }
            }
            public class TicketSerializer : Microsoft.AspNetCore.Authentication.IDataSerializer<Microsoft.AspNetCore.Authentication.AuthenticationTicket>
            {
                public TicketSerializer() => throw null;
                public static Microsoft.AspNetCore.Authentication.TicketSerializer Default { get => throw null; }
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationTicket Deserialize(byte[] data) => throw null;
                public virtual Microsoft.AspNetCore.Authentication.AuthenticationTicket Read(System.IO.BinaryReader reader) => throw null;
                protected virtual System.Security.Claims.Claim ReadClaim(System.IO.BinaryReader reader, System.Security.Claims.ClaimsIdentity identity) => throw null;
                protected virtual System.Security.Claims.ClaimsIdentity ReadIdentity(System.IO.BinaryReader reader) => throw null;
                public virtual byte[] Serialize(Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) => throw null;
                public virtual void Write(System.IO.BinaryWriter writer, Microsoft.AspNetCore.Authentication.AuthenticationTicket ticket) => throw null;
                protected virtual void WriteClaim(System.IO.BinaryWriter writer, System.Security.Claims.Claim claim) => throw null;
                protected virtual void WriteIdentity(System.IO.BinaryWriter writer, System.Security.Claims.ClaimsIdentity identity) => throw null;
            }
        }
        namespace Builder
        {
            public static partial class AuthAppBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseAuthentication(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class AuthenticationServiceCollectionExtensions
            {
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddAuthentication(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddAuthentication(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string defaultScheme) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddAuthentication(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Authentication.AuthenticationOptions> configureOptions) => throw null;
            }
        }
    }
}
