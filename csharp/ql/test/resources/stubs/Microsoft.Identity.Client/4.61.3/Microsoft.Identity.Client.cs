// This file contains auto-generated code.
// Generated from `Microsoft.Identity.Client, Version=4.61.3.0, Culture=neutral, PublicKeyToken=0a613f4dd989e8ae`.
namespace Microsoft
{
    namespace Identity
    {
        namespace Client
        {
            public enum AadAuthorityAudience
            {
                None = 0,
                AzureAdMyOrg = 1,
                AzureAdAndPersonalMicrosoftAccount = 2,
                AzureAdMultipleOrgs = 3,
                PersonalMicrosoftAccount = 4,
            }
            public abstract class AbstractAcquireTokenParameterBuilder<T> : Microsoft.Identity.Client.BaseAbstractAcquireTokenParameterBuilder<T> where T : Microsoft.Identity.Client.BaseAbstractAcquireTokenParameterBuilder<T>
            {
                protected AbstractAcquireTokenParameterBuilder() => throw null;
                public T WithAdfsAuthority(string authorityUri, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(string authorityUri, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(string cloudInstanceUri, System.Guid tenantId, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(string cloudInstanceUri, string tenant, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AzureCloudInstance azureCloudInstance, System.Guid tenantId, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AzureCloudInstance azureCloudInstance, string tenant, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AzureCloudInstance azureCloudInstance, Microsoft.Identity.Client.AadAuthorityAudience authorityAudience, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AadAuthorityAudience authorityAudience, bool validateAuthority = default(bool)) => throw null;
                public T WithB2CAuthority(string authorityUri) => throw null;
                public T WithClaims(string claims) => throw null;
                public T WithExtraQueryParameters(System.Collections.Generic.Dictionary<string, string> extraQueryParameters) => throw null;
                public T WithExtraQueryParameters(string extraQueryParameters) => throw null;
                protected T WithScopes(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public T WithTenantId(string tenantId) => throw null;
                public T WithTenantIdFromAuthority(System.Uri authorityUri) => throw null;
            }
            public abstract class AbstractApplicationBuilder<T> : Microsoft.Identity.Client.BaseAbstractApplicationBuilder<T> where T : Microsoft.Identity.Client.BaseAbstractApplicationBuilder<T>
            {
                public T WithAdfsAuthority(string authorityUri, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(System.Uri authorityUri, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(string authorityUri, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(string cloudInstanceUri, System.Guid tenantId, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(string cloudInstanceUri, string tenant, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AzureCloudInstance azureCloudInstance, System.Guid tenantId, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AzureCloudInstance azureCloudInstance, string tenant, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AzureCloudInstance azureCloudInstance, Microsoft.Identity.Client.AadAuthorityAudience authorityAudience, bool validateAuthority = default(bool)) => throw null;
                public T WithAuthority(Microsoft.Identity.Client.AadAuthorityAudience authorityAudience, bool validateAuthority = default(bool)) => throw null;
                public T WithB2CAuthority(string authorityUri) => throw null;
                public T WithCacheOptions(Microsoft.Identity.Client.CacheOptions options) => throw null;
                public T WithClientCapabilities(System.Collections.Generic.IEnumerable<string> clientCapabilities) => throw null;
                public T WithClientId(string clientId) => throw null;
                public T WithClientName(string clientName) => throw null;
                public T WithClientVersion(string clientVersion) => throw null;
                public T WithExtraQueryParameters(System.Collections.Generic.IDictionary<string, string> extraQueryParameters) => throw null;
                public T WithExtraQueryParameters(string extraQueryParameters) => throw null;
                public T WithInstanceDicoveryMetadata(string instanceDiscoveryJson) => throw null;
                public T WithInstanceDicoveryMetadata(System.Uri instanceDiscoveryUri) => throw null;
                public T WithInstanceDiscovery(bool enableInstanceDiscovery) => throw null;
                public T WithInstanceDiscoveryMetadata(string instanceDiscoveryJson) => throw null;
                public T WithInstanceDiscoveryMetadata(System.Uri instanceDiscoveryUri) => throw null;
                public T WithLegacyCacheCompatibility(bool enableLegacyCacheCompatibility = default(bool)) => throw null;
                protected T WithOptions(Microsoft.Identity.Client.ApplicationOptions applicationOptions) => throw null;
                public T WithRedirectUri(string redirectUri) => throw null;
                public T WithTelemetry(Microsoft.Identity.Client.ITelemetryConfig telemetryConfig) => throw null;
                public T WithTenantId(string tenantId) => throw null;
            }
            public abstract class AbstractClientAppBaseAcquireTokenParameterBuilder<T> : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> where T : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T>
            {
                public override System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> ExecuteAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public abstract class AbstractConfidentialClientAcquireTokenParameterBuilder<T> : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> where T : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T>
            {
                public override System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> ExecuteAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                protected override void Validate() => throw null;
                public T WithProofOfPossession(Microsoft.Identity.Client.AppConfig.PoPAuthenticationConfiguration popAuthenticationConfiguration) => throw null;
            }
            public abstract class AbstractManagedIdentityAcquireTokenParameterBuilder<T> : Microsoft.Identity.Client.BaseAbstractAcquireTokenParameterBuilder<T> where T : Microsoft.Identity.Client.BaseAbstractAcquireTokenParameterBuilder<T>
            {
                protected AbstractManagedIdentityAcquireTokenParameterBuilder() => throw null;
                public override System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> ExecuteAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public abstract class AbstractPublicClientAcquireTokenParameterBuilder<T> : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> where T : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T>
            {
                public override System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> ExecuteAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public static partial class AccountExtensions
            {
                public static System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.TenantProfile> GetTenantProfiles(this Microsoft.Identity.Client.IAccount account) => throw null;
            }
            public class AccountId
            {
                public AccountId(string identifier, string objectId, string tenantId) => throw null;
                public AccountId(string adfsIdentifier) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public string Identifier { get => throw null; }
                public string ObjectId { get => throw null; }
                public string TenantId { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class AcquireTokenByAuthorizationCodeParameterBuilder : Microsoft.Identity.Client.AbstractConfidentialClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder>
            {
                protected override void Validate() => throw null;
                public Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder WithCcsRoutingHint(string userObjectIdentifier, string tenantIdentifier) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder WithCcsRoutingHint(string userName) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder WithPkceCodeVerifier(string pkceCodeVerifier) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder WithSendX5C(bool withSendX5C) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder WithSpaAuthorizationCode(bool requestSpaAuthorizationCode = default(bool)) => throw null;
            }
            public sealed class AcquireTokenByIntegratedWindowsAuthParameterBuilder : Microsoft.Identity.Client.AbstractPublicClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenByIntegratedWindowsAuthParameterBuilder>
            {
                public Microsoft.Identity.Client.AcquireTokenByIntegratedWindowsAuthParameterBuilder WithFederationMetadata(string federationMetadata) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByIntegratedWindowsAuthParameterBuilder WithUsername(string username) => throw null;
            }
            public sealed class AcquireTokenByRefreshTokenParameterBuilder : Microsoft.Identity.Client.AbstractClientAppBaseAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenByRefreshTokenParameterBuilder>
            {
                protected override void Validate() => throw null;
                public Microsoft.Identity.Client.AcquireTokenByRefreshTokenParameterBuilder WithSendX5C(bool withSendX5C) => throw null;
            }
            public sealed class AcquireTokenByUsernamePasswordParameterBuilder : Microsoft.Identity.Client.AbstractPublicClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenByUsernamePasswordParameterBuilder>
            {
                public Microsoft.Identity.Client.AcquireTokenByUsernamePasswordParameterBuilder WithFederationMetadata(string federationMetadata) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByUsernamePasswordParameterBuilder WithProofOfPossession(string nonce, System.Net.Http.HttpMethod httpMethod, System.Uri requestUri) => throw null;
            }
            public sealed class AcquireTokenForClientParameterBuilder : Microsoft.Identity.Client.AbstractConfidentialClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder>
            {
                protected override void Validate() => throw null;
                public Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder WithAzureRegion(bool useAzureRegion) => throw null;
                public Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder WithForceRefresh(bool forceRefresh) => throw null;
                public Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder WithPreferredAzureRegion(bool useAzureRegion = default(bool), string regionUsedIfAutoDetectFails = default(string), bool fallbackToGlobal = default(bool)) => throw null;
                public Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder WithSendX5C(bool withSendX5C) => throw null;
            }
            public sealed class AcquireTokenForManagedIdentityParameterBuilder : Microsoft.Identity.Client.AbstractManagedIdentityAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenForManagedIdentityParameterBuilder>
            {
                public Microsoft.Identity.Client.AcquireTokenForManagedIdentityParameterBuilder WithForceRefresh(bool forceRefresh) => throw null;
            }
            public sealed class AcquireTokenInteractiveParameterBuilder : Microsoft.Identity.Client.AbstractPublicClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder>
            {
                protected override void Validate() => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithAccount(Microsoft.Identity.Client.IAccount account) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithEmbeddedWebViewOptions(Microsoft.Identity.Client.EmbeddedWebViewOptions options) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithExtraScopesToConsent(System.Collections.Generic.IEnumerable<string> extraScopesToConsent) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithLoginHint(string loginHint) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithParentActivityOrWindow(object parent) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithParentActivityOrWindow(nint window) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithPrompt(Microsoft.Identity.Client.Prompt prompt) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithProofOfPossession(string nonce, System.Net.Http.HttpMethod httpMethod, System.Uri requestUri) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithSystemWebViewOptions(Microsoft.Identity.Client.SystemWebViewOptions options) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithUseEmbeddedWebView(bool useEmbeddedWebView) => throw null;
            }
            public sealed class AcquireTokenOnBehalfOfParameterBuilder : Microsoft.Identity.Client.AbstractConfidentialClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder>
            {
                protected override void Validate() => throw null;
                public Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder WithCcsRoutingHint(string userObjectIdentifier, string tenantIdentifier) => throw null;
                public Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder WithCcsRoutingHint(string userName) => throw null;
                public Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder WithForceRefresh(bool forceRefresh) => throw null;
                public Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder WithSendX5C(bool withSendX5C) => throw null;
            }
            public sealed class AcquireTokenSilentParameterBuilder : Microsoft.Identity.Client.AbstractClientAppBaseAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder>
            {
                protected override void Validate() => throw null;
                public Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder WithForceRefresh(bool forceRefresh) => throw null;
                public Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder WithProofOfPossession(Microsoft.Identity.Client.AppConfig.PoPAuthenticationConfiguration popAuthenticationConfiguration) => throw null;
                public Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder WithProofOfPossession(string nonce, System.Net.Http.HttpMethod httpMethod, System.Uri requestUri) => throw null;
                public Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder WithSendX5C(bool withSendX5C) => throw null;
            }
            public sealed class AcquireTokenWithDeviceCodeParameterBuilder : Microsoft.Identity.Client.AbstractPublicClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.AcquireTokenWithDeviceCodeParameterBuilder>
            {
                protected override void Validate() => throw null;
                public Microsoft.Identity.Client.AcquireTokenWithDeviceCodeParameterBuilder WithDeviceCodeResultCallback(System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback) => throw null;
            }
            namespace Advanced
            {
                public static partial class AcquireTokenParameterBuilderExtensions
                {
                    public static T WithExtraHttpHeaders<T>(this Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> builder, System.Collections.Generic.IDictionary<string, string> extraHttpHeaders) where T : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> => throw null;
                }
            }
            namespace AppConfig
            {
                public class ManagedIdentityId
                {
                    public static Microsoft.Identity.Client.AppConfig.ManagedIdentityId SystemAssigned { get => throw null; }
                    public static Microsoft.Identity.Client.AppConfig.ManagedIdentityId WithUserAssignedClientId(string clientId) => throw null;
                    public static Microsoft.Identity.Client.AppConfig.ManagedIdentityId WithUserAssignedObjectId(string objectId) => throw null;
                    public static Microsoft.Identity.Client.AppConfig.ManagedIdentityId WithUserAssignedResourceId(string resourceId) => throw null;
                }
                public class PoPAuthenticationConfiguration
                {
                    public PoPAuthenticationConfiguration() => throw null;
                    public PoPAuthenticationConfiguration(System.Net.Http.HttpRequestMessage httpRequestMessage) => throw null;
                    public PoPAuthenticationConfiguration(System.Uri requestUri) => throw null;
                    public string HttpHost { get => throw null; set { } }
                    public System.Net.Http.HttpMethod HttpMethod { get => throw null; set { } }
                    public string HttpPath { get => throw null; set { } }
                    public string Nonce { get => throw null; set { } }
                    public Microsoft.Identity.Client.AuthScheme.PoP.IPoPCryptoProvider PopCryptoProvider { get => throw null; set { } }
                    public bool SignHttpRequest { get => throw null; set { } }
                }
            }
            public abstract class ApplicationBase : Microsoft.Identity.Client.IApplicationBase
            {
            }
            public abstract class ApplicationOptions : Microsoft.Identity.Client.BaseApplicationOptions
            {
                public Microsoft.Identity.Client.AadAuthorityAudience AadAuthorityAudience { get => throw null; set { } }
                public Microsoft.Identity.Client.AzureCloudInstance AzureCloudInstance { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> ClientCapabilities { get => throw null; set { } }
                public string ClientId { get => throw null; set { } }
                public string ClientName { get => throw null; set { } }
                public string ClientVersion { get => throw null; set { } }
                protected ApplicationOptions() => throw null;
                public string Instance { get => throw null; set { } }
                public string KerberosServicePrincipalName { get => throw null; set { } }
                public bool LegacyCacheCompatibilityEnabled { get => throw null; set { } }
                public string RedirectUri { get => throw null; set { } }
                public string TenantId { get => throw null; set { } }
                public Microsoft.Identity.Client.Kerberos.KerberosTicketContainer TicketContainer { get => throw null; set { } }
            }
            public class AssertionRequestOptions
            {
                public System.Threading.CancellationToken CancellationToken { get => throw null; set { } }
                public string ClientID { get => throw null; set { } }
                public AssertionRequestOptions() => throw null;
                public string TokenEndpoint { get => throw null; set { } }
            }
            public class AuthenticationHeaderParser
            {
                public Microsoft.Identity.Client.AuthenticationInfoParameters AuthenticationInfoParameters { get => throw null; }
                public AuthenticationHeaderParser() => throw null;
                public static Microsoft.Identity.Client.AuthenticationHeaderParser ParseAuthenticationHeaders(System.Net.Http.Headers.HttpResponseHeaders httpResponseHeaders) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationHeaderParser> ParseAuthenticationHeadersAsync(string resourceUri, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationHeaderParser> ParseAuthenticationHeadersAsync(string resourceUri, System.Net.Http.HttpClient httpClient, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public string PopNonce { get => throw null; }
                public System.Collections.Generic.IReadOnlyList<Microsoft.Identity.Client.WwwAuthenticateParameters> WwwAuthenticateParameters { get => throw null; }
            }
            public class AuthenticationInfoParameters
            {
                public static Microsoft.Identity.Client.AuthenticationInfoParameters CreateFromResponseHeaders(System.Net.Http.Headers.HttpResponseHeaders httpResponseHeaders) => throw null;
                public AuthenticationInfoParameters() => throw null;
                public string NextNonce { get => throw null; }
                public string this[string key] { get => throw null; }
            }
            public class AuthenticationResult
            {
                public string AccessToken { get => throw null; }
                public Microsoft.Identity.Client.IAccount Account { get => throw null; }
                public System.Collections.Generic.IReadOnlyDictionary<string, string> AdditionalResponseParameters { get => throw null; }
                public Microsoft.Identity.Client.AuthenticationResultMetadata AuthenticationResultMetadata { get => throw null; }
                public System.Security.Claims.ClaimsPrincipal ClaimsPrincipal { get => throw null; }
                public System.Guid CorrelationId { get => throw null; }
                public string CreateAuthorizationHeader() => throw null;
                public AuthenticationResult(string accessToken, bool isExtendedLifeTimeToken, string uniqueId, System.DateTimeOffset expiresOn, System.DateTimeOffset extendedExpiresOn, string tenantId, Microsoft.Identity.Client.IAccount account, string idToken, System.Collections.Generic.IEnumerable<string> scopes, System.Guid correlationId, string tokenType = default(string), Microsoft.Identity.Client.AuthenticationResultMetadata authenticationResultMetadata = default(Microsoft.Identity.Client.AuthenticationResultMetadata), System.Security.Claims.ClaimsPrincipal claimsPrincipal = default(System.Security.Claims.ClaimsPrincipal), string spaAuthCode = default(string), System.Collections.Generic.IReadOnlyDictionary<string, string> additionalResponseParameters = default(System.Collections.Generic.IReadOnlyDictionary<string, string>)) => throw null;
                public AuthenticationResult(string accessToken, bool isExtendedLifeTimeToken, string uniqueId, System.DateTimeOffset expiresOn, System.DateTimeOffset extendedExpiresOn, string tenantId, Microsoft.Identity.Client.IAccount account, string idToken, System.Collections.Generic.IEnumerable<string> scopes, System.Guid correlationId, Microsoft.Identity.Client.AuthenticationResultMetadata authenticationResultMetadata, string tokenType = default(string)) => throw null;
                public System.DateTimeOffset ExpiresOn { get => throw null; }
                public System.DateTimeOffset ExtendedExpiresOn { get => throw null; }
                public string IdToken { get => throw null; }
                public bool IsExtendedLifeTimeToken { get => throw null; }
                public System.Collections.Generic.IEnumerable<string> Scopes { get => throw null; }
                public string SpaAuthCode { get => throw null; }
                public string TenantId { get => throw null; }
                public string TokenType { get => throw null; }
                public string UniqueId { get => throw null; }
                public Microsoft.Identity.Client.IUser User { get => throw null; }
            }
            public class AuthenticationResultMetadata
            {
                public Microsoft.Identity.Client.Cache.CacheLevel CacheLevel { get => throw null; set { } }
                public Microsoft.Identity.Client.CacheRefreshReason CacheRefreshReason { get => throw null; set { } }
                public AuthenticationResultMetadata(Microsoft.Identity.Client.TokenSource tokenSource) => throw null;
                public long DurationInCacheInMs { get => throw null; set { } }
                public long DurationInHttpInMs { get => throw null; set { } }
                public long DurationTotalInMs { get => throw null; set { } }
                public System.DateTimeOffset? RefreshOn { get => throw null; set { } }
                public Microsoft.Identity.Client.RegionDetails RegionDetails { get => throw null; set { } }
                public string Telemetry { get => throw null; set { } }
                public string TokenEndpoint { get => throw null; set { } }
                public Microsoft.Identity.Client.TokenSource TokenSource { get => throw null; }
            }
            namespace AuthScheme
            {
                namespace PoP
                {
                    public interface IPoPCryptoProvider
                    {
                        string CannonicalPublicKeyJwk { get; }
                        string CryptographicAlgorithm { get; }
                        byte[] Sign(byte[] data);
                    }
                }
            }
            public enum AzureCloudInstance
            {
                None = 0,
                AzurePublic = 1,
                AzureChina = 2,
                AzureGermany = 3,
                AzureUsGovernment = 4,
            }
            public abstract class BaseAbstractAcquireTokenParameterBuilder<T> where T : Microsoft.Identity.Client.BaseAbstractAcquireTokenParameterBuilder<T>
            {
                protected BaseAbstractAcquireTokenParameterBuilder() => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> ExecuteAsync(System.Threading.CancellationToken cancellationToken);
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> ExecuteAsync() => throw null;
                protected virtual void Validate() => throw null;
                public T WithCorrelationId(System.Guid correlationId) => throw null;
            }
            public abstract class BaseAbstractApplicationBuilder<T> where T : Microsoft.Identity.Client.BaseAbstractApplicationBuilder<T>
            {
                public T WithDebugLoggingCallback(Microsoft.Identity.Client.LogLevel logLevel = default(Microsoft.Identity.Client.LogLevel), bool enablePiiLogging = default(bool), bool withDefaultPlatformLoggingEnabled = default(bool)) => throw null;
                public T WithExperimentalFeatures(bool enableExperimentalFeatures = default(bool)) => throw null;
                public T WithHttpClientFactory(Microsoft.Identity.Client.IMsalHttpClientFactory httpClientFactory) => throw null;
                public T WithHttpClientFactory(Microsoft.Identity.Client.IMsalHttpClientFactory httpClientFactory, bool retryOnceOn5xx) => throw null;
                public T WithLogging(Microsoft.Identity.Client.LogCallback loggingCallback, Microsoft.Identity.Client.LogLevel? logLevel = default(Microsoft.Identity.Client.LogLevel?), bool? enablePiiLogging = default(bool?), bool? enableDefaultPlatformLogging = default(bool?)) => throw null;
                public T WithLogging(Microsoft.IdentityModel.Abstractions.IIdentityLogger identityLogger, bool enablePiiLogging = default(bool)) => throw null;
                protected T WithOptions(Microsoft.Identity.Client.BaseApplicationOptions applicationOptions) => throw null;
            }
            public abstract class BaseApplicationOptions
            {
                protected BaseApplicationOptions() => throw null;
                public bool EnablePiiLogging { get => throw null; set { } }
                public bool IsDefaultPlatformLoggingEnabled { get => throw null; set { } }
                public Microsoft.Identity.Client.LogLevel LogLevel { get => throw null; set { } }
            }
            public class BrokerOptions
            {
                public BrokerOptions(Microsoft.Identity.Client.BrokerOptions.OperatingSystems enabledOn) => throw null;
                public Microsoft.Identity.Client.BrokerOptions.OperatingSystems EnabledOn { get => throw null; }
                public bool ListOperatingSystemAccounts { get => throw null; set { } }
                public bool MsaPassthrough { get => throw null; set { } }
                [System.Flags]
                public enum OperatingSystems
                {
                    None = 0,
                    Windows = 1,
                }
                public string Title { get => throw null; set { } }
            }
            namespace Cache
            {
                public class CacheData
                {
                    public byte[] AdalV3State { get => throw null; set { } }
                    public CacheData() => throw null;
                    public byte[] UnifiedState { get => throw null; set { } }
                }
                public enum CacheLevel
                {
                    None = 0,
                    Unknown = 1,
                    L1Cache = 2,
                    L2Cache = 3,
                }
            }
            public class CacheOptions
            {
                public CacheOptions() => throw null;
                public CacheOptions(bool useSharedCache) => throw null;
                public static Microsoft.Identity.Client.CacheOptions EnableSharedCacheOptions { get => throw null; }
                public bool UseSharedCache { get => throw null; set { } }
            }
            public enum CacheRefreshReason
            {
                NotApplicable = 0,
                ForceRefreshOrClaims = 1,
                NoCachedAccessToken = 2,
                Expired = 3,
                ProactivelyRefreshed = 4,
            }
            public abstract class ClientApplicationBase : Microsoft.Identity.Client.ApplicationBase, Microsoft.Identity.Client.IApplicationBase, Microsoft.Identity.Client.IClientApplicationBase
            {
                public Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder AcquireTokenSilent(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account) => throw null;
                public Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder AcquireTokenSilent(System.Collections.Generic.IEnumerable<string> scopes, string loginHint) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenSilentAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, string authority, bool forceRefresh) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenSilentAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account) => throw null;
                public Microsoft.Identity.Client.IAppConfig AppConfig { get => throw null; }
                public string Authority { get => throw null; }
                public string ClientId { get => throw null; }
                public string Component { get => throw null; set { } }
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.IAccount> GetAccountAsync(string accountId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.IAccount> GetAccountAsync(string accountId) => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IAccount>> GetAccountsAsync() => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IAccount>> GetAccountsAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IAccount>> GetAccountsAsync(string userFlow) => throw null;
                public System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IAccount>> GetAccountsAsync(string userFlow, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public Microsoft.Identity.Client.IUser GetUser(string identifier) => throw null;
                public string RedirectUri { get => throw null; set { } }
                public void Remove(Microsoft.Identity.Client.IUser user) => throw null;
                public System.Threading.Tasks.Task RemoveAsync(Microsoft.Identity.Client.IAccount account) => throw null;
                public System.Threading.Tasks.Task RemoveAsync(Microsoft.Identity.Client.IAccount account, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public string SliceParameters { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IUser> Users { get => throw null; }
                public Microsoft.Identity.Client.ITokenCache UserTokenCache { get => throw null; }
                public bool ValidateAuthority { get => throw null; set { } }
            }
            public sealed class ClientAssertionCertificate
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                public ClientAssertionCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public static int MinKeySizeInBits { get => throw null; }
            }
            public sealed class ClientCredential
            {
                public ClientCredential(Microsoft.Identity.Client.ClientAssertionCertificate certificate) => throw null;
                public ClientCredential(string secret) => throw null;
            }
            public sealed class ConfidentialClientApplication : Microsoft.Identity.Client.ClientApplicationBase, Microsoft.Identity.Client.IApplicationBase, Microsoft.Identity.Client.IByRefreshToken, Microsoft.Identity.Client.IClientApplicationBase, Microsoft.Identity.Client.IConfidentialClientApplication, Microsoft.Identity.Client.IConfidentialClientApplicationWithCertificate, Microsoft.Identity.Client.ILongRunningWebApi
            {
                public Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder AcquireTokenByAuthorizationCode(System.Collections.Generic.IEnumerable<string> scopes, string authorizationCode) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByAuthorizationCodeAsync(string authorizationCode, System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                Microsoft.Identity.Client.AcquireTokenByRefreshTokenParameterBuilder Microsoft.Identity.Client.IByRefreshToken.AcquireTokenByRefreshToken(System.Collections.Generic.IEnumerable<string> scopes, string refreshToken) => throw null;
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> Microsoft.Identity.Client.IByRefreshToken.AcquireTokenByRefreshTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string refreshToken) => throw null;
                public Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder AcquireTokenForClient(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenForClientAsync(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenForClientAsync(System.Collections.Generic.IEnumerable<string> scopes, bool forceRefresh) => throw null;
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> Microsoft.Identity.Client.IConfidentialClientApplicationWithCertificate.AcquireTokenForClientWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> Microsoft.Identity.Client.IConfidentialClientApplicationWithCertificate.AcquireTokenForClientWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes, bool forceRefresh) => throw null;
                public Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder AcquireTokenInLongRunningProcess(System.Collections.Generic.IEnumerable<string> scopes, string longRunningProcessSessionKey) => throw null;
                public Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder AcquireTokenOnBehalfOf(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenOnBehalfOfAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenOnBehalfOfAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion, string authority) => throw null;
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> Microsoft.Identity.Client.IConfidentialClientApplicationWithCertificate.AcquireTokenOnBehalfOfWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion) => throw null;
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> Microsoft.Identity.Client.IConfidentialClientApplicationWithCertificate.AcquireTokenOnBehalfOfWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion, string authority) => throw null;
                public Microsoft.Identity.Client.ITokenCache AppTokenCache { get => throw null; }
                public const string AttemptRegionDiscovery = default;
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; }
                public ConfidentialClientApplication(string clientId, string redirectUri, Microsoft.Identity.Client.ClientCredential clientCredential, Microsoft.Identity.Client.TokenCache userTokenCache, Microsoft.Identity.Client.TokenCache appTokenCache) => throw null;
                public ConfidentialClientApplication(string clientId, string authority, string redirectUri, Microsoft.Identity.Client.ClientCredential clientCredential, Microsoft.Identity.Client.TokenCache userTokenCache, Microsoft.Identity.Client.TokenCache appTokenCache) => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder GetAuthorizationRequestUrl(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public System.Threading.Tasks.Task<System.Uri> GetAuthorizationRequestUrlAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, string extraQueryParameters) => throw null;
                public System.Threading.Tasks.Task<System.Uri> GetAuthorizationRequestUrlAsync(System.Collections.Generic.IEnumerable<string> scopes, string redirectUri, string loginHint, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority) => throw null;
                public Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder InitiateLongRunningProcessInWebApi(System.Collections.Generic.IEnumerable<string> scopes, string userToken, ref string longRunningProcessSessionKey) => throw null;
                public System.Threading.Tasks.Task<bool> StopLongRunningProcessInWebApiAsync(string longRunningProcessSessionKey, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public class ConfidentialClientApplicationBuilder : Microsoft.Identity.Client.AbstractApplicationBuilder<Microsoft.Identity.Client.ConfidentialClientApplicationBuilder>
            {
                public Microsoft.Identity.Client.IConfidentialClientApplication Build() => throw null;
                public static Microsoft.Identity.Client.ConfidentialClientApplicationBuilder Create(string clientId) => throw null;
                public static Microsoft.Identity.Client.ConfidentialClientApplicationBuilder CreateWithApplicationOptions(Microsoft.Identity.Client.ConfidentialClientApplicationOptions options) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithAzureRegion(string azureRegion = default(string)) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithCacheSynchronization(bool enableCacheSynchronization) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithCertificate(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool sendX5C) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithClientAssertion(string signedClientAssertion) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithClientAssertion(System.Func<string> clientAssertionDelegate) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithClientAssertion(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.Task<string>> clientAssertionAsyncDelegate) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithClientAssertion(System.Func<Microsoft.Identity.Client.AssertionRequestOptions, System.Threading.Tasks.Task<string>> clientAssertionAsyncDelegate) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithClientClaims(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, string> claimsToSign, bool mergeWithDefaultClaims) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithClientClaims(System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, string> claimsToSign, bool mergeWithDefaultClaims = default(bool), bool sendX5C = default(bool)) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithClientSecret(string clientSecret) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithGenericAuthority(string authorityUri) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithOidcAuthority(string authorityUri) => throw null;
                public Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithTelemetryClient(params Microsoft.IdentityModel.Abstractions.ITelemetryClient[] telemetryClients) => throw null;
            }
            public class ConfidentialClientApplicationOptions : Microsoft.Identity.Client.ApplicationOptions
            {
                public string AzureRegion { get => throw null; set { } }
                public string ClientSecret { get => throw null; set { } }
                public ConfidentialClientApplicationOptions() => throw null;
                public bool EnableCacheSynchronization { get => throw null; set { } }
            }
            public class DeviceCodeResult
            {
                public string ClientId { get => throw null; }
                public string DeviceCode { get => throw null; }
                public System.DateTimeOffset ExpiresOn { get => throw null; }
                public long Interval { get => throw null; }
                public string Message { get => throw null; }
                public System.Collections.Generic.IReadOnlyCollection<string> Scopes { get => throw null; }
                public string UserCode { get => throw null; }
                public string VerificationUrl { get => throw null; }
            }
            public class EmbeddedWebViewOptions
            {
                public EmbeddedWebViewOptions() => throw null;
                public string Title { get => throw null; set { } }
                public string WebView2BrowserExecutableFolder { get => throw null; set { } }
            }
            namespace Extensibility
            {
                public static class AbstractConfidentialClientAcquireTokenParameterBuilderExtension
                {
                    public static Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> OnBeforeTokenRequest<T>(this Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> builder, System.Func<Microsoft.Identity.Client.Extensibility.OnBeforeTokenRequestData, System.Threading.Tasks.Task> onBeforeTokenRequestHandler) where T : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> => throw null;
                    public static Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> WithProofOfPosessionKeyId<T>(this Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> builder, string keyId, string expectedTokenTypeFromAad = default(string)) where T : Microsoft.Identity.Client.AbstractAcquireTokenParameterBuilder<T> => throw null;
                }
                public static partial class AcquireTokenForClientBuilderExtensions
                {
                    public static Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder WithProofOfPosessionKeyId(this Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder builder, string keyId, string expectedTokenTypeFromAad = default(string)) => throw null;
                }
                public static partial class AcquireTokenInteractiveParameterBuilderExtensions
                {
                    public static Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithCustomWebUi(this Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder builder, Microsoft.Identity.Client.Extensibility.ICustomWebUi customWebUi) => throw null;
                }
                public static partial class AcquireTokenOnBehalfOfParameterBuilderExtensions
                {
                    public static Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder WithSearchInCacheForLongRunningProcess(this Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder builder, bool searchInCache = default(bool)) => throw null;
                }
                public class AppTokenProviderParameters
                {
                    public System.Threading.CancellationToken CancellationToken { get => throw null; }
                    public string Claims { get => throw null; }
                    public string CorrelationId { get => throw null; }
                    public AppTokenProviderParameters() => throw null;
                    public System.Collections.Generic.IEnumerable<string> Scopes { get => throw null; }
                    public string TenantId { get => throw null; }
                }
                public class AppTokenProviderResult
                {
                    public string AccessToken { get => throw null; set { } }
                    public AppTokenProviderResult() => throw null;
                    public long ExpiresInSeconds { get => throw null; set { } }
                    public long? RefreshInSeconds { get => throw null; set { } }
                }
                public static partial class ConfidentialClientApplicationBuilderExtensions
                {
                    public static Microsoft.Identity.Client.ConfidentialClientApplicationBuilder WithAppTokenProvider(this Microsoft.Identity.Client.ConfidentialClientApplicationBuilder builder, System.Func<Microsoft.Identity.Client.Extensibility.AppTokenProviderParameters, System.Threading.Tasks.Task<Microsoft.Identity.Client.Extensibility.AppTokenProviderResult>> appTokenProvider) => throw null;
                }
                public static partial class ConfidentialClientApplicationExtensions
                {
                    public static System.Threading.Tasks.Task<bool> StopLongRunningProcessInWebApiAsync(this Microsoft.Identity.Client.ILongRunningWebApi clientApp, string longRunningProcessSessionKey, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                }
                public interface ICustomWebUi
                {
                    System.Threading.Tasks.Task<System.Uri> AcquireAuthorizationCodeAsync(System.Uri authorizationUri, System.Uri redirectUri, System.Threading.CancellationToken cancellationToken);
                }
                public sealed class OnBeforeTokenRequestData
                {
                    public System.Collections.Generic.IDictionary<string, string> BodyParameters { get => throw null; }
                    public System.Threading.CancellationToken CancellationToken { get => throw null; }
                    public OnBeforeTokenRequestData(System.Collections.Generic.IDictionary<string, string> bodyParameters, System.Collections.Generic.IDictionary<string, string> headers, System.Uri requestUri, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Collections.Generic.IDictionary<string, string> Headers { get => throw null; }
                    public System.Uri RequestUri { get => throw null; set { } }
                }
            }
            public sealed class GetAuthorizationRequestUrlParameterBuilder : Microsoft.Identity.Client.AbstractConfidentialClientAcquireTokenParameterBuilder<Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder>
            {
                public System.Threading.Tasks.Task<System.Uri> ExecuteAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<System.Uri> ExecuteAsync() => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder WithAccount(Microsoft.Identity.Client.IAccount account) => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder WithCcsRoutingHint(string userObjectIdentifier, string tenantIdentifier) => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder WithExtraScopesToConsent(System.Collections.Generic.IEnumerable<string> extraScopesToConsent) => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder WithLoginHint(string loginHint) => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder WithPkce(out string codeVerifier) => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder WithPrompt(Microsoft.Identity.Client.Prompt prompt) => throw null;
                public Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder WithRedirectUri(string redirectUri) => throw null;
            }
            public interface IAccount
            {
                string Environment { get; }
                Microsoft.Identity.Client.AccountId HomeAccountId { get; }
                string Username { get; }
            }
            public interface IAppConfig
            {
                System.Collections.Generic.IEnumerable<string> ClientCapabilities { get; }
                System.Security.Cryptography.X509Certificates.X509Certificate2 ClientCredentialCertificate { get; }
                string ClientId { get; }
                string ClientName { get; }
                string ClientSecret { get; }
                string ClientVersion { get; }
                bool EnablePiiLogging { get; }
                bool ExperimentalFeaturesEnabled { get; }
                System.Collections.Generic.IDictionary<string, string> ExtraQueryParameters { get; }
                Microsoft.Identity.Client.IMsalHttpClientFactory HttpClientFactory { get; }
                bool IsBrokerEnabled { get; }
                bool IsDefaultPlatformLoggingEnabled { get; }
                bool LegacyCacheCompatibilityEnabled { get; }
                Microsoft.Identity.Client.LogCallback LoggingCallback { get; }
                Microsoft.Identity.Client.LogLevel LogLevel { get; }
                System.Func<object> ParentActivityOrWindowFunc { get; }
                string RedirectUri { get; }
                Microsoft.Identity.Client.ITelemetryConfig TelemetryConfig { get; }
                string TenantId { get; }
            }
            public interface IApplicationBase
            {
            }
            public interface IByRefreshToken
            {
                Microsoft.Identity.Client.AcquireTokenByRefreshTokenParameterBuilder AcquireTokenByRefreshToken(System.Collections.Generic.IEnumerable<string> scopes, string refreshToken);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByRefreshTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string refreshToken);
            }
            public interface IClientApplicationBase : Microsoft.Identity.Client.IApplicationBase
            {
                Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder AcquireTokenSilent(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account);
                Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder AcquireTokenSilent(System.Collections.Generic.IEnumerable<string> scopes, string loginHint);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenSilentAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenSilentAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, string authority, bool forceRefresh);
                Microsoft.Identity.Client.IAppConfig AppConfig { get; }
                string Authority { get; }
                string ClientId { get; }
                string Component { get; set; }
                System.Threading.Tasks.Task<Microsoft.Identity.Client.IAccount> GetAccountAsync(string identifier);
                System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IAccount>> GetAccountsAsync();
                System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IAccount>> GetAccountsAsync(string userFlow);
                Microsoft.Identity.Client.IUser GetUser(string identifier);
                string RedirectUri { get; set; }
                void Remove(Microsoft.Identity.Client.IUser user);
                System.Threading.Tasks.Task RemoveAsync(Microsoft.Identity.Client.IAccount account);
                string SliceParameters { get; set; }
                System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IUser> Users { get; }
                Microsoft.Identity.Client.ITokenCache UserTokenCache { get; }
                bool ValidateAuthority { get; }
            }
            public interface IConfidentialClientApplication : Microsoft.Identity.Client.IApplicationBase, Microsoft.Identity.Client.IClientApplicationBase
            {
                Microsoft.Identity.Client.AcquireTokenByAuthorizationCodeParameterBuilder AcquireTokenByAuthorizationCode(System.Collections.Generic.IEnumerable<string> scopes, string authorizationCode);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByAuthorizationCodeAsync(string authorizationCode, System.Collections.Generic.IEnumerable<string> scopes);
                Microsoft.Identity.Client.AcquireTokenForClientParameterBuilder AcquireTokenForClient(System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenForClientAsync(System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenForClientAsync(System.Collections.Generic.IEnumerable<string> scopes, bool forceRefresh);
                Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder AcquireTokenOnBehalfOf(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenOnBehalfOfAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenOnBehalfOfAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion, string authority);
                Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder AcquireTokenSilent(System.Collections.Generic.IEnumerable<string> scopes, string loginHint);
                Microsoft.Identity.Client.ITokenCache AppTokenCache { get; }
                System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.Identity.Client.IAccount>> GetAccountsAsync();
                Microsoft.Identity.Client.GetAuthorizationRequestUrlParameterBuilder GetAuthorizationRequestUrl(System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<System.Uri> GetAuthorizationRequestUrlAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, string extraQueryParameters);
                System.Threading.Tasks.Task<System.Uri> GetAuthorizationRequestUrlAsync(System.Collections.Generic.IEnumerable<string> scopes, string redirectUri, string loginHint, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority);
            }
            public interface IConfidentialClientApplicationWithCertificate
            {
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenForClientWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenForClientWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes, bool forceRefresh);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenOnBehalfOfWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenOnBehalfOfWithCertificateAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UserAssertion userAssertion, string authority);
            }
            public interface ILongRunningWebApi
            {
                Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder AcquireTokenInLongRunningProcess(System.Collections.Generic.IEnumerable<string> scopes, string longRunningProcessSessionKey);
                Microsoft.Identity.Client.AcquireTokenOnBehalfOfParameterBuilder InitiateLongRunningProcessInWebApi(System.Collections.Generic.IEnumerable<string> scopes, string userToken, ref string longRunningProcessSessionKey);
            }
            public interface IManagedIdentityApplication : Microsoft.Identity.Client.IApplicationBase
            {
                Microsoft.Identity.Client.AcquireTokenForManagedIdentityParameterBuilder AcquireTokenForManagedIdentity(string resource);
            }
            public interface IMsalHttpClientFactory
            {
                System.Net.Http.HttpClient GetHttpClient();
            }
            public class IntuneAppProtectionPolicyRequiredException : Microsoft.Identity.Client.MsalServiceException
            {
                public string AccountUserId { get => throw null; set { } }
                public string AuthorityUrl { get => throw null; set { } }
                public IntuneAppProtectionPolicyRequiredException(string errorCode, string errorMessage) : base(default(string), default(string)) => throw null;
                public string TenantId { get => throw null; set { } }
                public string Upn { get => throw null; set { } }
            }
            public interface IPublicClientApplication : Microsoft.Identity.Client.IApplicationBase, Microsoft.Identity.Client.IClientApplicationBase
            {
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UIParent parent);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.UIParent parent);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.UIParent parent);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, Microsoft.Identity.Client.UIParent parent);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, Microsoft.Identity.Client.UIParent parent);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority, Microsoft.Identity.Client.UIParent parent);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority, Microsoft.Identity.Client.UIParent parent);
                Microsoft.Identity.Client.AcquireTokenByIntegratedWindowsAuthParameterBuilder AcquireTokenByIntegratedWindowsAuth(System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByIntegratedWindowsAuthAsync(System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByIntegratedWindowsAuthAsync(System.Collections.Generic.IEnumerable<string> scopes, string username);
                Microsoft.Identity.Client.AcquireTokenByUsernamePasswordParameterBuilder AcquireTokenByUsernamePassword(System.Collections.Generic.IEnumerable<string> scopes, string username, System.Security.SecureString password);
                Microsoft.Identity.Client.AcquireTokenByUsernamePasswordParameterBuilder AcquireTokenByUsernamePassword(System.Collections.Generic.IEnumerable<string> scopes, string username, string password);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByUsernamePasswordAsync(System.Collections.Generic.IEnumerable<string> scopes, string username, System.Security.SecureString securePassword);
                Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder AcquireTokenInteractive(System.Collections.Generic.IEnumerable<string> scopes);
                Microsoft.Identity.Client.AcquireTokenWithDeviceCodeParameterBuilder AcquireTokenWithDeviceCode(System.Collections.Generic.IEnumerable<string> scopes, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, string extraQueryParameters, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback, System.Threading.CancellationToken cancellationToken);
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, string extraQueryParameters, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback, System.Threading.CancellationToken cancellationToken);
                bool IsSystemWebViewAvailable { get; }
            }
            public interface ITelemetryConfig
            {
                Microsoft.Identity.Client.TelemetryAudienceType AudienceType { get; }
                System.Action<Microsoft.Identity.Client.ITelemetryEventPayload> DispatchAction { get; }
                string SessionId { get; }
            }
            public interface ITelemetryEventPayload
            {
                System.Collections.Generic.IReadOnlyDictionary<string, bool> BoolValues { get; }
                System.Collections.Generic.IReadOnlyDictionary<string, long> Int64Values { get; }
                System.Collections.Generic.IReadOnlyDictionary<string, int> IntValues { get; }
                string Name { get; }
                System.Collections.Generic.IReadOnlyDictionary<string, string> StringValues { get; }
                string ToJsonString();
            }
            public interface ITokenCache
            {
                void Deserialize(byte[] msalV2State);
                void DeserializeAdalV3(byte[] adalV3State);
                void DeserializeMsalV2(byte[] msalV2State);
                void DeserializeMsalV3(byte[] msalV3State, bool shouldClearExistingCache = default(bool));
                void DeserializeUnifiedAndAdalCache(Microsoft.Identity.Client.Cache.CacheData cacheData);
                byte[] Serialize();
                byte[] SerializeAdalV3();
                byte[] SerializeMsalV2();
                byte[] SerializeMsalV3();
                Microsoft.Identity.Client.Cache.CacheData SerializeUnifiedAndAdalCache();
                void SetAfterAccess(Microsoft.Identity.Client.TokenCacheCallback afterAccess);
                void SetAfterAccessAsync(System.Func<Microsoft.Identity.Client.TokenCacheNotificationArgs, System.Threading.Tasks.Task> afterAccess);
                void SetBeforeAccess(Microsoft.Identity.Client.TokenCacheCallback beforeAccess);
                void SetBeforeAccessAsync(System.Func<Microsoft.Identity.Client.TokenCacheNotificationArgs, System.Threading.Tasks.Task> beforeAccess);
                void SetBeforeWrite(Microsoft.Identity.Client.TokenCacheCallback beforeWrite);
                void SetBeforeWriteAsync(System.Func<Microsoft.Identity.Client.TokenCacheNotificationArgs, System.Threading.Tasks.Task> beforeWrite);
            }
            public interface ITokenCacheSerializer
            {
                void DeserializeAdalV3(byte[] adalV3State);
                void DeserializeMsalV2(byte[] msalV2State);
                void DeserializeMsalV3(byte[] msalV3State, bool shouldClearExistingCache = default(bool));
                byte[] SerializeAdalV3();
                byte[] SerializeMsalV2();
                byte[] SerializeMsalV3();
            }
            public interface IUser
            {
                string DisplayableId { get; }
                string Identifier { get; }
                string IdentityProvider { get; }
                string Name { get; }
            }
            namespace Kerberos
            {
                public enum KerberosKeyTypes
                {
                    None = 0,
                    DecCbcCrc = 1,
                    DesCbcMd5 = 3,
                    Aes128CtsHmacSha196 = 17,
                    Aes256CtsHmacSha196 = 18,
                }
                public class KerberosSupplementalTicket
                {
                    public string ClientKey { get => throw null; set { } }
                    public string ClientName { get => throw null; set { } }
                    public KerberosSupplementalTicket() => throw null;
                    public KerberosSupplementalTicket(string errorMessage) => throw null;
                    public string ErrorMessage { get => throw null; set { } }
                    public string KerberosMessageBuffer { get => throw null; set { } }
                    public Microsoft.Identity.Client.Kerberos.KerberosKeyTypes KeyType { get => throw null; set { } }
                    public string Realm { get => throw null; set { } }
                    public string ServicePrincipalName { get => throw null; set { } }
                    public override string ToString() => throw null;
                }
                public static class KerberosSupplementalTicketManager
                {
                    public static Microsoft.Identity.Client.Kerberos.KerberosSupplementalTicket FromIdToken(string idToken) => throw null;
                    public static byte[] GetKerberosTicketFromWindowsTicketCache(string servicePrincipalName) => throw null;
                    public static byte[] GetKerberosTicketFromWindowsTicketCache(string servicePrincipalName, long logonId) => throw null;
                    public static byte[] GetKrbCred(Microsoft.Identity.Client.Kerberos.KerberosSupplementalTicket ticket) => throw null;
                    public static void SaveToWindowsTicketCache(Microsoft.Identity.Client.Kerberos.KerberosSupplementalTicket ticket) => throw null;
                    public static void SaveToWindowsTicketCache(Microsoft.Identity.Client.Kerberos.KerberosSupplementalTicket ticket, long logonId) => throw null;
                }
                public enum KerberosTicketContainer
                {
                    IdToken = 0,
                    AccessToken = 1,
                }
            }
            public delegate void LogCallback(Microsoft.Identity.Client.LogLevel level, string message, bool containsPii);
            public sealed class Logger
            {
                public Logger() => throw null;
                public static bool DefaultLoggingEnabled { get => throw null; set { } }
                public static Microsoft.Identity.Client.LogLevel Level { get => throw null; set { } }
                public static Microsoft.Identity.Client.LogCallback LogCallback { set { } }
                public static bool PiiLoggingEnabled { get => throw null; set { } }
            }
            public enum LogLevel
            {
                Always = -1,
                Error = 0,
                Warning = 1,
                Info = 2,
                Verbose = 3,
            }
            namespace ManagedIdentity
            {
                public enum ManagedIdentitySource
                {
                    None = 0,
                    Imds = 1,
                    AppService = 2,
                    AzureArc = 3,
                    CloudShell = 4,
                    ServiceFabric = 5,
                    DefaultToImds = 6,
                }
            }
            public sealed class ManagedIdentityApplication : Microsoft.Identity.Client.ApplicationBase, Microsoft.Identity.Client.IApplicationBase, Microsoft.Identity.Client.IManagedIdentityApplication
            {
                public Microsoft.Identity.Client.AcquireTokenForManagedIdentityParameterBuilder AcquireTokenForManagedIdentity(string resource) => throw null;
                public static Microsoft.Identity.Client.ManagedIdentity.ManagedIdentitySource GetManagedIdentitySource() => throw null;
            }
            public sealed class ManagedIdentityApplicationBuilder : Microsoft.Identity.Client.BaseAbstractApplicationBuilder<Microsoft.Identity.Client.ManagedIdentityApplicationBuilder>
            {
                public Microsoft.Identity.Client.IManagedIdentityApplication Build() => throw null;
                public static Microsoft.Identity.Client.ManagedIdentityApplicationBuilder Create(Microsoft.Identity.Client.AppConfig.ManagedIdentityId managedIdentityId) => throw null;
                public Microsoft.Identity.Client.ManagedIdentityApplicationBuilder WithTelemetryClient(params Microsoft.IdentityModel.Abstractions.ITelemetryClient[] telemetryClients) => throw null;
            }
            public class Metrics
            {
                public static long TotalAccessTokensFromBroker { get => throw null; }
                public static long TotalAccessTokensFromCache { get => throw null; }
                public static long TotalAccessTokensFromIdP { get => throw null; }
                public static long TotalDurationInMs { get => throw null; }
            }
            public class MsalClaimsChallengeException : Microsoft.Identity.Client.MsalUiRequiredException
            {
                public MsalClaimsChallengeException(string errorCode, string errorMessage) : base(default(string), default(string)) => throw null;
                public MsalClaimsChallengeException(string errorCode, string errorMessage, System.Exception innerException) : base(default(string), default(string)) => throw null;
                public MsalClaimsChallengeException(string errorCode, string errorMessage, System.Exception innerException, Microsoft.Identity.Client.UiRequiredExceptionClassification classification) : base(default(string), default(string)) => throw null;
            }
            public class MsalClientException : Microsoft.Identity.Client.MsalException
            {
                public MsalClientException(string errorCode) => throw null;
                public MsalClientException(string errorCode, string errorMessage) => throw null;
                public MsalClientException(string errorCode, string errorMessage, System.Exception innerException) => throw null;
            }
            public static class MsalError
            {
                public const string AccessDenied = default;
                public const string AccessingWsMetadataExchangeFailed = default;
                public const string AccessTokenTypeMissing = default;
                public const string ActivityRequired = default;
                public const string AdfsNotSupportedWithBroker = default;
                public const string AndroidBrokerOperationFailed = default;
                public const string AndroidBrokerSignatureVerificationFailed = default;
                public const string AuthenticationCanceledError = default;
                public const string AuthenticationFailed = default;
                public const string AuthenticationUiFailed = default;
                public const string AuthenticationUiFailedError = default;
                public const string AuthorityHostMismatch = default;
                public const string AuthorityTenantSpecifiedTwice = default;
                public const string AuthorityTypeMismatch = default;
                public const string AuthorityValidationFailed = default;
                public const string B2CAuthorityHostMismatch = default;
                public const string BrokerApplicationRequired = default;
                public const string BrokerDoesNotSupportPop = default;
                public const string BrokerNonceMismatch = default;
                public const string BrokerRequiredForPop = default;
                public const string BrokerResponseHashMismatch = default;
                public const string BrokerResponseReturnedError = default;
                public const string CannotAccessUserInformationOrUserNotDomainJoined = default;
                public const string CannotInvokeBroker = default;
                public const string CertificateNotRsa = default;
                public const string CertWithoutPrivateKey = default;
                public const string ClientCredentialAuthenticationTypeMustBeDefined = default;
                public const string ClientCredentialAuthenticationTypesAreMutuallyExclusive = default;
                public const string CodeExpired = default;
                public const string CombinedUserAppCacheNotSupported = default;
                public const string CryptographicError = default;
                public const string CurrentBrokerAccount = default;
                public const string CustomMetadataInstanceOrUri = default;
                public const string CustomWebUiRedirectUriMismatch = default;
                public const string CustomWebUiReturnedInvalidUri = default;
                public const string DefaultRedirectUriIsInvalid = default;
                public const string DeviceCertificateNotFound = default;
                public const string DuplicateQueryParameterError = default;
                public const string EncodedTokenTooLong = default;
                public const string ExactlyOneScopeExpected = default;
                public const string ExperimentalFeature = default;
                public const string FailedToAcquireTokenSilentlyFromBroker = default;
                public const string FailedToGetBrokerResponse = default;
                public const string FailedToRefreshToken = default;
                public const string FederatedServiceReturnedError = default;
                public const string GetUserNameFailed = default;
                public const string HttpListenerError = default;
                public const string HttpStatusCodeNotOk = default;
                public const string HttpStatusNotFound = default;
                public const string InitializeProcessSecurityError = default;
                public const string IntegratedWindowsAuthenticationFailed = default;
                public const string IntegratedWindowsAuthNotSupportedForManagedUser = default;
                public const string InteractionRequired = default;
                public const string InternalError = default;
                public const string InvalidAdalCacheMultipleRTs = default;
                public const string InvalidAuthority = default;
                public const string InvalidAuthorityType = default;
                public const string InvalidAuthorizationUri = default;
                public const string InvalidClient = default;
                public const string InvalidGrantError = default;
                public const string InvalidInstance = default;
                public const string InvalidJsonClaimsFormat = default;
                public const string InvalidJwtError = default;
                public const string InvalidManagedIdentityEndpoint = default;
                public const string InvalidManagedIdentityResponse = default;
                public const string InvalidOwnerWindowType = default;
                public const string InvalidRequest = default;
                public const string InvalidTokenProviderResponseValue = default;
                public const string InvalidUserInstanceMetadata = default;
                public const string JsonParseError = default;
                public const string LinuxXdgOpen = default;
                public const string LoopbackRedirectUri = default;
                public const string LoopbackResponseUriMismatch = default;
                public const string ManagedIdentityRequestFailed = default;
                public const string ManagedIdentityUnreachableNetwork = default;
                public const string MissingFederationMetadataUrl = default;
                public const string MissingPassiveAuthEndpoint = default;
                public const string MultipleAccountsForLoginHint = default;
                public const string MultipleTokensMatchedError = default;
                public const string NetworkNotAvailableError = default;
                public const string NoAccountForLoginHint = default;
                public const string NoAndroidBrokerAccountFound = default;
                public const string NoAndroidBrokerInstalledOnDevice = default;
                public const string NoClientId = default;
                public const string NonceRequiredForPopOnPCA = default;
                public const string NonHttpsRedirectNotSupported = default;
                public const string NonParsableOAuthError = default;
                public const string NoPromptFailedError = default;
                public const string NoRedirectUri = default;
                public const string NoTokensFoundError = default;
                public const string NoUsernameOrAccountIDProvidedForSilentAndroidBrokerAuthentication = default;
                public const string NullIntentReturnedFromAndroidBroker = default;
                public const string OboCacheKeyNotInCacheError = default;
                public const string ParsingWsMetadataExchangeFailed = default;
                public const string ParsingWsTrustResponseFailed = default;
                public const string PasswordRequiredForManagedUserError = default;
                public const string PlatformNotSupported = default;
                public const string RedirectUriValidationFailed = default;
                public const string RegionalAndAuthorityOverride = default;
                public const string RegionalAuthorityValidation = default;
                public const string RegionDiscoveryFailed = default;
                public const string RegionDiscoveryNotEnabled = default;
                public const string RegionDiscoveryWithCustomInstanceMetadata = default;
                public const string RequestThrottled = default;
                public const string RequestTimeout = default;
                public const string RopcDoesNotSupportMsaAccounts = default;
                public const string ScopesRequired = default;
                public const string ServiceNotAvailable = default;
                public const string SetCiamAuthorityAtRequestLevelNotSupported = default;
                public const string SSHCertUsedAsHttpHeader = default;
                public const string StateMismatchError = default;
                public const string StaticCacheWithExternalSerialization = default;
                public const string SystemWebviewOptionsNotApplicable = default;
                public const string TelemetryConfigOrTelemetryCallback = default;
                public const string TenantDiscoveryFailedError = default;
                public const string TenantOverrideNonAad = default;
                public const string TokenCacheNullError = default;
                public const string TokenTypeMismatch = default;
                public const string UapCannotFindDomainUser = default;
                public const string UapCannotFindUpn = default;
                public const string UnableToParseAuthenticationHeader = default;
                public const string UnauthorizedClient = default;
                public const string UnknownBrokerError = default;
                public const string UnknownError = default;
                public const string UnknownManagedIdentityError = default;
                public const string UnknownUser = default;
                public const string UnknownUserType = default;
                public const string UpnRequired = default;
                public const string UserAssertionNullError = default;
                public const string UserAssignedManagedIdentityNotConfigurableAtRuntime = default;
                public const string UserAssignedManagedIdentityNotSupported = default;
                public const string UserMismatch = default;
                public const string UserNullError = default;
                public const string UserRealmDiscoveryFailed = default;
                public const string ValidateAuthorityOrCustomMetadata = default;
                public const string WABError = default;
                public const string WamFailedToSignout = default;
                public const string WamInteractiveError = default;
                public const string WamNoB2C = default;
                public const string WamPickerError = default;
                public const string WamScopesRequired = default;
                public const string WamUiThread = default;
                public const string WebView2LoaderNotFound = default;
                public const string WebView2NotInstalled = default;
                public const string WebviewUnavailable = default;
                public const string WsTrustEndpointNotFoundInMetadataDocument = default;
            }
            public class MsalException : System.Exception
            {
                public System.Collections.Generic.IReadOnlyDictionary<string, string> AdditionalExceptionData { get => throw null; set { } }
                public const string BrokerErrorCode = default;
                public const string BrokerErrorContext = default;
                public const string BrokerErrorStatus = default;
                public const string BrokerErrorTag = default;
                public const string BrokerTelemetry = default;
                public string CorrelationId { get => throw null; set { } }
                public MsalException() => throw null;
                public MsalException(string errorCode) => throw null;
                public MsalException(string errorCode, string errorMessage) => throw null;
                public MsalException(string errorCode, string errorMessage, System.Exception innerException) => throw null;
                public string ErrorCode { get => throw null; }
                public static Microsoft.Identity.Client.MsalException FromJsonString(string json) => throw null;
                public bool IsRetryable { get => throw null; set { } }
                public const string ManagedIdentitySource = default;
                public string ToJsonString() => throw null;
                public override string ToString() => throw null;
            }
            public class MsalManagedIdentityException : Microsoft.Identity.Client.MsalServiceException
            {
                public MsalManagedIdentityException(string errorCode, string errorMessage, Microsoft.Identity.Client.ManagedIdentity.ManagedIdentitySource source) : base(default(string), default(string)) => throw null;
                public MsalManagedIdentityException(string errorCode, string errorMessage, Microsoft.Identity.Client.ManagedIdentity.ManagedIdentitySource source, int statusCode) : base(default(string), default(string)) => throw null;
                public MsalManagedIdentityException(string errorCode, string errorMessage, System.Exception innerException, Microsoft.Identity.Client.ManagedIdentity.ManagedIdentitySource source, int statusCode) : base(default(string), default(string)) => throw null;
                public MsalManagedIdentityException(string errorCode, string errorMessage, System.Exception innerException, Microsoft.Identity.Client.ManagedIdentity.ManagedIdentitySource source) : base(default(string), default(string)) => throw null;
                public Microsoft.Identity.Client.ManagedIdentity.ManagedIdentitySource ManagedIdentitySource { get => throw null; }
                protected override void UpdateIsRetryable() => throw null;
            }
            public class MsalServiceException : Microsoft.Identity.Client.MsalException
            {
                public string Claims { get => throw null; }
                public MsalServiceException(string errorCode, string errorMessage) => throw null;
                public MsalServiceException(string errorCode, string errorMessage, int statusCode) => throw null;
                public MsalServiceException(string errorCode, string errorMessage, System.Exception innerException) => throw null;
                public MsalServiceException(string errorCode, string errorMessage, int statusCode, System.Exception innerException) => throw null;
                public MsalServiceException(string errorCode, string errorMessage, int statusCode, string claims, System.Exception innerException) => throw null;
                public System.Net.Http.Headers.HttpResponseHeaders Headers { get => throw null; set { } }
                public string ResponseBody { get => throw null; set { } }
                public int StatusCode { get => throw null; }
                public override string ToString() => throw null;
                protected virtual void UpdateIsRetryable() => throw null;
            }
            public class MsalThrottledServiceException : Microsoft.Identity.Client.MsalServiceException
            {
                public MsalThrottledServiceException(Microsoft.Identity.Client.MsalServiceException originalException) : base(default(string), default(string)) => throw null;
                public Microsoft.Identity.Client.MsalServiceException OriginalServiceException { get => throw null; }
            }
            public class MsalThrottledUiRequiredException : Microsoft.Identity.Client.MsalUiRequiredException
            {
                public MsalThrottledUiRequiredException(Microsoft.Identity.Client.MsalUiRequiredException originalException) : base(default(string), default(string)) => throw null;
                public Microsoft.Identity.Client.MsalUiRequiredException OriginalServiceException { get => throw null; }
            }
            public class MsalUiRequiredException : Microsoft.Identity.Client.MsalServiceException
            {
                public Microsoft.Identity.Client.UiRequiredExceptionClassification Classification { get => throw null; }
                public MsalUiRequiredException(string errorCode, string errorMessage) : base(default(string), default(string)) => throw null;
                public MsalUiRequiredException(string errorCode, string errorMessage, System.Exception innerException) : base(default(string), default(string)) => throw null;
                public MsalUiRequiredException(string errorCode, string errorMessage, System.Exception innerException, Microsoft.Identity.Client.UiRequiredExceptionClassification classification) : base(default(string), default(string)) => throw null;
            }
            public static partial class OsCapabilitiesExtensions
            {
                public static System.Security.Cryptography.X509Certificates.X509Certificate2 GetCertificate(this Microsoft.Identity.Client.IConfidentialClientApplication confidentialClientApplication) => throw null;
                public static bool IsEmbeddedWebViewAvailable(this Microsoft.Identity.Client.IPublicClientApplication publicClientApplication) => throw null;
                public static bool IsSystemWebViewAvailable(this Microsoft.Identity.Client.IPublicClientApplication publicClientApplication) => throw null;
                public static bool IsUserInteractive(this Microsoft.Identity.Client.IPublicClientApplication publicClientApplication) => throw null;
            }
            namespace Platforms
            {
                namespace Features
                {
                    namespace DesktopOs
                    {
                        namespace Kerberos
                        {
                            public abstract class Credential
                            {
                                protected Credential() => throw null;
                                public static Microsoft.Identity.Client.Platforms.Features.DesktopOs.Kerberos.Credential Current() => throw null;
                            }
                        }
                    }
                }
            }
            public struct Prompt
            {
                public static readonly Microsoft.Identity.Client.Prompt Consent;
                public static readonly Microsoft.Identity.Client.Prompt Create;
                public override bool Equals(object obj) => throw null;
                public static readonly Microsoft.Identity.Client.Prompt ForceLogin;
                public override int GetHashCode() => throw null;
                public static readonly Microsoft.Identity.Client.Prompt NoPrompt;
                public static bool operator ==(Microsoft.Identity.Client.Prompt x, Microsoft.Identity.Client.Prompt y) => throw null;
                public static bool operator !=(Microsoft.Identity.Client.Prompt x, Microsoft.Identity.Client.Prompt y) => throw null;
                public static readonly Microsoft.Identity.Client.Prompt SelectAccount;
            }
            public sealed class PublicClientApplication : Microsoft.Identity.Client.ClientApplicationBase, Microsoft.Identity.Client.IApplicationBase, Microsoft.Identity.Client.IByRefreshToken, Microsoft.Identity.Client.IClientApplicationBase, Microsoft.Identity.Client.IPublicClientApplication
            {
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.UIParent parent) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.UIParent parent) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.UIParent parent) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, Microsoft.Identity.Client.UIParent parent) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, Microsoft.Identity.Client.UIParent parent) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string loginHint, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority, Microsoft.Identity.Client.UIParent parent) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Client.IAccount account, Microsoft.Identity.Client.Prompt prompt, string extraQueryParameters, System.Collections.Generic.IEnumerable<string> extraScopesToConsent, string authority, Microsoft.Identity.Client.UIParent parent) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByIntegratedWindowsAuthParameterBuilder AcquireTokenByIntegratedWindowsAuth(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByIntegratedWindowsAuthAsync(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByIntegratedWindowsAuthAsync(System.Collections.Generic.IEnumerable<string> scopes, string username) => throw null;
                Microsoft.Identity.Client.AcquireTokenByRefreshTokenParameterBuilder Microsoft.Identity.Client.IByRefreshToken.AcquireTokenByRefreshToken(System.Collections.Generic.IEnumerable<string> scopes, string refreshToken) => throw null;
                System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> Microsoft.Identity.Client.IByRefreshToken.AcquireTokenByRefreshTokenAsync(System.Collections.Generic.IEnumerable<string> scopes, string refreshToken) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByUsernamePasswordParameterBuilder AcquireTokenByUsernamePassword(System.Collections.Generic.IEnumerable<string> scopes, string username, System.Security.SecureString password) => throw null;
                public Microsoft.Identity.Client.AcquireTokenByUsernamePasswordParameterBuilder AcquireTokenByUsernamePassword(System.Collections.Generic.IEnumerable<string> scopes, string username, string password) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenByUsernamePasswordAsync(System.Collections.Generic.IEnumerable<string> scopes, string username, System.Security.SecureString securePassword) => throw null;
                public Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder AcquireTokenInteractive(System.Collections.Generic.IEnumerable<string> scopes) => throw null;
                public Microsoft.Identity.Client.AcquireTokenWithDeviceCodeParameterBuilder AcquireTokenWithDeviceCode(System.Collections.Generic.IEnumerable<string> scopes, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, string extraQueryParameters, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback, System.Threading.CancellationToken cancellationToken) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.Client.AuthenticationResult> AcquireTokenWithDeviceCodeAsync(System.Collections.Generic.IEnumerable<string> scopes, string extraQueryParameters, System.Func<Microsoft.Identity.Client.DeviceCodeResult, System.Threading.Tasks.Task> deviceCodeResultCallback, System.Threading.CancellationToken cancellationToken) => throw null;
                public PublicClientApplication(string clientId) => throw null;
                public PublicClientApplication(string clientId, string authority) => throw null;
                public PublicClientApplication(string clientId, string authority, Microsoft.Identity.Client.TokenCache userTokenCache) => throw null;
                public bool IsBrokerAvailable() => throw null;
                public bool IsEmbeddedWebViewAvailable() => throw null;
                public bool IsProofOfPossessionSupportedByClient() => throw null;
                public bool IsSystemWebViewAvailable { get => throw null; }
                public bool IsUserInteractive() => throw null;
                public static Microsoft.Identity.Client.IAccount OperatingSystemAccount { get => throw null; }
            }
            public sealed class PublicClientApplicationBuilder : Microsoft.Identity.Client.AbstractApplicationBuilder<Microsoft.Identity.Client.PublicClientApplicationBuilder>
            {
                public Microsoft.Identity.Client.IPublicClientApplication Build() => throw null;
                public static Microsoft.Identity.Client.PublicClientApplicationBuilder Create(string clientId) => throw null;
                public static Microsoft.Identity.Client.PublicClientApplicationBuilder CreateWithApplicationOptions(Microsoft.Identity.Client.PublicClientApplicationOptions options) => throw null;
                public bool IsBrokerAvailable() => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithBroker(bool enableBroker = default(bool)) => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithDefaultRedirectUri() => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithIosKeychainSecurityGroup(string keychainSecurityGroup) => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithKerberosTicketClaim(string servicePrincipalName, Microsoft.Identity.Client.Kerberos.KerberosTicketContainer ticketContainer) => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithMultiCloudSupport(bool enableMultiCloudSupport) => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithOidcAuthority(string authorityUri) => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithParentActivityOrWindow(System.Func<object> parentActivityOrWindowFunc) => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithParentActivityOrWindow(System.Func<nint> windowFunc) => throw null;
                public Microsoft.Identity.Client.PublicClientApplicationBuilder WithWindowsBrokerOptions(Microsoft.Identity.Client.WindowsBrokerOptions options) => throw null;
            }
            public static partial class PublicClientApplicationExtensions
            {
                public static bool IsProofOfPossessionSupportedByClient(this Microsoft.Identity.Client.IPublicClientApplication app) => throw null;
            }
            public class PublicClientApplicationOptions : Microsoft.Identity.Client.ApplicationOptions
            {
                public PublicClientApplicationOptions() => throw null;
            }
            namespace Region
            {
                public enum RegionOutcome
                {
                    None = 0,
                    UserProvidedValid = 1,
                    UserProvidedAutodetectionFailed = 2,
                    UserProvidedInvalid = 3,
                    AutodetectSuccess = 4,
                    FallbackToGlobal = 5,
                }
            }
            public class RegionDetails
            {
                public string AutoDetectionError { get => throw null; }
                public RegionDetails(Microsoft.Identity.Client.Region.RegionOutcome regionOutcome, string regionUsed, string autoDetectionError) => throw null;
                public Microsoft.Identity.Client.Region.RegionOutcome RegionOutcome { get => throw null; }
                public string RegionUsed { get => throw null; }
            }
            namespace SSHCertificates
            {
                public static partial class SSHExtensions
                {
                    public static Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder WithSSHCertificateAuthenticationScheme(this Microsoft.Identity.Client.AcquireTokenInteractiveParameterBuilder builder, string publicKeyJwk, string keyId) => throw null;
                    public static Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder WithSSHCertificateAuthenticationScheme(this Microsoft.Identity.Client.AcquireTokenSilentParameterBuilder builder, string publicKeyJwk, string keyId) => throw null;
                }
            }
            public class SystemWebViewOptions
            {
                public System.Uri BrowserRedirectError { get => throw null; set { } }
                public System.Uri BrowserRedirectSuccess { get => throw null; set { } }
                public SystemWebViewOptions() => throw null;
                public string HtmlMessageError { get => throw null; set { } }
                public string HtmlMessageSuccess { get => throw null; set { } }
                public bool iOSHidePrivacyPrompt { get => throw null; set { } }
                public System.Func<System.Uri, System.Threading.Tasks.Task> OpenBrowserAsync { get => throw null; set { } }
                public static System.Threading.Tasks.Task OpenWithChromeEdgeBrowserAsync(System.Uri uri) => throw null;
                public static System.Threading.Tasks.Task OpenWithEdgeBrowserAsync(System.Uri uri) => throw null;
            }
            public class Telemetry
            {
                public Telemetry() => throw null;
                public static Microsoft.Identity.Client.Telemetry GetInstance() => throw null;
                public bool HasRegisteredReceiver() => throw null;
                public delegate void Receiver(System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> events);
                public void RegisterReceiver(Microsoft.Identity.Client.Telemetry.Receiver r) => throw null;
                public bool TelemetryOnFailureOnly { get => throw null; set { } }
            }
            public enum TelemetryAudienceType
            {
                PreProduction = 0,
                Production = 1,
            }
            namespace TelemetryCore
            {
                namespace TelemetryClient
                {
                    public class TelemetryData
                    {
                        public Microsoft.Identity.Client.Cache.CacheLevel CacheLevel { get => throw null; set { } }
                        public TelemetryData() => throw null;
                    }
                }
            }
            public class TenantProfile
            {
                public System.Security.Claims.ClaimsPrincipal ClaimsPrincipal { get => throw null; }
                public bool IsHomeTenant { get => throw null; }
                public string Oid { get => throw null; }
                public string TenantId { get => throw null; }
            }
            public sealed class TokenCache : Microsoft.Identity.Client.ITokenCache, Microsoft.Identity.Client.ITokenCacheSerializer
            {
                public TokenCache() => throw null;
                public void Deserialize(byte[] msalV2State) => throw null;
                public void DeserializeAdalV3(byte[] adalV3State) => throw null;
                void Microsoft.Identity.Client.ITokenCacheSerializer.DeserializeAdalV3(byte[] adalV3State) => throw null;
                public void DeserializeMsalV2(byte[] msalV2State) => throw null;
                void Microsoft.Identity.Client.ITokenCacheSerializer.DeserializeMsalV2(byte[] msalV2State) => throw null;
                public void DeserializeMsalV3(byte[] msalV3State, bool shouldClearExistingCache) => throw null;
                void Microsoft.Identity.Client.ITokenCacheSerializer.DeserializeMsalV3(byte[] msalV3State, bool shouldClearExistingCache) => throw null;
                public void DeserializeUnifiedAndAdalCache(Microsoft.Identity.Client.Cache.CacheData cacheData) => throw null;
                public bool HasStateChanged { get => throw null; set { } }
                public byte[] Serialize() => throw null;
                public byte[] SerializeAdalV3() => throw null;
                byte[] Microsoft.Identity.Client.ITokenCacheSerializer.SerializeAdalV3() => throw null;
                public byte[] SerializeMsalV2() => throw null;
                byte[] Microsoft.Identity.Client.ITokenCacheSerializer.SerializeMsalV2() => throw null;
                public byte[] SerializeMsalV3() => throw null;
                byte[] Microsoft.Identity.Client.ITokenCacheSerializer.SerializeMsalV3() => throw null;
                public Microsoft.Identity.Client.Cache.CacheData SerializeUnifiedAndAdalCache() => throw null;
                public void SetAfterAccess(Microsoft.Identity.Client.TokenCacheCallback afterAccess) => throw null;
                public void SetAfterAccessAsync(System.Func<Microsoft.Identity.Client.TokenCacheNotificationArgs, System.Threading.Tasks.Task> afterAccess) => throw null;
                public void SetBeforeAccess(Microsoft.Identity.Client.TokenCacheCallback beforeAccess) => throw null;
                public void SetBeforeAccessAsync(System.Func<Microsoft.Identity.Client.TokenCacheNotificationArgs, System.Threading.Tasks.Task> beforeAccess) => throw null;
                public void SetBeforeWrite(Microsoft.Identity.Client.TokenCacheCallback beforeWrite) => throw null;
                public void SetBeforeWriteAsync(System.Func<Microsoft.Identity.Client.TokenCacheNotificationArgs, System.Threading.Tasks.Task> beforeWrite) => throw null;
                public void SetIosKeychainSecurityGroup(string securityGroup) => throw null;
                public delegate void TokenCacheNotification(Microsoft.Identity.Client.TokenCacheNotificationArgs args);
            }
            public delegate void TokenCacheCallback(Microsoft.Identity.Client.TokenCacheNotificationArgs args);
            public static partial class TokenCacheExtensions
            {
                public static void SetCacheOptions(this Microsoft.Identity.Client.ITokenCache tokenCache, Microsoft.Identity.Client.CacheOptions options) => throw null;
            }
            public sealed class TokenCacheNotificationArgs
            {
                public Microsoft.Identity.Client.IAccount Account { get => throw null; }
                public System.Threading.CancellationToken CancellationToken { get => throw null; }
                public string ClientId { get => throw null; }
                public System.Guid CorrelationId { get => throw null; }
                public TokenCacheNotificationArgs(Microsoft.Identity.Client.ITokenCacheSerializer tokenCache, string clientId, Microsoft.Identity.Client.IAccount account, bool hasStateChanged, bool isApplicationCache, string suggestedCacheKey, bool hasTokens, System.DateTimeOffset? suggestedCacheExpiry, System.Threading.CancellationToken cancellationToken) => throw null;
                public TokenCacheNotificationArgs(Microsoft.Identity.Client.ITokenCacheSerializer tokenCache, string clientId, Microsoft.Identity.Client.IAccount account, bool hasStateChanged, bool isApplicationCache, string suggestedCacheKey, bool hasTokens, System.DateTimeOffset? suggestedCacheExpiry, System.Threading.CancellationToken cancellationToken, System.Guid correlationId) => throw null;
                public TokenCacheNotificationArgs(Microsoft.Identity.Client.ITokenCacheSerializer tokenCache, string clientId, Microsoft.Identity.Client.IAccount account, bool hasStateChanged, bool isApplicationCache, string suggestedCacheKey, bool hasTokens, System.DateTimeOffset? suggestedCacheExpiry, System.Threading.CancellationToken cancellationToken, System.Guid correlationId, System.Collections.Generic.IEnumerable<string> requestScopes, string requestTenantId) => throw null;
                public TokenCacheNotificationArgs(Microsoft.Identity.Client.ITokenCacheSerializer tokenCache, string clientId, Microsoft.Identity.Client.IAccount account, bool hasStateChanged, bool isApplicationCache, string suggestedCacheKey, bool hasTokens, System.DateTimeOffset? suggestedCacheExpiry, System.Threading.CancellationToken cancellationToken, System.Guid correlationId, System.Collections.Generic.IEnumerable<string> requestScopes, string requestTenantId, Microsoft.IdentityModel.Abstractions.IIdentityLogger identityLogger, bool piiLoggingEnabled, Microsoft.Identity.Client.TelemetryCore.TelemetryClient.TelemetryData telemetryData = default(Microsoft.Identity.Client.TelemetryCore.TelemetryClient.TelemetryData)) => throw null;
                public bool HasStateChanged { get => throw null; }
                public bool HasTokens { get => throw null; }
                public Microsoft.IdentityModel.Abstractions.IIdentityLogger IdentityLogger { get => throw null; }
                public bool IsApplicationCache { get => throw null; }
                public bool PiiLoggingEnabled { get => throw null; }
                public System.Collections.Generic.IEnumerable<string> RequestScopes { get => throw null; }
                public string RequestTenantId { get => throw null; }
                public System.DateTimeOffset? SuggestedCacheExpiry { get => throw null; }
                public string SuggestedCacheKey { get => throw null; }
                public Microsoft.Identity.Client.TelemetryCore.TelemetryClient.TelemetryData TelemetryData { get => throw null; }
                public Microsoft.Identity.Client.ITokenCacheSerializer TokenCache { get => throw null; }
                public Microsoft.Identity.Client.IUser User { get => throw null; }
            }
            public enum TokenSource
            {
                IdentityProvider = 0,
                Cache = 1,
                Broker = 2,
            }
            public class TraceTelemetryConfig : Microsoft.Identity.Client.ITelemetryConfig
            {
                public System.Collections.Generic.IEnumerable<string> AllowedScopes { get => throw null; }
                public Microsoft.Identity.Client.TelemetryAudienceType AudienceType { get => throw null; }
                public TraceTelemetryConfig() => throw null;
                public System.Action<Microsoft.Identity.Client.ITelemetryEventPayload> DispatchAction { get => throw null; }
                public string SessionId { get => throw null; }
            }
            public struct UIBehavior
            {
            }
            public sealed class UIParent
            {
                public UIParent() => throw null;
                public UIParent(object parent, bool useEmbeddedWebView) => throw null;
                public static bool IsSystemWebviewAvailable() => throw null;
            }
            public enum UiRequiredExceptionClassification
            {
                None = 0,
                MessageOnly = 1,
                BasicAction = 2,
                AdditionalAction = 3,
                ConsentRequired = 4,
                UserPasswordExpired = 5,
                PromptNeverFailed = 6,
                AcquireTokenSilentFailed = 7,
            }
            public sealed class UserAssertion
            {
                public string Assertion { get => throw null; }
                public string AssertionType { get => throw null; }
                public UserAssertion(string jwtBearerToken) => throw null;
                public UserAssertion(string assertion, string assertionType) => throw null;
            }
            namespace Utils
            {
                namespace Windows
                {
                    public static class WindowsNativeUtils
                    {
                        public static void InitializeProcessSecurity() => throw null;
                        public static bool IsElevatedUser() => throw null;
                    }
                }
            }
            public class WindowsBrokerOptions
            {
                public WindowsBrokerOptions() => throw null;
                public string HeaderText { get => throw null; set { } }
                public bool ListWindowsWorkAndSchoolAccounts { get => throw null; set { } }
                public bool MsaPassthrough { get => throw null; set { } }
            }
            public class WwwAuthenticateParameters
            {
                public string AuthenticationScheme { get => throw null; }
                public string Authority { get => throw null; set { } }
                public string Claims { get => throw null; set { } }
                public static Microsoft.Identity.Client.WwwAuthenticateParameters CreateFromAuthenticationHeaders(System.Net.Http.Headers.HttpResponseHeaders httpResponseHeaders, string scheme) => throw null;
                public static System.Collections.Generic.IReadOnlyList<Microsoft.Identity.Client.WwwAuthenticateParameters> CreateFromAuthenticationHeaders(System.Net.Http.Headers.HttpResponseHeaders httpResponseHeaders) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Identity.Client.WwwAuthenticateParameters> CreateFromAuthenticationResponseAsync(string resourceUri, string scheme, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Identity.Client.WwwAuthenticateParameters> CreateFromAuthenticationResponseAsync(string resourceUri, string scheme, System.Net.Http.HttpClient httpClient, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IReadOnlyList<Microsoft.Identity.Client.WwwAuthenticateParameters>> CreateFromAuthenticationResponseAsync(string resourceUri, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.IReadOnlyList<Microsoft.Identity.Client.WwwAuthenticateParameters>> CreateFromAuthenticationResponseAsync(string resourceUri, System.Net.Http.HttpClient httpClient, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Identity.Client.WwwAuthenticateParameters> CreateFromResourceResponseAsync(string resourceUri) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Identity.Client.WwwAuthenticateParameters> CreateFromResourceResponseAsync(string resourceUri, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Microsoft.Identity.Client.WwwAuthenticateParameters> CreateFromResourceResponseAsync(System.Net.Http.HttpClient httpClient, string resourceUri, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static Microsoft.Identity.Client.WwwAuthenticateParameters CreateFromResponseHeaders(System.Net.Http.Headers.HttpResponseHeaders httpResponseHeaders, string scheme = default(string)) => throw null;
                public static Microsoft.Identity.Client.WwwAuthenticateParameters CreateFromWwwAuthenticateHeaderValue(string wwwAuthenticateValue) => throw null;
                public WwwAuthenticateParameters() => throw null;
                public string Error { get => throw null; set { } }
                public static string GetClaimChallengeFromResponseHeaders(System.Net.Http.Headers.HttpResponseHeaders httpResponseHeaders, string scheme = default(string)) => throw null;
                public string GetTenantId() => throw null;
                public string Nonce { get => throw null; }
                public string Resource { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> Scopes { get => throw null; set { } }
                public string this[string key] { get => throw null; }
            }
        }
    }
}
