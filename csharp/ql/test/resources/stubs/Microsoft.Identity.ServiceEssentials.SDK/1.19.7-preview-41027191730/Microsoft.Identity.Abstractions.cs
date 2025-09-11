// This file contains auto-generated code.
// Generated from `Microsoft.Identity.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=0a613f4dd989e8ae`.
namespace Microsoft
{
    namespace Identity
    {
        namespace Abstractions
        {
            public class AcquireTokenOptions
            {
                public string AuthenticationOptionsName { get => throw null; set { } }
                public string Claims { get => throw null; set { } }
                public virtual Microsoft.Identity.Abstractions.AcquireTokenOptions Clone() => throw null;
                public System.Guid? CorrelationId { get => throw null; set { } }
                public AcquireTokenOptions() => throw null;
                public AcquireTokenOptions(Microsoft.Identity.Abstractions.AcquireTokenOptions other) => throw null;
                public System.Collections.Generic.IDictionary<string, string> ExtraHeadersParameters { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> ExtraQueryParameters { get => throw null; set { } }
                public bool ForceRefresh { get => throw null; set { } }
                public string LongRunningWebApiSessionKey { get => throw null; set { } }
                public static string LongRunningWebApiSessionKeyAuto { get => throw null; }
                public string PopClaim { get => throw null; set { } }
                public string PopPublicKey { get => throw null; set { } }
                public string Tenant { get => throw null; set { } }
                public string UserFlow { get => throw null; set { } }
            }
            public class AcquireTokenResult
            {
                public string AccessToken { get => throw null; set { } }
                public System.Guid CorrelationId { get => throw null; set { } }
                public AcquireTokenResult(string accessToken, System.DateTimeOffset expiresOn, string tenantId, string idToken, System.Collections.Generic.IEnumerable<string> scopes, System.Guid correlationId, string tokenType) => throw null;
                public System.DateTimeOffset ExpiresOn { get => throw null; set { } }
                public string IdToken { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> Scopes { get => throw null; set { } }
                public string TenantId { get => throw null; set { } }
                public string TokenType { get => throw null; set { } }
            }
            public class AuthorizationHeaderProviderOptions
            {
                public Microsoft.Identity.Abstractions.AcquireTokenOptions AcquireTokenOptions { get => throw null; set { } }
                public string BaseUrl { get => throw null; set { } }
                public Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions Clone() => throw null;
                protected virtual Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions CloneInternal() => throw null;
                public AuthorizationHeaderProviderOptions() => throw null;
                public AuthorizationHeaderProviderOptions(Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions other) => throw null;
                public System.Action<System.Net.Http.HttpRequestMessage> CustomizeHttpRequestMessage { get => throw null; set { } }
                public string GetApiUrl() => throw null;
                public string HttpMethod { get => throw null; set { } }
                public string ProtocolScheme { get => throw null; set { } }
                public string RelativePath { get => throw null; set { } }
                public bool RequestAppToken { get => throw null; set { } }
            }
            public class CredentialDescription
            {
                public string Base64EncodedValue { get => throw null; set { } }
                public virtual object CachedValue { get => throw null; set { } }
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; set { } }
                public string CertificateDiskPath { get => throw null; set { } }
                public string CertificateDistinguishedName { get => throw null; set { } }
                public string CertificatePassword { get => throw null; set { } }
                public string CertificateStorePath { get => throw null; set { } }
                public string CertificateThumbprint { get => throw null; set { } }
                public string ClientSecret { get => throw null; set { } }
                public string Container { get => throw null; set { } }
                public Microsoft.Identity.Abstractions.CredentialType CredentialType { get => throw null; }
                public CredentialDescription() => throw null;
                public Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions DecryptKeysAuthenticationOptions { get => throw null; set { } }
                public string Id { get => throw null; }
                public string KeyVaultCertificateName { get => throw null; set { } }
                public string KeyVaultUrl { get => throw null; set { } }
                public string ManagedIdentityClientId { get => throw null; set { } }
                public string ReferenceOrValue { get => throw null; set { } }
                public string SignedAssertionFileDiskPath { get => throw null; set { } }
                public bool Skip { get => throw null; set { } }
                public Microsoft.Identity.Abstractions.CredentialSource SourceType { get => throw null; set { } }
            }
            public enum CredentialSource
            {
                Certificate = 0,
                KeyVault = 1,
                Base64Encoded = 2,
                Path = 3,
                StoreWithThumbprint = 4,
                StoreWithDistinguishedName = 5,
                ClientSecret = 6,
                SignedAssertionFromManagedIdentity = 7,
                SignedAssertionFilePath = 8,
                SignedAssertionFromVault = 9,
                AutoDecryptKeys = 10,
            }
            public class CredentialSourceLoaderParameters
            {
                public string Authority { get => throw null; set { } }
                public string ClientId { get => throw null; set { } }
                public CredentialSourceLoaderParameters(string clientId, string authority) => throw null;
            }
            public enum CredentialType
            {
                Certificate = 0,
                Secret = 1,
                SignedAssertion = 2,
                DecryptKeys = 3,
            }
            public class DownstreamApiOptions : Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions
            {
                public Microsoft.Identity.Abstractions.DownstreamApiOptions Clone() => throw null;
                protected override Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions CloneInternal() => throw null;
                public DownstreamApiOptions() => throw null;
                public DownstreamApiOptions(Microsoft.Identity.Abstractions.DownstreamApiOptions other) => throw null;
                public System.Func<System.Net.Http.HttpContent, object> Deserializer { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> Scopes { get => throw null; set { } }
                public System.Func<object, System.Net.Http.HttpContent> Serializer { get => throw null; set { } }
            }
            public class DownstreamApiOptionsReadOnlyHttpMethod : Microsoft.Identity.Abstractions.DownstreamApiOptions
            {
                public Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod Clone() => throw null;
                protected override Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions CloneInternal() => throw null;
                public DownstreamApiOptionsReadOnlyHttpMethod(Microsoft.Identity.Abstractions.DownstreamApiOptions options, string httpMethod) => throw null;
                public string HttpMethod { get => throw null; }
            }
            public interface IAuthorizationHeaderProvider
            {
                System.Threading.Tasks.Task<string> CreateAuthorizationHeaderForAppAsync(string scopes, Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions downstreamApiOptions = default(Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<string> CreateAuthorizationHeaderForUserAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions authorizationHeaderProviderOptions = default(Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions), System.Security.Claims.ClaimsPrincipal claimsPrincipal = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface ICredentialsLoader
            {
                System.Collections.Generic.IDictionary<Microsoft.Identity.Abstractions.CredentialSource, Microsoft.Identity.Abstractions.ICredentialSourceLoader> CredentialSourceLoaders { get; }
                System.Threading.Tasks.Task LoadCredentialsIfNeededAsync(Microsoft.Identity.Abstractions.CredentialDescription credentialDescription, Microsoft.Identity.Abstractions.CredentialSourceLoaderParameters parameters = default(Microsoft.Identity.Abstractions.CredentialSourceLoaderParameters));
                System.Threading.Tasks.Task<Microsoft.Identity.Abstractions.CredentialDescription> LoadFirstValidCredentialsAsync(System.Collections.Generic.IEnumerable<Microsoft.Identity.Abstractions.CredentialDescription> credentialDescriptions, Microsoft.Identity.Abstractions.CredentialSourceLoaderParameters parameters = default(Microsoft.Identity.Abstractions.CredentialSourceLoaderParameters));
                void ResetCredentials(System.Collections.Generic.IEnumerable<Microsoft.Identity.Abstractions.CredentialDescription> credentialDescriptions);
            }
            public interface ICredentialSourceLoader
            {
                Microsoft.Identity.Abstractions.CredentialSource CredentialSource { get; }
                System.Threading.Tasks.Task LoadIfNeededAsync(Microsoft.Identity.Abstractions.CredentialDescription credentialDescription, Microsoft.Identity.Abstractions.CredentialSourceLoaderParameters parameters = default(Microsoft.Identity.Abstractions.CredentialSourceLoaderParameters));
            }
            public class IdentityApplicationOptions
            {
                public bool AllowWebApiToBeAuthorizedByACL { get => throw null; set { } }
                public string Audience { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> Audiences { get => throw null; set { } }
                public virtual string Authority { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<Microsoft.Identity.Abstractions.CredentialDescription> ClientCredentials { get => throw null; set { } }
                public string ClientId { get => throw null; set { } }
                public IdentityApplicationOptions() => throw null;
                public bool EnablePiiLogging { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> ExtraQueryParameters { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<Microsoft.Identity.Abstractions.CredentialDescription> TokenDecryptionCredentials { get => throw null; set { } }
            }
            public interface IDownstreamApi
            {
                System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> CallApiAsync(Microsoft.Identity.Abstractions.DownstreamApiOptions downstreamApiOptions, System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Net.Http.HttpContent content = default(System.Net.Http.HttpContent), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> CallApiAsync(string serviceName, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Net.Http.HttpContent content = default(System.Net.Http.HttpContent), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> CallApiForAppAsync(string serviceName, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions>), System.Net.Http.HttpContent content = default(System.Net.Http.HttpContent), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> CallApiForAppAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task<TOutput> CallApiForAppAsync<TOutput>(string serviceName, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> CallApiForUserAsync(string serviceName, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Net.Http.HttpContent content = default(System.Net.Http.HttpContent), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> CallApiForUserAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task<TOutput> CallApiForUserAsync<TOutput>(string serviceName, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptions>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task DeleteForAppAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> DeleteForAppAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task DeleteForUserAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> DeleteForUserAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task<TOutput> GetForAppAsync<TOutput>(string serviceName, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task<TOutput> GetForAppAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task<TOutput> GetForUserAsync<TOutput>(string serviceName, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task<TOutput> GetForUserAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task PatchForAppAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> PatchForAppAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task PatchForUserAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> PatchForUserAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task PostForAppAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> PostForAppAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task PostForUserAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> PostForUserAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task PutForAppAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> PutForAppAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
                System.Threading.Tasks.Task PutForUserAsync<TInput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<TOutput> PutForUserAsync<TInput, TOutput>(string serviceName, TInput input, System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod> downstreamApiOptionsOverride = default(System.Action<Microsoft.Identity.Abstractions.DownstreamApiOptionsReadOnlyHttpMethod>), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TOutput : class;
            }
            public interface ITokenAcquirer
            {
                System.Threading.Tasks.Task<Microsoft.Identity.Abstractions.AcquireTokenResult> GetTokenForAppAsync(string scope, Microsoft.Identity.Abstractions.AcquireTokenOptions tokenAcquisitionOptions = default(Microsoft.Identity.Abstractions.AcquireTokenOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<Microsoft.Identity.Abstractions.AcquireTokenResult> GetTokenForUserAsync(System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Abstractions.AcquireTokenOptions tokenAcquisitionOptions = default(Microsoft.Identity.Abstractions.AcquireTokenOptions), System.Security.Claims.ClaimsPrincipal user = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface ITokenAcquirerFactory
            {
                Microsoft.Identity.Abstractions.ITokenAcquirer GetTokenAcquirer(Microsoft.Identity.Abstractions.IdentityApplicationOptions identityApplicationOptions);
                Microsoft.Identity.Abstractions.ITokenAcquirer GetTokenAcquirer(string optionName = default(string));
            }
            public class MicrosoftIdentityApplicationOptions : Microsoft.Identity.Abstractions.IdentityApplicationOptions
            {
                public override string Authority { get => throw null; set { } }
                public string AzureRegion { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> ClientCapabilities { get => throw null; set { } }
                public MicrosoftIdentityApplicationOptions() => throw null;
                public string DefaultUserFlow { get => throw null; }
                public string Domain { get => throw null; set { } }
                public string EditProfilePolicyId { get => throw null; set { } }
                public string ErrorPath { get => throw null; set { } }
                public string Instance { get => throw null; set { } }
                public string ResetPasswordPath { get => throw null; set { } }
                public string ResetPasswordPolicyId { get => throw null; set { } }
                public bool SendX5C { get => throw null; set { } }
                public string SignUpSignInPolicyId { get => throw null; set { } }
                public string TenantId { get => throw null; set { } }
                public bool WithSpaAuthCode { get => throw null; set { } }
            }
        }
    }
}
