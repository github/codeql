// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.Protocols.SignedHttpRequest, Version=6.34.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Protocols
        {
            namespace SignedHttpRequest
            {
                public delegate System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey>> CnfDecryptionKeysResolverAsync(Microsoft.IdentityModel.Tokens.SecurityToken jweCnf, System.Threading.CancellationToken cancellationToken);
                public static class ConfirmationClaimTypes
                {
                    public const string Cnf = default;
                    public const string Jku = default;
                    public const string Jwe = default;
                    public const string Jwk = default;
                    public const string Kid = default;
                }
                public delegate System.Net.Http.HttpClient HttpClientProvider();
                public delegate bool NonceValidatorAsync(Microsoft.IdentityModel.Tokens.SecurityKey key, Microsoft.IdentityModel.Tokens.SecurityToken signedHttpRequest, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationContext signedHttpRequestValidationContext, System.Threading.CancellationToken cancellationToken);
                public delegate System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.SecurityKey> PopKeyResolverAsync(Microsoft.IdentityModel.Tokens.SecurityToken validatedAccessToken, Microsoft.IdentityModel.Tokens.SecurityToken signedHttpRequest, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationContext signedHttpRequestValidationContext, System.Threading.CancellationToken cancellationToken);
                public delegate System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.SecurityKey> PopKeyResolverFromKeyIdAsync(string kid, Microsoft.IdentityModel.Tokens.SecurityToken validatedAccessToken, Microsoft.IdentityModel.Tokens.SecurityToken signedHttpRequest, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationContext signedHttpRequestValidationContext, System.Threading.CancellationToken cancellationToken);
                public delegate System.Threading.Tasks.Task ReplayValidatorAsync(Microsoft.IdentityModel.Tokens.SecurityToken signedHttpRequest, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationContext signedHttpRequestValidationContext, System.Threading.CancellationToken cancellationToken);
                public delegate System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.SecurityKey> SignatureValidatorAsync(Microsoft.IdentityModel.Tokens.SecurityKey popKey, Microsoft.IdentityModel.Tokens.SecurityToken signedHttpRequest, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationContext signedHttpRequestValidationContext, System.Threading.CancellationToken cancellationToken);
                public static class SignedHttpRequestClaimTypes
                {
                    public const string At = default;
                    public const string B = default;
                    public const string H = default;
                    public const string M = default;
                    public const string Nonce = default;
                    public const string P = default;
                    public const string Q = default;
                    public const string Ts = default;
                    public const string U = default;
                }
                public static class SignedHttpRequestConstants
                {
                    public const string AuthorizationHeader = default;
                    public const string AuthorizationHeaderSchemeName = default;
                    public const string TokenType = default;
                }
                public class SignedHttpRequestCreationException : System.Exception
                {
                    public SignedHttpRequestCreationException() => throw null;
                    public SignedHttpRequestCreationException(string message) => throw null;
                    public SignedHttpRequestCreationException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestCreationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestCreationParameters
                {
                    public bool CreateB { get => throw null; set { } }
                    public bool CreateCnf { get => throw null; set { } }
                    public bool CreateH { get => throw null; set { } }
                    public bool CreateM { get => throw null; set { } }
                    public bool CreateNonce { get => throw null; set { } }
                    public bool CreateP { get => throw null; set { } }
                    public bool CreateQ { get => throw null; set { } }
                    public bool CreateTs { get => throw null; set { } }
                    public bool CreateU { get => throw null; set { } }
                    public SignedHttpRequestCreationParameters() => throw null;
                    public static readonly System.TimeSpan DefaultTimeAdjustment;
                    public System.TimeSpan TimeAdjustment { get => throw null; set { } }
                }
                public class SignedHttpRequestDescriptor
                {
                    public string AccessToken { get => throw null; }
                    public System.Collections.Generic.IDictionary<string, object> AdditionalHeaderClaims { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, object> AdditionalPayloadClaims { get => throw null; set { } }
                    public string CnfClaimValue { get => throw null; set { } }
                    public SignedHttpRequestDescriptor(string accessToken, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                    public SignedHttpRequestDescriptor(string accessToken, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestCreationParameters signedHttpRequestCreationParameters) => throw null;
                    public string CustomNonceValue { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.HttpRequestData HttpRequestData { get => throw null; }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestCreationParameters SignedHttpRequestCreationParameters { get => throw null; }
                    public Microsoft.IdentityModel.Tokens.SigningCredentials SigningCredentials { get => throw null; }
                }
                public class SignedHttpRequestHandler
                {
                    protected virtual string CreateHttpRequestPayload(Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestDescriptor signedHttpRequestDescriptor, Microsoft.IdentityModel.Tokens.CallContext callContext) => throw null;
                    public string CreateSignedHttpRequest(Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestDescriptor signedHttpRequestDescriptor) => throw null;
                    public string CreateSignedHttpRequest(Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestDescriptor signedHttpRequestDescriptor, Microsoft.IdentityModel.Tokens.CallContext callContext) => throw null;
                    public SignedHttpRequestHandler() => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationResult> ValidateSignedHttpRequestAsync(Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationContext signedHttpRequestValidationContext, System.Threading.CancellationToken cancellationToken) => throw null;
                    protected virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.SecurityToken> ValidateSignedHttpRequestPayloadAsync(Microsoft.IdentityModel.Tokens.SecurityToken signedHttpRequest, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationContext signedHttpRequestValidationContext, System.Threading.CancellationToken cancellationToken) => throw null;
                }
                public class SignedHttpRequestInvalidAtClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidAtClaimException() => throw null;
                    public SignedHttpRequestInvalidAtClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidAtClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidAtClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidBClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidBClaimException() => throw null;
                    public SignedHttpRequestInvalidBClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidBClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidBClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidCnfClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidCnfClaimException() => throw null;
                    public SignedHttpRequestInvalidCnfClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidCnfClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidCnfClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidHClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidHClaimException() => throw null;
                    public SignedHttpRequestInvalidHClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidHClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidHClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidMClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidMClaimException() => throw null;
                    public SignedHttpRequestInvalidMClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidMClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidMClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidNonceClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidNonceClaimException() => throw null;
                    public SignedHttpRequestInvalidNonceClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidNonceClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidNonceClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; set { } }
                }
                public class SignedHttpRequestInvalidPClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidPClaimException() => throw null;
                    public SignedHttpRequestInvalidPClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidPClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidPClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidPopKeyException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidPopKeyException() => throw null;
                    public SignedHttpRequestInvalidPopKeyException(string message) => throw null;
                    public SignedHttpRequestInvalidPopKeyException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidPopKeyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidQClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidQClaimException() => throw null;
                    public SignedHttpRequestInvalidQClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidQClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidQClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidSignatureException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidSignatureException() => throw null;
                    public SignedHttpRequestInvalidSignatureException(string message) => throw null;
                    public SignedHttpRequestInvalidSignatureException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidSignatureException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidTsClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidTsClaimException() => throw null;
                    public SignedHttpRequestInvalidTsClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidTsClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidTsClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestInvalidUClaimException : Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationException
                {
                    public SignedHttpRequestInvalidUClaimException() => throw null;
                    public SignedHttpRequestInvalidUClaimException(string message) => throw null;
                    public SignedHttpRequestInvalidUClaimException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestInvalidUClaimException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public static class SignedHttpRequestUtilities
                {
                    public static string CreateJwkClaim(Microsoft.IdentityModel.Tokens.JsonWebKey jsonWebKey) => throw null;
                    public static string CreateSignedHttpRequestHeader(string signedHttpRequest) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.HttpRequestData> ToHttpRequestDataAsync(this System.Net.Http.HttpRequestMessage httpRequestMessage) => throw null;
                }
                public class SignedHttpRequestValidationContext
                {
                    public Microsoft.IdentityModel.Tokens.TokenValidationParameters AccessTokenValidationParameters { get => throw null; }
                    public Microsoft.IdentityModel.Tokens.CallContext CallContext { get => throw null; }
                    public SignedHttpRequestValidationContext(string signedHttpRequest, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.Tokens.TokenValidationParameters accessTokenValidationParameters) => throw null;
                    public SignedHttpRequestValidationContext(string signedHttpRequest, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.Tokens.TokenValidationParameters accessTokenValidationParameters, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationParameters signedHttpRequestValidationParameters) => throw null;
                    public SignedHttpRequestValidationContext(string signedHttpRequest, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.Tokens.TokenValidationParameters accessTokenValidationParameters, Microsoft.IdentityModel.Tokens.CallContext callContext) => throw null;
                    public SignedHttpRequestValidationContext(string signedHttpRequest, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.Tokens.TokenValidationParameters accessTokenValidationParameters, Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationParameters signedHttpRequestValidationParameters, Microsoft.IdentityModel.Tokens.CallContext callContext) => throw null;
                    public Microsoft.IdentityModel.Protocols.HttpRequestData HttpRequestData { get => throw null; }
                    public string SignedHttpRequest { get => throw null; }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationParameters SignedHttpRequestValidationParameters { get => throw null; }
                }
                public class SignedHttpRequestValidationException : System.Exception
                {
                    public SignedHttpRequestValidationException() => throw null;
                    public SignedHttpRequestValidationException(string message) => throw null;
                    public SignedHttpRequestValidationException(string message, System.Exception innerException) => throw null;
                    protected SignedHttpRequestValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class SignedHttpRequestValidationParameters
                {
                    public bool AcceptUnsignedHeaders { get => throw null; set { } }
                    public bool AcceptUnsignedQueryParameters { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<string> AllowedDomainsForJkuRetrieval { get => throw null; }
                    public bool AllowResolvingPopKeyFromJku { get => throw null; set { } }
                    public System.Collections.Generic.IEnumerable<string> ClaimsToValidateWhenPresent { get => throw null; set { } }
                    public System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey> CnfDecryptionKeys { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.CnfDecryptionKeysResolverAsync CnfDecryptionKeysResolverAsync { get => throw null; set { } }
                    public SignedHttpRequestValidationParameters() => throw null;
                    public static readonly System.TimeSpan DefaultSignedHttpRequestLifetime;
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.HttpClientProvider HttpClientProvider { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.NonceValidatorAsync NonceValidatorAsync { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.PopKeyResolverAsync PopKeyResolverAsync { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.PopKeyResolverFromKeyIdAsync PopKeyResolverFromKeyIdAsync { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.ReplayValidatorAsync ReplayValidatorAsync { get => throw null; set { } }
                    public bool RequireHttpsForJkuResourceRetrieval { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignatureValidatorAsync SignatureValidatorAsync { get => throw null; set { } }
                    public System.TimeSpan SignedHttpRequestLifetime { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.TokenHandler TokenHandler { get => throw null; set { } }
                    public bool ValidateB { get => throw null; set { } }
                    public bool ValidateH { get => throw null; set { } }
                    public bool ValidateM { get => throw null; set { } }
                    public bool ValidateP { get => throw null; set { } }
                    public bool ValidatePresentClaims { get => throw null; set { } }
                    public bool ValidateQ { get => throw null; set { } }
                    public bool ValidateTs { get => throw null; set { } }
                    public bool ValidateU { get => throw null; set { } }
                }
                public class SignedHttpRequestValidationResult
                {
                    public Microsoft.IdentityModel.Tokens.TokenValidationResult AccessTokenValidationResult { get => throw null; set { } }
                    public SignedHttpRequestValidationResult() => throw null;
                    public System.Exception Exception { get => throw null; set { } }
                    public bool IsValid { get => throw null; set { } }
                    public string SignedHttpRequest { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.SecurityToken ValidatedSignedHttpRequest { get => throw null; set { } }
                }
            }
        }
    }
}
