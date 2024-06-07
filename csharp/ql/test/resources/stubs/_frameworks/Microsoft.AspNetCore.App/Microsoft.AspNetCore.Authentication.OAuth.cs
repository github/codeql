// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Authentication.OAuth, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Authentication
        {
            public static partial class ClaimActionCollectionMapExtensions
            {
                public static void DeleteClaim(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, string claimType) => throw null;
                public static void DeleteClaims(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, params string[] claimTypes) => throw null;
                public static void MapAll(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection) => throw null;
                public static void MapAllExcept(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, params string[] exclusions) => throw null;
                public static void MapCustomJson(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, string claimType, System.Func<System.Text.Json.JsonElement, string> resolver) => throw null;
                public static void MapCustomJson(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, string claimType, string valueType, System.Func<System.Text.Json.JsonElement, string> resolver) => throw null;
                public static void MapJsonKey(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, string claimType, string jsonKey) => throw null;
                public static void MapJsonKey(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, string claimType, string jsonKey, string valueType) => throw null;
                public static void MapJsonSubKey(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, string claimType, string jsonKey, string subKey) => throw null;
                public static void MapJsonSubKey(this Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection collection, string claimType, string jsonKey, string subKey, string valueType) => throw null;
            }
            namespace OAuth
            {
                namespace Claims
                {
                    public abstract class ClaimAction
                    {
                        public string ClaimType { get => throw null; }
                        public ClaimAction(string claimType, string valueType) => throw null;
                        public abstract void Run(System.Text.Json.JsonElement userData, System.Security.Claims.ClaimsIdentity identity, string issuer);
                        public string ValueType { get => throw null; }
                    }
                    public class ClaimActionCollection : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimAction>, System.Collections.IEnumerable
                    {
                        public void Add(Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimAction action) => throw null;
                        public void Clear() => throw null;
                        public ClaimActionCollection() => throw null;
                        public System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimAction> GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        public void Remove(string claimType) => throw null;
                    }
                    public class CustomJsonClaimAction : Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimAction
                    {
                        public CustomJsonClaimAction(string claimType, string valueType, System.Func<System.Text.Json.JsonElement, string> resolver) : base(default(string), default(string)) => throw null;
                        public System.Func<System.Text.Json.JsonElement, string> Resolver { get => throw null; }
                        public override void Run(System.Text.Json.JsonElement userData, System.Security.Claims.ClaimsIdentity identity, string issuer) => throw null;
                    }
                    public class DeleteClaimAction : Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimAction
                    {
                        public DeleteClaimAction(string claimType) : base(default(string), default(string)) => throw null;
                        public override void Run(System.Text.Json.JsonElement userData, System.Security.Claims.ClaimsIdentity identity, string issuer) => throw null;
                    }
                    public class JsonKeyClaimAction : Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimAction
                    {
                        public JsonKeyClaimAction(string claimType, string valueType, string jsonKey) : base(default(string), default(string)) => throw null;
                        public string JsonKey { get => throw null; }
                        public override void Run(System.Text.Json.JsonElement userData, System.Security.Claims.ClaimsIdentity identity, string issuer) => throw null;
                    }
                    public class JsonSubKeyClaimAction : Microsoft.AspNetCore.Authentication.OAuth.Claims.JsonKeyClaimAction
                    {
                        public JsonSubKeyClaimAction(string claimType, string valueType, string jsonKey, string subKey) : base(default(string), default(string), default(string)) => throw null;
                        public override void Run(System.Text.Json.JsonElement userData, System.Security.Claims.ClaimsIdentity identity, string issuer) => throw null;
                        public string SubKey { get => throw null; }
                    }
                    public class MapAllClaimsAction : Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimAction
                    {
                        public MapAllClaimsAction() : base(default(string), default(string)) => throw null;
                        public override void Run(System.Text.Json.JsonElement userData, System.Security.Claims.ClaimsIdentity identity, string issuer) => throw null;
                    }
                }
                public class OAuthChallengeProperties : Microsoft.AspNetCore.Authentication.AuthenticationProperties
                {
                    public OAuthChallengeProperties() => throw null;
                    public OAuthChallengeProperties(System.Collections.Generic.IDictionary<string, string> items) => throw null;
                    public OAuthChallengeProperties(System.Collections.Generic.IDictionary<string, string> items, System.Collections.Generic.IDictionary<string, object> parameters) => throw null;
                    public System.Collections.Generic.ICollection<string> Scope { get => throw null; set { } }
                    public static readonly string ScopeKey;
                    public virtual void SetScope(params string[] scopes) => throw null;
                }
                public class OAuthCodeExchangeContext
                {
                    public string Code { get => throw null; }
                    public OAuthCodeExchangeContext(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string code, string redirectUri) => throw null;
                    public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; }
                    public string RedirectUri { get => throw null; }
                }
                public static class OAuthConstants
                {
                    public static readonly string CodeChallengeKey;
                    public static readonly string CodeChallengeMethodKey;
                    public static readonly string CodeChallengeMethodS256;
                    public static readonly string CodeVerifierKey;
                }
                public class OAuthCreatingTicketContext : Microsoft.AspNetCore.Authentication.ResultContext<Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions>
                {
                    public string AccessToken { get => throw null; }
                    public System.Net.Http.HttpClient Backchannel { get => throw null; }
                    public OAuthCreatingTicketContext(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions options, System.Net.Http.HttpClient backchannel, Microsoft.AspNetCore.Authentication.OAuth.OAuthTokenResponse tokens, System.Text.Json.JsonElement user) : base(default(Microsoft.AspNetCore.Http.HttpContext), default(Microsoft.AspNetCore.Authentication.AuthenticationScheme), default(Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions)) => throw null;
                    public System.TimeSpan? ExpiresIn { get => throw null; }
                    public System.Security.Claims.ClaimsIdentity Identity { get => throw null; }
                    public string RefreshToken { get => throw null; }
                    public void RunClaimActions() => throw null;
                    public void RunClaimActions(System.Text.Json.JsonElement userData) => throw null;
                    public Microsoft.AspNetCore.Authentication.OAuth.OAuthTokenResponse TokenResponse { get => throw null; }
                    public string TokenType { get => throw null; }
                    public System.Text.Json.JsonElement User { get => throw null; }
                }
                public static class OAuthDefaults
                {
                    public static readonly string DisplayName;
                }
                public class OAuthEvents : Microsoft.AspNetCore.Authentication.RemoteAuthenticationEvents
                {
                    public virtual System.Threading.Tasks.Task CreatingTicket(Microsoft.AspNetCore.Authentication.OAuth.OAuthCreatingTicketContext context) => throw null;
                    public OAuthEvents() => throw null;
                    public System.Func<Microsoft.AspNetCore.Authentication.OAuth.OAuthCreatingTicketContext, System.Threading.Tasks.Task> OnCreatingTicket { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions>, System.Threading.Tasks.Task> OnRedirectToAuthorizationEndpoint { get => throw null; set { } }
                    public virtual System.Threading.Tasks.Task RedirectToAuthorizationEndpoint(Microsoft.AspNetCore.Authentication.RedirectContext<Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions> context) => throw null;
                }
                public class OAuthHandler<TOptions> : Microsoft.AspNetCore.Authentication.RemoteAuthenticationHandler<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions, new()
                {
                    protected System.Net.Http.HttpClient Backchannel { get => throw null; }
                    protected virtual string BuildChallengeUrl(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string redirectUri) => throw null;
                    protected override System.Threading.Tasks.Task<object> CreateEventsAsync() => throw null;
                    protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticationTicket> CreateTicketAsync(System.Security.Claims.ClaimsIdentity identity, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, Microsoft.AspNetCore.Authentication.OAuth.OAuthTokenResponse tokens) => throw null;
                    public OAuthHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder, Microsoft.AspNetCore.Authentication.ISystemClock clock) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                    public OAuthHandler(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options, Microsoft.Extensions.Logging.ILoggerFactory logger, System.Text.Encodings.Web.UrlEncoder encoder) : base(default(Microsoft.Extensions.Options.IOptionsMonitor<TOptions>), default(Microsoft.Extensions.Logging.ILoggerFactory), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                    protected Microsoft.AspNetCore.Authentication.OAuth.OAuthEvents Events { get => throw null; set { } }
                    protected virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.OAuth.OAuthTokenResponse> ExchangeCodeAsync(Microsoft.AspNetCore.Authentication.OAuth.OAuthCodeExchangeContext context) => throw null;
                    protected virtual string FormatScope(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                    protected virtual string FormatScope() => throw null;
                    protected override System.Threading.Tasks.Task HandleChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    protected override System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.HandleRequestResult> HandleRemoteAuthenticateAsync() => throw null;
                }
                public class OAuthOptions : Microsoft.AspNetCore.Authentication.RemoteAuthenticationOptions
                {
                    public string AuthorizationEndpoint { get => throw null; set { } }
                    public Microsoft.AspNetCore.Authentication.OAuth.Claims.ClaimActionCollection ClaimActions { get => throw null; }
                    public string ClientId { get => throw null; set { } }
                    public string ClientSecret { get => throw null; set { } }
                    public OAuthOptions() => throw null;
                    public Microsoft.AspNetCore.Authentication.OAuth.OAuthEvents Events { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> Scope { get => throw null; }
                    public Microsoft.AspNetCore.Authentication.ISecureDataFormat<Microsoft.AspNetCore.Authentication.AuthenticationProperties> StateDataFormat { get => throw null; set { } }
                    public string TokenEndpoint { get => throw null; set { } }
                    public bool UsePkce { get => throw null; set { } }
                    public string UserInformationEndpoint { get => throw null; set { } }
                    public override void Validate() => throw null;
                }
                public class OAuthTokenResponse : System.IDisposable
                {
                    public string AccessToken { get => throw null; set { } }
                    public void Dispose() => throw null;
                    public System.Exception Error { get => throw null; set { } }
                    public string ExpiresIn { get => throw null; set { } }
                    public static Microsoft.AspNetCore.Authentication.OAuth.OAuthTokenResponse Failed(System.Exception error) => throw null;
                    public string RefreshToken { get => throw null; set { } }
                    public System.Text.Json.JsonDocument Response { get => throw null; set { } }
                    public static Microsoft.AspNetCore.Authentication.OAuth.OAuthTokenResponse Success(System.Text.Json.JsonDocument response) => throw null;
                    public string TokenType { get => throw null; set { } }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class OAuthExtensions
            {
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddOAuth(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, System.Action<Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddOAuth(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, string displayName, System.Action<Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddOAuth<TOptions, THandler>(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, System.Action<TOptions> configureOptions) where TOptions : Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions, new() where THandler : Microsoft.AspNetCore.Authentication.OAuth.OAuthHandler<TOptions> => throw null;
                public static Microsoft.AspNetCore.Authentication.AuthenticationBuilder AddOAuth<TOptions, THandler>(this Microsoft.AspNetCore.Authentication.AuthenticationBuilder builder, string authenticationScheme, string displayName, System.Action<TOptions> configureOptions) where TOptions : Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions, new() where THandler : Microsoft.AspNetCore.Authentication.OAuth.OAuthHandler<TOptions> => throw null;
            }
            public class OAuthPostConfigureOptions<TOptions, THandler> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : Microsoft.AspNetCore.Authentication.OAuth.OAuthOptions, new() where THandler : Microsoft.AspNetCore.Authentication.OAuth.OAuthHandler<TOptions>
            {
                public OAuthPostConfigureOptions(Microsoft.AspNetCore.DataProtection.IDataProtectionProvider dataProtection) => throw null;
                public void PostConfigure(string name, TOptions options) => throw null;
            }
        }
    }
}
