// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.Protocols.OpenIdConnect, Version=7.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Protocols
        {
            namespace OpenIdConnect
            {
                public static class ActiveDirectoryOpenIdConnectEndpoints
                {
                    public const string Authorize = default;
                    public const string Logout = default;
                    public const string Token = default;
                }
                namespace Configuration
                {
                    public class OpenIdConnectConfigurationValidator : Microsoft.IdentityModel.Protocols.IConfigurationValidator<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration>
                    {
                        public OpenIdConnectConfigurationValidator() => throw null;
                        public int MinimumNumberOfKeys { get => throw null; set { } }
                        public Microsoft.IdentityModel.Protocols.ConfigurationValidationResult Validate(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration openIdConnectConfiguration) => throw null;
                    }
                }
                public delegate void IdTokenValidator(System.IdentityModel.Tokens.Jwt.JwtSecurityToken idToken, Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext context);
                public class OpenIdConnectConfiguration : Microsoft.IdentityModel.Tokens.BaseConfiguration
                {
                    public System.Collections.Generic.ICollection<string> AcrValuesSupported { get => throw null; }
                    public override string ActiveTokenEndpoint { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, object> AdditionalData { get => throw null; }
                    public string AuthorizationEndpoint { get => throw null; set { } }
                    public string CheckSessionIframe { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> ClaimsLocalesSupported { get => throw null; }
                    public bool ClaimsParameterSupported { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> ClaimsSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> ClaimTypesSupported { get => throw null; }
                    public static Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration Create(string json) => throw null;
                    public OpenIdConnectConfiguration() => throw null;
                    public OpenIdConnectConfiguration(string json) => throw null;
                    public System.Collections.Generic.ICollection<string> DisplayValuesSupported { get => throw null; }
                    public string EndSessionEndpoint { get => throw null; set { } }
                    public string FrontchannelLogoutSessionSupported { get => throw null; set { } }
                    public string FrontchannelLogoutSupported { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> GrantTypesSupported { get => throw null; }
                    public bool HttpLogoutSupported { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> IdTokenEncryptionAlgValuesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> IdTokenEncryptionEncValuesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> IdTokenSigningAlgValuesSupported { get => throw null; }
                    public string IntrospectionEndpoint { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> IntrospectionEndpointAuthMethodsSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> IntrospectionEndpointAuthSigningAlgValuesSupported { get => throw null; }
                    public override string Issuer { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.JsonWebKeySet JsonWebKeySet { get => throw null; set { } }
                    public string JwksUri { get => throw null; set { } }
                    public bool LogoutSessionSupported { get => throw null; set { } }
                    public string OpPolicyUri { get => throw null; set { } }
                    public string OpTosUri { get => throw null; set { } }
                    public string RegistrationEndpoint { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> RequestObjectEncryptionAlgValuesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> RequestObjectEncryptionEncValuesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> RequestObjectSigningAlgValuesSupported { get => throw null; }
                    public bool RequestParameterSupported { get => throw null; set { } }
                    public bool RequestUriParameterSupported { get => throw null; set { } }
                    public bool RequireRequestUriRegistration { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> ResponseModesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> ResponseTypesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> ScopesSupported { get => throw null; }
                    public string ServiceDocumentation { get => throw null; set { } }
                    public bool ShouldSerializeAcrValuesSupported() => throw null;
                    public bool ShouldSerializeClaimsLocalesSupported() => throw null;
                    public bool ShouldSerializeClaimsSupported() => throw null;
                    public bool ShouldSerializeClaimTypesSupported() => throw null;
                    public bool ShouldSerializeDisplayValuesSupported() => throw null;
                    public bool ShouldSerializeGrantTypesSupported() => throw null;
                    public bool ShouldSerializeIdTokenEncryptionAlgValuesSupported() => throw null;
                    public bool ShouldSerializeIdTokenEncryptionEncValuesSupported() => throw null;
                    public bool ShouldSerializeIdTokenSigningAlgValuesSupported() => throw null;
                    public bool ShouldSerializeIntrospectionEndpointAuthMethodsSupported() => throw null;
                    public bool ShouldSerializeIntrospectionEndpointAuthSigningAlgValuesSupported() => throw null;
                    public bool ShouldSerializeRequestObjectEncryptionAlgValuesSupported() => throw null;
                    public bool ShouldSerializeRequestObjectEncryptionEncValuesSupported() => throw null;
                    public bool ShouldSerializeRequestObjectSigningAlgValuesSupported() => throw null;
                    public bool ShouldSerializeResponseModesSupported() => throw null;
                    public bool ShouldSerializeResponseTypesSupported() => throw null;
                    public bool ShouldSerializeScopesSupported() => throw null;
                    public bool ShouldSerializeSigningKeys() => throw null;
                    public bool ShouldSerializeSubjectTypesSupported() => throw null;
                    public bool ShouldSerializeTokenEndpointAuthMethodsSupported() => throw null;
                    public bool ShouldSerializeTokenEndpointAuthSigningAlgValuesSupported() => throw null;
                    public bool ShouldSerializeUILocalesSupported() => throw null;
                    public bool ShouldSerializeUserInfoEndpointEncryptionAlgValuesSupported() => throw null;
                    public bool ShouldSerializeUserInfoEndpointEncryptionEncValuesSupported() => throw null;
                    public bool ShouldSerializeUserInfoEndpointSigningAlgValuesSupported() => throw null;
                    public override System.Collections.Generic.ICollection<Microsoft.IdentityModel.Tokens.SecurityKey> SigningKeys { get => throw null; }
                    public System.Collections.Generic.ICollection<string> SubjectTypesSupported { get => throw null; }
                    public override string TokenEndpoint { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> TokenEndpointAuthMethodsSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> TokenEndpointAuthSigningAlgValuesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> UILocalesSupported { get => throw null; }
                    public string UserInfoEndpoint { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> UserInfoEndpointEncryptionAlgValuesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> UserInfoEndpointEncryptionEncValuesSupported { get => throw null; }
                    public System.Collections.Generic.ICollection<string> UserInfoEndpointSigningAlgValuesSupported { get => throw null; }
                    public static string Write(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration configuration) => throw null;
                }
                public class OpenIdConnectConfigurationRetriever : Microsoft.IdentityModel.Protocols.IConfigurationRetriever<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration>
                {
                    public OpenIdConnectConfigurationRetriever() => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> GetAsync(string address, System.Threading.CancellationToken cancel) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> GetAsync(string address, System.Net.Http.HttpClient httpClient, System.Threading.CancellationToken cancel) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> GetAsync(string address, Microsoft.IdentityModel.Protocols.IDocumentRetriever retriever, System.Threading.CancellationToken cancel) => throw null;
                    System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> Microsoft.IdentityModel.Protocols.IConfigurationRetriever<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration>.GetConfigurationAsync(string address, Microsoft.IdentityModel.Protocols.IDocumentRetriever retriever, System.Threading.CancellationToken cancel) => throw null;
                }
                public static class OpenIdConnectGrantTypes
                {
                    public const string AuthorizationCode = default;
                    public const string ClientCredentials = default;
                    public const string Password = default;
                    public const string RefreshToken = default;
                }
                public class OpenIdConnectMessage : Microsoft.IdentityModel.Protocols.AuthenticationProtocolMessage
                {
                    public string AccessToken { get => throw null; set { } }
                    public string AcrValues { get => throw null; set { } }
                    public string AuthorizationEndpoint { get => throw null; set { } }
                    public string ClaimsLocales { get => throw null; set { } }
                    public string ClientAssertion { get => throw null; set { } }
                    public string ClientAssertionType { get => throw null; set { } }
                    public string ClientId { get => throw null; set { } }
                    public string ClientSecret { get => throw null; set { } }
                    public virtual Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectMessage Clone() => throw null;
                    public string Code { get => throw null; set { } }
                    public virtual string CreateAuthenticationRequestUrl() => throw null;
                    public virtual string CreateLogoutRequestUrl() => throw null;
                    public OpenIdConnectMessage() => throw null;
                    public OpenIdConnectMessage(string json) => throw null;
                    protected OpenIdConnectMessage(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectMessage other) => throw null;
                    public OpenIdConnectMessage(System.Collections.Specialized.NameValueCollection nameValueCollection) => throw null;
                    public OpenIdConnectMessage(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string[]>> parameters) => throw null;
                    public string Display { get => throw null; set { } }
                    public string DomainHint { get => throw null; set { } }
                    public bool EnableTelemetryParameters { get => throw null; set { } }
                    public static bool EnableTelemetryParametersByDefault { get => throw null; set { } }
                    public string Error { get => throw null; set { } }
                    public string ErrorDescription { get => throw null; set { } }
                    public string ErrorUri { get => throw null; set { } }
                    public string ExpiresIn { get => throw null; set { } }
                    public string GrantType { get => throw null; set { } }
                    public string IdentityProvider { get => throw null; set { } }
                    public string IdToken { get => throw null; set { } }
                    public string IdTokenHint { get => throw null; set { } }
                    public string Iss { get => throw null; set { } }
                    public string LoginHint { get => throw null; set { } }
                    public string MaxAge { get => throw null; set { } }
                    public string Nonce { get => throw null; set { } }
                    public string Password { get => throw null; set { } }
                    public string PostLogoutRedirectUri { get => throw null; set { } }
                    public string Prompt { get => throw null; set { } }
                    public string RedirectUri { get => throw null; set { } }
                    public string RefreshToken { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectRequestType RequestType { get => throw null; set { } }
                    public string RequestUri { get => throw null; set { } }
                    public string Resource { get => throw null; set { } }
                    public string ResponseMode { get => throw null; set { } }
                    public string ResponseType { get => throw null; set { } }
                    public string Scope { get => throw null; set { } }
                    public string SessionState { get => throw null; set { } }
                    public string Sid { get => throw null; set { } }
                    public string SkuTelemetryValue { get => throw null; set { } }
                    public string State { get => throw null; set { } }
                    public string TargetLinkUri { get => throw null; set { } }
                    public string TokenEndpoint { get => throw null; set { } }
                    public string TokenType { get => throw null; set { } }
                    public string UiLocales { get => throw null; set { } }
                    public string UserId { get => throw null; set { } }
                    public string Username { get => throw null; set { } }
                }
                public static class OpenIdConnectParameterNames
                {
                    public const string AccessToken = default;
                    public const string AcrValues = default;
                    public const string ClaimsLocales = default;
                    public const string ClientAssertion = default;
                    public const string ClientAssertionType = default;
                    public const string ClientId = default;
                    public const string ClientSecret = default;
                    public const string Code = default;
                    public const string Display = default;
                    public const string DomainHint = default;
                    public const string Error = default;
                    public const string ErrorDescription = default;
                    public const string ErrorUri = default;
                    public const string ExpiresIn = default;
                    public const string GrantType = default;
                    public const string IdentityProvider = default;
                    public const string IdToken = default;
                    public const string IdTokenHint = default;
                    public const string Iss = default;
                    public const string LoginHint = default;
                    public const string MaxAge = default;
                    public const string Nonce = default;
                    public const string Password = default;
                    public const string PostLogoutRedirectUri = default;
                    public const string Prompt = default;
                    public const string RedirectUri = default;
                    public const string RefreshToken = default;
                    public const string RequestUri = default;
                    public const string Resource = default;
                    public const string ResponseMode = default;
                    public const string ResponseType = default;
                    public const string Scope = default;
                    public const string SessionState = default;
                    public const string Sid = default;
                    public const string SkuTelemetry = default;
                    public const string State = default;
                    public const string TargetLinkUri = default;
                    public const string TokenType = default;
                    public const string UiLocales = default;
                    public const string UserId = default;
                    public const string Username = default;
                    public const string VersionTelemetry = default;
                }
                public static class OpenIdConnectPrompt
                {
                    public const string Consent = default;
                    public const string Login = default;
                    public const string None = default;
                    public const string SelectAccount = default;
                }
                public class OpenIdConnectProtocolException : System.Exception
                {
                    public OpenIdConnectProtocolException() => throw null;
                    public OpenIdConnectProtocolException(string message) => throw null;
                    public OpenIdConnectProtocolException(string message, System.Exception innerException) => throw null;
                    protected OpenIdConnectProtocolException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class OpenIdConnectProtocolInvalidAtHashException : Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolException
                {
                    public OpenIdConnectProtocolInvalidAtHashException() => throw null;
                    public OpenIdConnectProtocolInvalidAtHashException(string message) => throw null;
                    public OpenIdConnectProtocolInvalidAtHashException(string message, System.Exception innerException) => throw null;
                    protected OpenIdConnectProtocolInvalidAtHashException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class OpenIdConnectProtocolInvalidCHashException : Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolException
                {
                    public OpenIdConnectProtocolInvalidCHashException() => throw null;
                    public OpenIdConnectProtocolInvalidCHashException(string message) => throw null;
                    public OpenIdConnectProtocolInvalidCHashException(string message, System.Exception innerException) => throw null;
                    protected OpenIdConnectProtocolInvalidCHashException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class OpenIdConnectProtocolInvalidNonceException : Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolException
                {
                    public OpenIdConnectProtocolInvalidNonceException() => throw null;
                    public OpenIdConnectProtocolInvalidNonceException(string message) => throw null;
                    public OpenIdConnectProtocolInvalidNonceException(string message, System.Exception innerException) => throw null;
                    protected OpenIdConnectProtocolInvalidNonceException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class OpenIdConnectProtocolInvalidStateException : Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolException
                {
                    public OpenIdConnectProtocolInvalidStateException() => throw null;
                    public OpenIdConnectProtocolInvalidStateException(string message) => throw null;
                    public OpenIdConnectProtocolInvalidStateException(string message, System.Exception innerException) => throw null;
                    protected OpenIdConnectProtocolInvalidStateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class OpenIdConnectProtocolValidationContext
                {
                    public string ClientId { get => throw null; set { } }
                    public OpenIdConnectProtocolValidationContext() => throw null;
                    public string Nonce { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectMessage ProtocolMessage { get => throw null; set { } }
                    public string State { get => throw null; set { } }
                    public string UserInfoEndpointResponse { get => throw null; set { } }
                    public System.IdentityModel.Tokens.Jwt.JwtSecurityToken ValidatedIdToken { get => throw null; set { } }
                }
                public class OpenIdConnectProtocolValidator
                {
                    public Microsoft.IdentityModel.Tokens.CryptoProviderFactory CryptoProviderFactory { get => throw null; set { } }
                    public OpenIdConnectProtocolValidator() => throw null;
                    public static readonly System.TimeSpan DefaultNonceLifetime;
                    public virtual string GenerateNonce() => throw null;
                    public virtual System.Security.Cryptography.HashAlgorithm GetHashAlgorithm(string algorithm) => throw null;
                    public System.Collections.Generic.IDictionary<string, string> HashAlgorithmMap { get => throw null; }
                    public Microsoft.IdentityModel.Protocols.OpenIdConnect.IdTokenValidator IdTokenValidator { get => throw null; set { } }
                    public System.TimeSpan NonceLifetime { get => throw null; set { } }
                    public bool RequireAcr { get => throw null; set { } }
                    public bool RequireAmr { get => throw null; set { } }
                    public bool RequireAuthTime { get => throw null; set { } }
                    public bool RequireAzp { get => throw null; set { } }
                    public bool RequireNonce { get => throw null; set { } }
                    public bool RequireState { get => throw null; set { } }
                    public bool RequireStateValidation { get => throw null; set { } }
                    public bool RequireSub { get => throw null; set { } }
                    public static bool RequireSubByDefault { get => throw null; set { } }
                    public bool RequireTimeStampInNonce { get => throw null; set { } }
                    protected virtual void ValidateAtHash(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                    public virtual void ValidateAuthenticationResponse(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                    protected virtual void ValidateCHash(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                    protected virtual void ValidateIdToken(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                    protected virtual void ValidateNonce(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                    protected virtual void ValidateState(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                    public virtual void ValidateTokenResponse(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                    public virtual void ValidateUserInfoResponse(Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectProtocolValidationContext validationContext) => throw null;
                }
                public enum OpenIdConnectRequestType
                {
                    Authentication = 0,
                    Logout = 1,
                    Token = 2,
                }
                public static class OpenIdConnectResponseMode
                {
                    public const string FormPost = default;
                    public const string Fragment = default;
                    public const string Query = default;
                }
                public static class OpenIdConnectResponseType
                {
                    public const string Code = default;
                    public const string CodeIdToken = default;
                    public const string CodeIdTokenToken = default;
                    public const string CodeToken = default;
                    public const string IdToken = default;
                    public const string IdTokenToken = default;
                    public const string None = default;
                    public const string Token = default;
                }
                public static class OpenIdConnectScope
                {
                    public const string Address = default;
                    public const string Email = default;
                    public const string OfflineAccess = default;
                    public const string OpenId = default;
                    public const string OpenIdProfile = default;
                    public const string Phone = default;
                    public const string UserImpersonation = default;
                }
                public static class OpenIdConnectSessionProperties
                {
                    public const string CheckSessionIFrame = default;
                    public const string RedirectUri = default;
                    public const string SessionState = default;
                }
                public static class OpenIdProviderMetadataNames
                {
                    public const string AcrValuesSupported = default;
                    public const string AuthorizationEndpoint = default;
                    public const string CheckSessionIframe = default;
                    public const string ClaimsLocalesSupported = default;
                    public const string ClaimsParameterSupported = default;
                    public const string ClaimsSupported = default;
                    public const string ClaimTypesSupported = default;
                    public const string Discovery = default;
                    public const string DisplayValuesSupported = default;
                    public const string EndSessionEndpoint = default;
                    public const string FrontchannelLogoutSessionSupported = default;
                    public const string FrontchannelLogoutSupported = default;
                    public const string GrantTypesSupported = default;
                    public const string HttpLogoutSupported = default;
                    public const string IdTokenEncryptionAlgValuesSupported = default;
                    public const string IdTokenEncryptionEncValuesSupported = default;
                    public const string IdTokenSigningAlgValuesSupported = default;
                    public const string IntrospectionEndpoint = default;
                    public const string IntrospectionEndpointAuthMethodsSupported = default;
                    public const string IntrospectionEndpointAuthSigningAlgValuesSupported = default;
                    public const string Issuer = default;
                    public const string JwksUri = default;
                    public const string LogoutSessionSupported = default;
                    public const string MicrosoftMultiRefreshToken = default;
                    public const string OpPolicyUri = default;
                    public const string OpTosUri = default;
                    public const string RegistrationEndpoint = default;
                    public const string RequestObjectEncryptionAlgValuesSupported = default;
                    public const string RequestObjectEncryptionEncValuesSupported = default;
                    public const string RequestObjectSigningAlgValuesSupported = default;
                    public const string RequestParameterSupported = default;
                    public const string RequestUriParameterSupported = default;
                    public const string RequireRequestUriRegistration = default;
                    public const string ResponseModesSupported = default;
                    public const string ResponseTypesSupported = default;
                    public const string ScopesSupported = default;
                    public const string ServiceDocumentation = default;
                    public const string SubjectTypesSupported = default;
                    public const string TokenEndpoint = default;
                    public const string TokenEndpointAuthMethodsSupported = default;
                    public const string TokenEndpointAuthSigningAlgValuesSupported = default;
                    public const string UILocalesSupported = default;
                    public const string UserInfoEncryptionAlgValuesSupported = default;
                    public const string UserInfoEncryptionEncValuesSupported = default;
                    public const string UserInfoEndpoint = default;
                    public const string UserInfoSigningAlgValuesSupported = default;
                }
            }
        }
    }
}
