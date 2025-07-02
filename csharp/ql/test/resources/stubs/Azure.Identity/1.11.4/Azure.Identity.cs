// This file contains auto-generated code.
// Generated from `Azure.Identity, Version=1.11.4.0, Culture=neutral, PublicKeyToken=92742159e12e44c8`.
namespace Azure
{
    namespace Identity
    {
        public class AuthenticationFailedException : System.Exception
        {
            public AuthenticationFailedException(string message) => throw null;
            public AuthenticationFailedException(string message, System.Exception innerException) => throw null;
            protected AuthenticationFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        }
        public class AuthenticationRecord
        {
            public string Authority { get => throw null; }
            public string ClientId { get => throw null; }
            public static Azure.Identity.AuthenticationRecord Deserialize(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public static System.Threading.Tasks.Task<Azure.Identity.AuthenticationRecord> DeserializeAsync(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public string HomeAccountId { get => throw null; }
            public void Serialize(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task SerializeAsync(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public string TenantId { get => throw null; }
            public string Username { get => throw null; }
        }
        public class AuthenticationRequiredException : Azure.Identity.CredentialUnavailableException
        {
            public AuthenticationRequiredException(string message, Azure.Core.TokenRequestContext context) : base(default(string)) => throw null;
            public AuthenticationRequiredException(string message, Azure.Core.TokenRequestContext context, System.Exception innerException) : base(default(string)) => throw null;
            protected AuthenticationRequiredException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) : base(default(string)) => throw null;
            public Azure.Core.TokenRequestContext TokenRequestContext { get => throw null; }
        }
        public class AuthorizationCodeCredential : Azure.Core.TokenCredential
        {
            protected AuthorizationCodeCredential() => throw null;
            public AuthorizationCodeCredential(string tenantId, string clientId, string clientSecret, string authorizationCode) => throw null;
            public AuthorizationCodeCredential(string tenantId, string clientId, string clientSecret, string authorizationCode, Azure.Identity.AuthorizationCodeCredentialOptions options) => throw null;
            public AuthorizationCodeCredential(string tenantId, string clientId, string clientSecret, string authorizationCode, Azure.Identity.TokenCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class AuthorizationCodeCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public AuthorizationCodeCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public System.Uri RedirectUri { get => throw null; set { } }
        }
        public static class AzureAuthorityHosts
        {
            public static System.Uri AzureChina { get => throw null; }
            public static System.Uri AzureGermany { get => throw null; }
            public static System.Uri AzureGovernment { get => throw null; }
            public static System.Uri AzurePublicCloud { get => throw null; }
        }
        public class AzureCliCredential : Azure.Core.TokenCredential
        {
            public AzureCliCredential() => throw null;
            public AzureCliCredential(Azure.Identity.AzureCliCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class AzureCliCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public AzureCliCredentialOptions() => throw null;
            public System.TimeSpan? ProcessTimeout { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
        }
        public class AzureDeveloperCliCredential : Azure.Core.TokenCredential
        {
            public AzureDeveloperCliCredential() => throw null;
            public AzureDeveloperCliCredential(Azure.Identity.AzureDeveloperCliCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class AzureDeveloperCliCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public AzureDeveloperCliCredentialOptions() => throw null;
            public System.TimeSpan? ProcessTimeout { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
        }
        public class AzurePowerShellCredential : Azure.Core.TokenCredential
        {
            public AzurePowerShellCredential() => throw null;
            public AzurePowerShellCredential(Azure.Identity.AzurePowerShellCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class AzurePowerShellCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public AzurePowerShellCredentialOptions() => throw null;
            public System.TimeSpan? ProcessTimeout { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
        }
        public class BrowserCustomizationOptions
        {
            public BrowserCustomizationOptions() => throw null;
            public string ErrorMessage { get => throw null; set { } }
            public string SuccessMessage { get => throw null; set { } }
            public bool? UseEmbeddedWebView { get => throw null; set { } }
        }
        public class ChainedTokenCredential : Azure.Core.TokenCredential
        {
            public ChainedTokenCredential(params Azure.Core.TokenCredential[] sources) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class ClientAssertionCredential : Azure.Core.TokenCredential
        {
            protected ClientAssertionCredential() => throw null;
            public ClientAssertionCredential(string tenantId, string clientId, System.Func<System.Threading.CancellationToken, System.Threading.Tasks.Task<string>> assertionCallback, Azure.Identity.ClientAssertionCredentialOptions options = default(Azure.Identity.ClientAssertionCredentialOptions)) => throw null;
            public ClientAssertionCredential(string tenantId, string clientId, System.Func<string> assertionCallback, Azure.Identity.ClientAssertionCredentialOptions options = default(Azure.Identity.ClientAssertionCredentialOptions)) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class ClientAssertionCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public ClientAssertionCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
        }
        public class ClientCertificateCredential : Azure.Core.TokenCredential
        {
            protected ClientCertificateCredential() => throw null;
            public ClientCertificateCredential(string tenantId, string clientId, string clientCertificatePath) => throw null;
            public ClientCertificateCredential(string tenantId, string clientId, string clientCertificatePath, Azure.Identity.TokenCredentialOptions options) => throw null;
            public ClientCertificateCredential(string tenantId, string clientId, string clientCertificatePath, Azure.Identity.ClientCertificateCredentialOptions options) => throw null;
            public ClientCertificateCredential(string tenantId, string clientId, System.Security.Cryptography.X509Certificates.X509Certificate2 clientCertificate) => throw null;
            public ClientCertificateCredential(string tenantId, string clientId, System.Security.Cryptography.X509Certificates.X509Certificate2 clientCertificate, Azure.Identity.TokenCredentialOptions options) => throw null;
            public ClientCertificateCredential(string tenantId, string clientId, System.Security.Cryptography.X509Certificates.X509Certificate2 clientCertificate, Azure.Identity.ClientCertificateCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class ClientCertificateCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public ClientCertificateCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public bool SendCertificateChain { get => throw null; set { } }
            public Azure.Identity.TokenCachePersistenceOptions TokenCachePersistenceOptions { get => throw null; set { } }
        }
        public class ClientSecretCredential : Azure.Core.TokenCredential
        {
            protected ClientSecretCredential() => throw null;
            public ClientSecretCredential(string tenantId, string clientId, string clientSecret) => throw null;
            public ClientSecretCredential(string tenantId, string clientId, string clientSecret, Azure.Identity.ClientSecretCredentialOptions options) => throw null;
            public ClientSecretCredential(string tenantId, string clientId, string clientSecret, Azure.Identity.TokenCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class ClientSecretCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public ClientSecretCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public Azure.Identity.TokenCachePersistenceOptions TokenCachePersistenceOptions { get => throw null; set { } }
        }
        public class CredentialUnavailableException : Azure.Identity.AuthenticationFailedException
        {
            public CredentialUnavailableException(string message) : base(default(string)) => throw null;
            public CredentialUnavailableException(string message, System.Exception innerException) : base(default(string)) => throw null;
            protected CredentialUnavailableException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) : base(default(string)) => throw null;
        }
        public class DefaultAzureCredential : Azure.Core.TokenCredential
        {
            public DefaultAzureCredential(bool includeInteractiveCredentials = default(bool)) => throw null;
            public DefaultAzureCredential(Azure.Identity.DefaultAzureCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class DefaultAzureCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public System.TimeSpan? CredentialProcessTimeout { get => throw null; set { } }
            public DefaultAzureCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public bool ExcludeAzureCliCredential { get => throw null; set { } }
            public bool ExcludeAzureDeveloperCliCredential { get => throw null; set { } }
            public bool ExcludeAzurePowerShellCredential { get => throw null; set { } }
            public bool ExcludeEnvironmentCredential { get => throw null; set { } }
            public bool ExcludeInteractiveBrowserCredential { get => throw null; set { } }
            public bool ExcludeManagedIdentityCredential { get => throw null; set { } }
            public bool ExcludeSharedTokenCacheCredential { get => throw null; set { } }
            public bool ExcludeVisualStudioCodeCredential { get => throw null; set { } }
            public bool ExcludeVisualStudioCredential { get => throw null; set { } }
            public bool ExcludeWorkloadIdentityCredential { get => throw null; set { } }
            public string InteractiveBrowserCredentialClientId { get => throw null; set { } }
            public string InteractiveBrowserTenantId { get => throw null; set { } }
            public string ManagedIdentityClientId { get => throw null; set { } }
            public Azure.Core.ResourceIdentifier ManagedIdentityResourceId { get => throw null; set { } }
            public string SharedTokenCacheTenantId { get => throw null; set { } }
            public string SharedTokenCacheUsername { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
            public string VisualStudioCodeTenantId { get => throw null; set { } }
            public string VisualStudioTenantId { get => throw null; set { } }
            public string WorkloadIdentityClientId { get => throw null; set { } }
        }
        public class DeviceCodeCredential : Azure.Core.TokenCredential
        {
            public virtual Azure.Identity.AuthenticationRecord Authenticate(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual Azure.Identity.AuthenticationRecord Authenticate(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<Azure.Identity.AuthenticationRecord> AuthenticateAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<Azure.Identity.AuthenticationRecord> AuthenticateAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public DeviceCodeCredential() => throw null;
            public DeviceCodeCredential(Azure.Identity.DeviceCodeCredentialOptions options) => throw null;
            public DeviceCodeCredential(System.Func<Azure.Identity.DeviceCodeInfo, System.Threading.CancellationToken, System.Threading.Tasks.Task> deviceCodeCallback, string clientId, Azure.Identity.TokenCredentialOptions options = default(Azure.Identity.TokenCredentialOptions)) => throw null;
            public DeviceCodeCredential(System.Func<Azure.Identity.DeviceCodeInfo, System.Threading.CancellationToken, System.Threading.Tasks.Task> deviceCodeCallback, string tenantId, string clientId, Azure.Identity.TokenCredentialOptions options = default(Azure.Identity.TokenCredentialOptions)) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class DeviceCodeCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public Azure.Identity.AuthenticationRecord AuthenticationRecord { get => throw null; set { } }
            public string ClientId { get => throw null; set { } }
            public DeviceCodeCredentialOptions() => throw null;
            public System.Func<Azure.Identity.DeviceCodeInfo, System.Threading.CancellationToken, System.Threading.Tasks.Task> DeviceCodeCallback { get => throw null; set { } }
            public bool DisableAutomaticAuthentication { get => throw null; set { } }
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
            public Azure.Identity.TokenCachePersistenceOptions TokenCachePersistenceOptions { get => throw null; set { } }
        }
        public struct DeviceCodeInfo
        {
            public string ClientId { get => throw null; }
            public string DeviceCode { get => throw null; }
            public System.DateTimeOffset ExpiresOn { get => throw null; }
            public string Message { get => throw null; }
            public System.Collections.Generic.IReadOnlyCollection<string> Scopes { get => throw null; }
            public string UserCode { get => throw null; }
            public System.Uri VerificationUri { get => throw null; }
        }
        public class EnvironmentCredential : Azure.Core.TokenCredential
        {
            public EnvironmentCredential() => throw null;
            public EnvironmentCredential(Azure.Identity.TokenCredentialOptions options) => throw null;
            public EnvironmentCredential(Azure.Identity.EnvironmentCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class EnvironmentCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public EnvironmentCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
        }
        public static class IdentityModelFactory
        {
            public static Azure.Identity.AuthenticationRecord AuthenticationRecord(string username, string authority, string homeAccountId, string tenantId, string clientId) => throw null;
            public static Azure.Identity.DeviceCodeInfo DeviceCodeInfo(string userCode, string deviceCode, System.Uri verificationUri, System.DateTimeOffset expiresOn, string message, string clientId, System.Collections.Generic.IReadOnlyCollection<string> scopes) => throw null;
        }
        public class InteractiveBrowserCredential : Azure.Core.TokenCredential
        {
            public virtual Azure.Identity.AuthenticationRecord Authenticate(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual Azure.Identity.AuthenticationRecord Authenticate(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<Azure.Identity.AuthenticationRecord> AuthenticateAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<Azure.Identity.AuthenticationRecord> AuthenticateAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public InteractiveBrowserCredential() => throw null;
            public InteractiveBrowserCredential(Azure.Identity.InteractiveBrowserCredentialOptions options) => throw null;
            public InteractiveBrowserCredential(string clientId) => throw null;
            public InteractiveBrowserCredential(string tenantId, string clientId, Azure.Identity.TokenCredentialOptions options = default(Azure.Identity.TokenCredentialOptions)) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class InteractiveBrowserCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public Azure.Identity.AuthenticationRecord AuthenticationRecord { get => throw null; set { } }
            public Azure.Identity.BrowserCustomizationOptions BrowserCustomization { get => throw null; set { } }
            public string ClientId { get => throw null; set { } }
            public InteractiveBrowserCredentialOptions() => throw null;
            public bool DisableAutomaticAuthentication { get => throw null; set { } }
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public string LoginHint { get => throw null; set { } }
            public System.Uri RedirectUri { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
            public Azure.Identity.TokenCachePersistenceOptions TokenCachePersistenceOptions { get => throw null; set { } }
        }
        public class ManagedIdentityCredential : Azure.Core.TokenCredential
        {
            protected ManagedIdentityCredential() => throw null;
            public ManagedIdentityCredential(string clientId = default(string), Azure.Identity.TokenCredentialOptions options = default(Azure.Identity.TokenCredentialOptions)) => throw null;
            public ManagedIdentityCredential(Azure.Core.ResourceIdentifier resourceId, Azure.Identity.TokenCredentialOptions options = default(Azure.Identity.TokenCredentialOptions)) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class OnBehalfOfCredential : Azure.Core.TokenCredential
        {
            protected OnBehalfOfCredential() => throw null;
            public OnBehalfOfCredential(string tenantId, string clientId, System.Security.Cryptography.X509Certificates.X509Certificate2 clientCertificate, string userAssertion) => throw null;
            public OnBehalfOfCredential(string tenantId, string clientId, System.Security.Cryptography.X509Certificates.X509Certificate2 clientCertificate, string userAssertion, Azure.Identity.OnBehalfOfCredentialOptions options) => throw null;
            public OnBehalfOfCredential(string tenantId, string clientId, string clientSecret, string userAssertion) => throw null;
            public OnBehalfOfCredential(string tenantId, string clientId, string clientSecret, string userAssertion, Azure.Identity.OnBehalfOfCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken) => throw null;
        }
        public class OnBehalfOfCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public OnBehalfOfCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public bool SendCertificateChain { get => throw null; set { } }
            public Azure.Identity.TokenCachePersistenceOptions TokenCachePersistenceOptions { get => throw null; set { } }
        }
        public class SharedTokenCacheCredential : Azure.Core.TokenCredential
        {
            public SharedTokenCacheCredential() => throw null;
            public SharedTokenCacheCredential(Azure.Identity.SharedTokenCacheCredentialOptions options) => throw null;
            public SharedTokenCacheCredential(string username, Azure.Identity.TokenCredentialOptions options = default(Azure.Identity.TokenCredentialOptions)) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class SharedTokenCacheCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public Azure.Identity.AuthenticationRecord AuthenticationRecord { get => throw null; set { } }
            public string ClientId { get => throw null; set { } }
            public SharedTokenCacheCredentialOptions() => throw null;
            public SharedTokenCacheCredentialOptions(Azure.Identity.TokenCachePersistenceOptions tokenCacheOptions) => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public bool EnableGuestTenantAuthentication { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
            public Azure.Identity.TokenCachePersistenceOptions TokenCachePersistenceOptions { get => throw null; set { } }
            public string Username { get => throw null; set { } }
        }
        public struct TokenCacheData
        {
            public System.ReadOnlyMemory<byte> CacheBytes { get => throw null; }
            public TokenCacheData(System.ReadOnlyMemory<byte> cacheBytes) => throw null;
        }
        public class TokenCachePersistenceOptions
        {
            public TokenCachePersistenceOptions() => throw null;
            public string Name { get => throw null; set { } }
            public bool UnsafeAllowUnencryptedStorage { get => throw null; set { } }
        }
        public class TokenCacheRefreshArgs
        {
            public bool IsCaeEnabled { get => throw null; }
            public string SuggestedCacheKey { get => throw null; }
        }
        public class TokenCacheUpdatedArgs
        {
            public bool IsCaeEnabled { get => throw null; }
            public System.ReadOnlyMemory<byte> UnsafeCacheData { get => throw null; }
        }
        public class TokenCredentialDiagnosticsOptions : Azure.Core.DiagnosticsOptions
        {
            public TokenCredentialDiagnosticsOptions() => throw null;
            public bool IsAccountIdentifierLoggingEnabled { get => throw null; set { } }
        }
        public class TokenCredentialOptions : Azure.Core.ClientOptions
        {
            public System.Uri AuthorityHost { get => throw null; set { } }
            public TokenCredentialOptions() => throw null;
            public Azure.Identity.TokenCredentialDiagnosticsOptions Diagnostics { get => throw null; }
            public bool IsUnsafeSupportLoggingEnabled { get => throw null; set { } }
        }
        public abstract class UnsafeTokenCacheOptions : Azure.Identity.TokenCachePersistenceOptions
        {
            protected UnsafeTokenCacheOptions() => throw null;
            protected abstract System.Threading.Tasks.Task<System.ReadOnlyMemory<byte>> RefreshCacheAsync();
            protected virtual System.Threading.Tasks.Task<Azure.Identity.TokenCacheData> RefreshCacheAsync(Azure.Identity.TokenCacheRefreshArgs args, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected abstract System.Threading.Tasks.Task TokenCacheUpdatedAsync(Azure.Identity.TokenCacheUpdatedArgs tokenCacheUpdatedArgs);
        }
        public class UsernamePasswordCredential : Azure.Core.TokenCredential
        {
            public virtual Azure.Identity.AuthenticationRecord Authenticate(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual Azure.Identity.AuthenticationRecord Authenticate(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<Azure.Identity.AuthenticationRecord> AuthenticateAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<Azure.Identity.AuthenticationRecord> AuthenticateAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected UsernamePasswordCredential() => throw null;
            public UsernamePasswordCredential(string username, string password, string tenantId, string clientId) => throw null;
            public UsernamePasswordCredential(string username, string password, string tenantId, string clientId, Azure.Identity.TokenCredentialOptions options) => throw null;
            public UsernamePasswordCredential(string username, string password, string tenantId, string clientId, Azure.Identity.UsernamePasswordCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class UsernamePasswordCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public UsernamePasswordCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public Azure.Identity.TokenCachePersistenceOptions TokenCachePersistenceOptions { get => throw null; set { } }
        }
        public class VisualStudioCodeCredential : Azure.Core.TokenCredential
        {
            public VisualStudioCodeCredential() => throw null;
            public VisualStudioCodeCredential(Azure.Identity.VisualStudioCodeCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken) => throw null;
        }
        public class VisualStudioCodeCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public VisualStudioCodeCredentialOptions() => throw null;
            public string TenantId { get => throw null; set { } }
        }
        public class VisualStudioCredential : Azure.Core.TokenCredential
        {
            public VisualStudioCredential() => throw null;
            public VisualStudioCredential(Azure.Identity.VisualStudioCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken) => throw null;
        }
        public class VisualStudioCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public VisualStudioCredentialOptions() => throw null;
            public System.TimeSpan? ProcessTimeout { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
        }
        public class WorkloadIdentityCredential : Azure.Core.TokenCredential
        {
            public WorkloadIdentityCredential() => throw null;
            public WorkloadIdentityCredential(Azure.Identity.WorkloadIdentityCredentialOptions options) => throw null;
            public override Azure.Core.AccessToken GetToken(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.ValueTask<Azure.Core.AccessToken> GetTokenAsync(Azure.Core.TokenRequestContext requestContext, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }
        public class WorkloadIdentityCredentialOptions : Azure.Identity.TokenCredentialOptions
        {
            public System.Collections.Generic.IList<string> AdditionallyAllowedTenants { get => throw null; }
            public string ClientId { get => throw null; set { } }
            public WorkloadIdentityCredentialOptions() => throw null;
            public bool DisableInstanceDiscovery { get => throw null; set { } }
            public string TenantId { get => throw null; set { } }
            public string TokenFilePath { get => throw null; set { } }
        }
    }
}
