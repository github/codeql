// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.S2S.Tokens, Version=3.52.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace S2S
        {
            namespace Logging
            {
                public class S2SEventSource : System.Diagnostics.Tracing.EventSource
                {
                    public System.Diagnostics.Tracing.EventLevel EventLevel { get => throw null; set { } }
                    public static bool HeaderWritten { get => throw null; set { } }
                    public static string HiddenPIIString { get => throw null; }
                    public static Microsoft.IdentityModel.S2S.Logging.S2SEventSource Instance { get => throw null; }
                    public static bool ShowPII { get => throw null; set { } }
                    public void Write(System.Diagnostics.Tracing.EventLevel eventLevel, string message) => throw null;
                    public void Write(System.Diagnostics.Tracing.EventLevel eventLevel, string format, params object[] args) => throw null;
                    public void WriteAlways(string message) => throw null;
                    public void WriteAlways(string format, params object[] args) => throw null;
                    public void WriteCritical(string message) => throw null;
                    public void WriteCritical(string format, params object[] args) => throw null;
                    public void WriteError(string message) => throw null;
                    public void WriteError(string format, params object[] args) => throw null;
                    public void WriteInformation(string message) => throw null;
                    public void WriteInformation(string format, params object[] args) => throw null;
                    public void WriteVerbose(string message) => throw null;
                    public void WriteVerbose(string format, params object[] args) => throw null;
                    public void WriteWarning(string message) => throw null;
                    public void WriteWarning(string format, params object[] args) => throw null;
                }
                public static class S2SLogger
                {
                    public static string FormatInvariant(string format, params object[] args) => throw null;
                    public static void LogAlways(string message) => throw null;
                    public static void LogAlways(string message, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static void LogAlways(string format, params object[] args) => throw null;
                    public static void LogAlways(string format, Microsoft.IdentityModel.Tokens.CallContext context, params object[] args) => throw null;
                    public static System.Exception LogArgumentException(string message, string paramName) => throw null;
                    public static System.Exception LogArgumentNullException(string argument) => throw null;
                    public static System.Exception LogArgumentNullException(string argument, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.EphemeralKeyException LogEphermeralKeyException(string message, Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.EphemeralKeyException LogEphermeralKeyException(string message, Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType, System.Exception innerException, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static void LogError(string message) => throw null;
                    public static void LogError(string message, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static void LogError(string format, params object[] args) => throw null;
                    public static void LogError(string format, Microsoft.IdentityModel.Tokens.CallContext context, params object[] args) => throw null;
                    public static System.Exception LogException(System.Exception ex) => throw null;
                    public static System.Exception LogException(System.Exception ex, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static System.Exception LogException(System.Diagnostics.Tracing.EventLevel eventLevel, System.Exception ex) => throw null;
                    public static System.Exception LogException(System.Diagnostics.Tracing.EventLevel eventLevel, System.Exception ex, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.Abstractions.IIdentityLogger Logger { get => throw null; set { } }
                    public static void LogInformation(string message) => throw null;
                    public static void LogInformation(string message, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static void LogInformation(string format, params object[] args) => throw null;
                    public static void LogInformation(string format, Microsoft.IdentityModel.Tokens.CallContext context, params object[] args) => throw null;
                    public static void LogMessage(System.Diagnostics.Tracing.EventLevel eventLevel, Microsoft.IdentityModel.Tokens.CallContext context, string format, params object[] args) => throw null;
                    public static System.Exception LogS2SAuthenticationException(string message) => throw null;
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationException LogS2SAuthenticationException(string message, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationException LogS2SAuthenticationException(string format, string args) => throw null;
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationException LogS2SAuthenticationException(string format, string args, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationException LogS2SAuthenticationException(string message, Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationException LogS2SAuthenticationException(string message, Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType, System.Exception innerException, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.TokenCreationException LogTokenCreationException(string message) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.TokenValidationException LogTokenValidationException(string message) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.TokenValidationException LogTokenValidationException(string message, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.TokenValidationException LogTokenValidationException(string message, Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static void LogVerbose(string message) => throw null;
                    public static void LogVerbose(string message, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static void LogVerbose(string format, params object[] args) => throw null;
                    public static void LogVerbose(string format, Microsoft.IdentityModel.Tokens.CallContext context, params object[] args) => throw null;
                    public static void LogWarning(string message) => throw null;
                    public static void LogWarning(string message, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public static void LogWarning(string format, params object[] args) => throw null;
                    public static void LogWarning(string format, Microsoft.IdentityModel.Tokens.CallContext context, params object[] args) => throw null;
                    public static object MarkAsNonPII(object arg) => throw null;
                }
                public class TextWriterEventListener : System.Diagnostics.Tracing.EventListener
                {
                    public TextWriterEventListener() => throw null;
                    public TextWriterEventListener(string filePath) => throw null;
                    public TextWriterEventListener(System.IO.StreamWriter streamWriter) => throw null;
                    public static readonly string DefaultLogFileName;
                    public override void Dispose() => throw null;
                    protected override void OnEventWritten(System.Diagnostics.Tracing.EventWrittenEventArgs eventData) => throw null;
                }
            }
            public class S2SAuthenticationException : Microsoft.IdentityModel.S2S.Tokens.AuthenticationException
            {
                public S2SAuthenticationException() => throw null;
                public S2SAuthenticationException(string message) => throw null;
                public S2SAuthenticationException(string message, System.Exception innerException) => throw null;
                protected S2SAuthenticationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            namespace Tokens
            {
                public static class AuthenticationConstants
                {
                    public const string Assertion = default;
                    public const string AT_POP = default;
                    public const string AuthenticationInfo = default;
                    public const string AuthorizationHeader = default;
                    public const string Bearer = default;
                    public const string BearerFormat = default;
                    public const string BearerWithSpace = default;
                    public const string ClientId = default;
                    public const string CorrelationIdOverrideHeader = default;
                    public const string Default = default;
                    public const string DefaultAuthenticationFailureDescription = default;
                    public const string DefaultJsonContentType = default;
                    public const string EncryptionKeysExtension = default;
                    public const string ErrorCodes = default;
                    public const string FormUrlEncodedContentType = default;
                    public const string JwksExtensions = default;
                    public const string MSAuth1_0 = default;
                    public const string MSAuth1_0_AccessToken = default;
                    public const string MSAuth1_0_AccessTokenPrefix = default;
                    public const string MSAUTH1_0_ActorToken = default;
                    public const string MSAUTH1_0_ActorTokenPrefix = default;
                    public const string MSAuth1_0_AtPopFormat = default;
                    public const string MSAuth1_0_PfatFormat = default;
                    public const string MSAUTH1_0_PopToken = default;
                    public const string MSAUTH1_0_PopTokenPrefix = default;
                    public const string MSAuth1_0_StPopFormat = default;
                    public const string MSAuth1_0_Type = default;
                    public const string MSAUTH1_0_TypeEqualsAT_POP = default;
                    public const string MSAUTH1_0_TypeEqualsPFAT = default;
                    public const string MSAUTH1_0_TypeEqualsST_POP = default;
                    public const string OpenIdWellKnownLocation = default;
                    public const string PFAT = default;
                    public const string ST_POP = default;
                    public const string Subassertion = default;
                    public const char TokenSeparator = default;
                    public const string TokenSeparatorString = default;
                    public const string Url = default;
                    public const string V2EndpointAuthorityPattern = default;
                    public const string V2EndpointSuffix = default;
                    public const string VersionClaimType = default;
                    public const string WWWAuthenticate = default;
                }
                public class AuthenticationException : System.Exception
                {
                    public Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AuthenticationFailureType { get => throw null; set { } }
                    public AuthenticationException() => throw null;
                    public AuthenticationException(string message) => throw null;
                    public AuthenticationException(string message, System.Exception innerException) => throw null;
                    protected AuthenticationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public abstract class AuthenticationFailureType
                {
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AccessTokenDecryptionFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AccessTokenNotPFT;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AccessTokenTypeNotDetermined;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AcquireTokenFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ActorTokenAcrInvalid;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ActorTokenClaimNotFound;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ActorTokenDecryptionFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ActorTokenIsNotAppToken;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ActorTokenReadFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AlgorithmNotSupported;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AppAssertedTokensAreNotSupportedByPolicy;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ArgumentNull;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AuthenticationSchemeNotSupported;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AuthenticatorTokenReadFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AuthorizationHeaderEmpty;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AutoKeyRotationNotSupportedForV1;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType BearerMissingToken;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType BearerReadAccessTokenFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType BearerTokenContainsCnf;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType CnfValidatorReturnedFalse;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType CorrelationBetweenActorAndAccessTokens;
                    protected AuthenticationFailureType(string name) => throw null;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType DecryptedAccessTokenNotReadable;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType DecryptedActorTokenNotReadable;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType EnablingBothAppMetadataAndAutoKeyRotationNotSupported;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType EphemeralKeyExpired;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType EphemeralKeyInvalidSignature;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType EphemeralKeyKidNotFound;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType EphemeralKeyMissingExpirationClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType EphemeralKeyNotConvertableToLong;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType GetTokenAcquirerFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InboundPolicyEmpty;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidApplicationId;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidAudience;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidIssuer;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidIssuerAndLifetime;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidIssuerForAllTenants;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidLifeTime;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidSignature;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType InvalidSigningKey;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType KeyWrapFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MissingAuthenticationParameters;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AT_POPMissingAtClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AT_POPMissingPayloadClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AT_POPMissingPopTokenPrefix;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AT_POPReadActorTokenFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AT_POPReadAuthenticatorFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AT_POPReadPayloadTokenFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AT_POPUnknownError;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorExpiredTimestamp;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorHttpRequestDataMissingMethod;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorHttpRequestDataNull;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorHttpRequestDataUriNull;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorInvalidCreationTime;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorInvalidHttpMethodClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorInvalidNumberOfParts;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorInvalidPS256Claim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorInvalidQS256Claim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorMissingHttpMethodClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorMissingPS256Claim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorMissingQS256Claim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorMissingTimestamp;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorSignatureMissing;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthenticatorTypeUnknown;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10AuthentictorInvalidSignature;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10PFAT_AccessTokenPrefixNotFound;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10PFAT_ActorTokenPrefixNotFound;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10PFAT_ReadAccessTokenFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10PFAT_ReadActorTokenFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10PFATAppAssertedTokensAreNotSupported;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10ST_POPCscClaimMissing;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10ST_POPMissingAtClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10ST_POPMissingPopTokenPrefix;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10ST_POPReadActorTokenFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10ST_POPReadAuthenticatorFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType MSAuth10ST_POPUnknown;
                    public string Name { get => throw null; }
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType NoApplicableInboundPoliciesFound;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType NoDecryptionKeysInPolicy;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType NoInboundPolicies;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType NotEvaluated;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ObtainingMetadata;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ObtainMetadataNull;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType OnProtocolEvaluatedEventFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidBClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidHClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidMClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidPClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidQClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidSignature;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidTsClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PopInvalidUClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PoPMissingPayloadClaim;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PoPReadFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PoPReadPayloadFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType PoPTokenNotFound;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ReadAuthenticatorFailed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ServerNonceExpired;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ServerNonceInvalidSignature;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ServerNonceMalformed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ServerNonceMissing;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ServerNonceTsMalformed;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ServerNonceTsMissing;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType SignatureKeyNotFound;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType TokenExpired;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType TokenNoExpiration;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType TokenNotYetValid;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType TokenValidationFailed;
                    public override string ToString() => throw null;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType Unknown;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType UnsupportedAccessTokenType;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType UnsupportedAuthenticationScheme;
                    public static readonly Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType ValidationCompleted;
                }
                public abstract class AuthenticationPolicy
                {
                    public System.Collections.Generic.IList<string> Addresses { get => throw null; }
                    public string Authority { get => throw null; set { } }
                    public System.Collections.Generic.ICollection<Microsoft.Identity.Abstractions.CredentialDescription> ClientCredentials { get => throw null; }
                    public string ClientId { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.BaseConfigurationManager ConfigurationManager { get => throw null; set { } }
                    protected AuthenticationPolicy() => throw null;
                    protected AuthenticationPolicy(string authority, string clientId) => throw null;
                    public bool IsAppMetadata { get => throw null; set { } }
                    public string Label { get => throw null; set { } }
                    public System.TimeSpan MetadataAutomaticRefreshInterval { get => throw null; set { } }
                    public static readonly System.TimeSpan MetadataMaximumAutomaticRefreshInterval;
                    public static readonly System.TimeSpan MetadataMinimumAutomaticRefreshInterval;
                    public string Region { get => throw null; set { } }
                }
                public class AuthenticatorValidationPolicy
                {
                    public System.TimeSpan AuthenticatorLifetime { get => throw null; set { } }
                    public System.TimeSpan ClockSkew { get => throw null; set { } }
                    public AuthenticatorValidationPolicy() => throw null;
                    public static readonly System.TimeSpan DefaultAuthenticatorLifetime;
                    public static readonly System.TimeSpan DefaultClockSkew;
                    public bool ShouldValidateHttpMethod { get => throw null; set { } }
                    public bool ShouldValidatePS256 { get => throw null; set { } }
                    public bool ShouldValidateQS256 { get => throw null; set { } }
                    public bool ShouldValidateTs { get => throw null; set { } }
                }
                public class AuthenticatorValidationResult
                {
                    public string AccessToken { get => throw null; set { } }
                    public string AppToken { get => throw null; set { } }
                    public string Authenticator { get => throw null; set { } }
                    public AuthenticatorValidationResult() => throw null;
                    public System.Exception Exception { get => throw null; set { } }
                    public bool HaveActorAndAccessTokensBeenValidated { get => throw null; set { } }
                    public string PayloadToken { get => throw null; set { } }
                    public string PayloadTokenType { get => throw null; set { } }
                    public string Protocol { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.SecurityToken ValidatedAppToken { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.SecurityToken ValidatedPayloadToken { get => throw null; set { } }
                }
                public class EphemeralKeyException : Microsoft.IdentityModel.S2S.Tokens.AuthenticationException
                {
                    public EphemeralKeyException() => throw null;
                    public EphemeralKeyException(string message) => throw null;
                    public EphemeralKeyException(string message, System.Exception inner) => throw null;
                    protected EphemeralKeyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public System.DateTime Expires { get => throw null; set { } }
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class EvaluationResult
                {
                    public Microsoft.IdentityModel.Tokens.SecurityToken AccessSecurityToken { get => throw null; set { } }
                    public Microsoft.IdentityModel.JsonWebTokens.JsonWebToken AccessToken { get => throw null; }
                    public string AccessTokenVersion { get => throw null; }
                    public Microsoft.IdentityModel.JsonWebTokens.JsonWebToken ActorToken { get => throw null; }
                    public Microsoft.IdentityModel.Tokens.SecurityToken ApplicationToken { get => throw null; set { } }
                    public string AuthenticationFailureMessage { get => throw null; set { } }
                    public Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AuthenticationFailureType { get => throw null; set { } }
                    public string Authenticator { get => throw null; set { } }
                    public Microsoft.IdentityModel.JsonWebTokens.JsonWebToken AuthenticatorToken { get => throw null; }
                    public string AuthorizationHeader { get => throw null; set { } }
                    public EvaluationResult() => throw null;
                    public System.Exception Exception { get => throw null; set { } }
                    public Microsoft.IdentityModel.Protocols.HttpRequestData HttpRequestData { get => throw null; }
                    public string Payload { get => throw null; set { } }
                    public string PayloadTokenType { get => throw null; set { } }
                    public string Protocol { get => throw null; }
                    public string SignedHttpRequest { get => throw null; }
                    public Microsoft.IdentityModel.JsonWebTokens.JsonWebToken SignedHttpRequestToken { get => throw null; }
                    public bool Succeeded { get => throw null; set { } }
                }
                public delegate Microsoft.IdentityModel.Tokens.SigningCredentials GetServerNonceSigningCredentialsForCreation(Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy, System.Threading.CancellationToken cancellationToken);
                public delegate Microsoft.IdentityModel.Tokens.SigningCredentials GetServerNonceSigningCredentialsForValidation(string kid, string serverNonce, Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy, System.Threading.CancellationToken cancellationToken);
                public class GetTokenException : Microsoft.IdentityModel.S2S.Tokens.TokenCreationException
                {
                    public GetTokenException() => throw null;
                    public GetTokenException(string message) => throw null;
                    public GetTokenException(string message, System.Exception innerException) => throw null;
                    protected GetTokenException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class HttpAuthenticatorData
                {
                    public System.Collections.Generic.IDictionary<string, object> AdditionalPayloadClaims { get => throw null; set { } }
                    public string AppToken { get => throw null; set { } }
                    public HttpAuthenticatorData() => throw null;
                    public string HttpMethod { get => throw null; set { } }
                    public string PayloadToken { get => throw null; set { } }
                    public string PayloadTokenType { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.SigningCredentials SigningCredentials { get => throw null; set { } }
                    public System.Uri Uri { get => throw null; set { } }
                }
                public class HttpPolicy
                {
                    public HttpPolicy() => throw null;
                    public HttpPolicy(long maxResponseDataSize, System.TimeSpan timeout) => throw null;
                    public HttpPolicy(System.Net.Http.HttpClient httpClient) => throw null;
                    public static readonly long DefaultMaxResponseDataSize;
                    public static readonly bool DefaultRequireHttps;
                    public static readonly System.TimeSpan DefaultTimeout;
                    public System.Net.Http.HttpClient HttpClient { get => throw null; }
                    public long MaxResponseDataSize { get => throw null; }
                    public bool RequireHttps { get => throw null; set { } }
                    public System.TimeSpan Timeout { get => throw null; }
                }
                public static class HttpPopClaimTypes
                {
                    public const string Aat = default;
                    public const string Ac = default;
                    public const string At = default;
                    public const string Cnf = default;
                    public const string Csc = default;
                    public const string M = default;
                    public const string MsaPdt = default;
                    public const string MsaPt = default;
                    public const string Pft = default;
                    public const string PopJwk = default;
                    public const string PS256 = default;
                    public const string QS256 = default;
                    public const string Ts = default;
                }
                public static class HttpVerbs
                {
                    public const string Get = default;
                    public const string Post = default;
                }
                public class IdentityProviderException : System.Exception
                {
                    public IdentityProviderException() => throw null;
                    public IdentityProviderException(string message) => throw null;
                    public IdentityProviderException(string message, System.Exception innerException) => throw null;
                    protected IdentityProviderException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public string Error { get => throw null; }
                    public string ErrorCodes { get => throw null; }
                    public string ErrorMessage { get => throw null; }
                    public string ErrorUri { get => throw null; }
                    public string RawErrorString { get => throw null; }
                }
                public struct JwtClaimTypes
                {
                    public const string Acr = default;
                    public const string Actort = default;
                    public const string ActorToken = default;
                    public const string Alg = default;
                    public const string Altsecid = default;
                    public const string Amr = default;
                    public const string AppId = default;
                    public const string AppIdAcr = default;
                    public const string AtHash = default;
                    public const string Aud = default;
                    public const string AuthTime = default;
                    public const string Azp = default;
                    public const string AzpAcr = default;
                    public const string Birthdate = default;
                    public const string CHash = default;
                    public const string Cid = default;
                    public const string ClientAppid = default;
                    public const string Cty = default;
                    public const string Email = default;
                    public const string Epk = default;
                    public static System.Collections.Generic.IList<string> ExcludedAppClaims;
                    public const string Exp = default;
                    public const string FamilyName = default;
                    public const string Gender = default;
                    public const string GivenName = default;
                    public const string Iat = default;
                    public const string Idtyp = default;
                    public const string IpAddr = default;
                    public const string IsConsumer = default;
                    public const string Iss = default;
                    public const string Jti = default;
                    public const string Kid = default;
                    public const string Name = default;
                    public const string NameId = default;
                    public const string Nbf = default;
                    public const string Nonce = default;
                    public const string Oid = default;
                    public const string PopJwk = default;
                    public const string Prn = default;
                    public const string Puid = default;
                    public const string Roles = default;
                    public const string Scp = default;
                    public const string Sid = default;
                    public const string Smtp = default;
                    public const string Sub = default;
                    public const string Tid = default;
                    public const string Typ = default;
                    public const string UniqueName = default;
                    public const string Upn = default;
                    public const string Uti = default;
                    public const string Ver = default;
                    public const string Website = default;
                    public const string X5c = default;
                    public const string X5t = default;
                }
                public static class JwtClaimValues
                {
                    public const string App = default;
                    public static System.Collections.Generic.IList<string> FirstPartyMicroServicesTids;
                    public const string JWK = default;
                    public const string JWT = default;
                    public const string TlsTbh = default;
                    public static System.Collections.Generic.IList<string> VaildAzpValues;
                    public static System.Collections.Generic.IList<string> ValidAzpValues;
                    public const string XMS_KSL = default;
                }
                public static class LogMessages
                {
                    public const string S2S10000 = default;
                    public const string S2S10002 = default;
                    public const string S2S10006 = default;
                    public const string S2S10007 = default;
                    public const string S2S10008 = default;
                    public const string S2S11001 = default;
                    public const string S2S11002 = default;
                    public const string S2S32000 = default;
                    public const string S2S32115 = default;
                    public const string S2S32116 = default;
                    public const string S2S32118 = default;
                    public const string S2S32119 = default;
                    public const string S2S32120 = default;
                    public const string S2S32202 = default;
                    public const string S2S32205 = default;
                    public const string S2S32206 = default;
                    public const string S2S32210 = default;
                    public const string S2S32211 = default;
                    public const string S2S32212 = default;
                    public const string S2S32300 = default;
                    public const string S2S32301 = default;
                    public const string S2S32400 = default;
                    public const string S2S32401 = default;
                    public const string S2S32402 = default;
                    public const string S2S32403 = default;
                    public const string S2S32404 = default;
                    public const string S2S32405 = default;
                    public const string S2S32406 = default;
                    public const string S2S32407 = default;
                    public const string S2S32408 = default;
                    public const string S2S32409 = default;
                    public const string S2S32410 = default;
                    public const string S2S32411 = default;
                    public const string S2S32412 = default;
                    public const string S2S32413 = default;
                    public const string S2S32414 = default;
                    public const string S2S32415 = default;
                    public const string S2S32416 = default;
                    public const string S2S32417 = default;
                    public const string S2S32501 = default;
                    public const string S2S32502 = default;
                    public const string S2S32600 = default;
                    public const string S2S32602 = default;
                    public const string S2S32603 = default;
                    public const string S2S32650 = default;
                    public const string S2S32651 = default;
                    public const string S2S32652 = default;
                    public const string S2S32653 = default;
                    public const string S2S32654 = default;
                    public const string S2S32655 = default;
                    public const string S2S32656 = default;
                    public const string S2S32657 = default;
                    public const string S2S32700 = default;
                    public const string S2S32702 = default;
                    public const string S2S32703 = default;
                    public const string S2S32800 = default;
                    public const string S2S32900 = default;
                    public const string S2S33001 = default;
                    public const string S2S33002 = default;
                    public const string S2S33003 = default;
                    public const string S2S33004 = default;
                    public const string S2S33005 = default;
                    public const string S2S33006 = default;
                    public const string S2S33009 = default;
                    public const string S2S33010 = default;
                    public const string S2S33011 = default;
                    public const string S2S33012 = default;
                    public const string S2S33013 = default;
                    public const string S2S33101 = default;
                    public const string S2S33102 = default;
                    public const string S2S33103 = default;
                    public const string S2S33104 = default;
                    public const string S2S33105 = default;
                    public const string S2S33106 = default;
                    public const string S2S33107 = default;
                    public const string S2S33108 = default;
                    public const string S2S33109 = default;
                    public const string S2S33110 = default;
                }
                public class MetadataManager
                {
                    protected virtual Microsoft.IdentityModel.Protocols.IDocumentRetriever CreateDocumentRetriever(Microsoft.IdentityModel.S2S.Tokens.AuthenticationPolicy policy, System.Collections.Generic.IDictionary<string, string> additionalHeaderData = default(System.Collections.Generic.IDictionary<string, string>)) => throw null;
                    public MetadataManager() => throw null;
                    public MetadataManager(Microsoft.IdentityModel.S2S.Tokens.HttpPolicy httpPolicy) => throw null;
                    public MetadataManager(Microsoft.IdentityModel.S2S.Tokens.HttpPolicy httpPolicy, Microsoft.IdentityModel.S2S.Tokens.MetadataManagerCacheOptions metadataManagerCacheOptions) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> GetOidcConfigurationAsync(string authority) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> GetOidcConfigurationAsync(string authority, System.Threading.CancellationToken cancellationToken) => throw null;
                    public Microsoft.IdentityModel.Protocols.IConfigurationManager<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> GetOidcConfigurationManager(string authority) => throw null;
                    public readonly Microsoft.IdentityModel.S2S.Tokens.HttpPolicy HttpPolicy;
                    public void SetOidcConfigurationManager(string authority, Microsoft.IdentityModel.Protocols.IConfigurationManager<Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration> configurationManager) => throw null;
                    public bool TryRemoveOidcConfigurationManager(string authority) => throw null;
                }
                public class MetadataManagerCacheOptions
                {
                    public MetadataManagerCacheOptions() => throw null;
                    public static readonly int DefaultSizeLimit;
                    public static readonly int MinimumSizeLimit;
                    public int SizeLimit { get => throw null; set { } }
                }
                public static class OAuthResponseParameterNames
                {
                    public const string AccessToken = default;
                    public const string ExpiresIn = default;
                    public const string ExpiresOn = default;
                    public const string ExtendedExpiresIn = default;
                    public const string NotBefore = default;
                    public const string RefreshIn = default;
                    public const string Resource = default;
                    public const string TokenType = default;
                    public const string UserType = default;
                }
                public class PolicyEvaluationException : Microsoft.IdentityModel.S2S.Tokens.AuthenticationException
                {
                    public PolicyEvaluationException() => throw null;
                    public PolicyEvaluationException(string message) => throw null;
                    public PolicyEvaluationException(string message, System.Exception innerException) => throw null;
                    protected PolicyEvaluationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class ServerNoncePolicy
                {
                    public ServerNoncePolicy(Microsoft.IdentityModel.Tokens.SigningCredentials serverNonceSigningCredentials) => throw null;
                    public ServerNoncePolicy(Microsoft.IdentityModel.S2S.Tokens.GetServerNonceSigningCredentialsForCreation createServerNonceSigningCredentials, Microsoft.IdentityModel.S2S.Tokens.GetServerNonceSigningCredentialsForValidation getServerNonceSigningCredentials) => throw null;
                    public static readonly System.TimeSpan DefaultServerNonceLifetime;
                    public Microsoft.IdentityModel.S2S.Tokens.GetServerNonceSigningCredentialsForCreation GetSigningCredentialsForCreation { get => throw null; }
                    public Microsoft.IdentityModel.S2S.Tokens.GetServerNonceSigningCredentialsForValidation GetSigningCredentialsForValidation { get => throw null; }
                    public static readonly System.TimeSpan MinimumServerNonceLifetime;
                    public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; }
                    public bool RequireServerNonceInSHR { get => throw null; set { } }
                    public bool SendServerNonceOn200 { get => throw null; set { } }
                    public System.TimeSpan ServerNonceLifetime { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.SigningCredentials ServerNonceSigningCredentials { get => throw null; }
                }
                public class TokenAcquireException : Microsoft.IdentityModel.S2S.Tokens.AuthenticationException
                {
                    public TokenAcquireException() => throw null;
                    public TokenAcquireException(string message) => throw null;
                    public TokenAcquireException(string message, System.Exception innerException) => throw null;
                    protected TokenAcquireException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class TokenAcquisitionParameters
                {
                    public System.Collections.Generic.IDictionary<string, string> AdditionalAppTokenParameters { get => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> AdditionalHeaders { get => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> AdditionalQueryParameters { get => throw null; }
                    public TokenAcquisitionParameters() => throw null;
                    public TokenAcquisitionParameters(System.Collections.Generic.IDictionary<string, string> additionalQueryParameters, System.Collections.Generic.IDictionary<string, string> additionalAppTokenParameters) => throw null;
                    public TokenAcquisitionParameters(System.Collections.Generic.IDictionary<string, string> additionalQueryParameters, System.Collections.Generic.IDictionary<string, string> additionalAppTokenParameters, System.Collections.Generic.IDictionary<string, string> additionalHeaders) => throw null;
                    public const long DefaultTokenLifetime = 600;
                    public bool IsOAuth2ClientCredFlow { get => throw null; set { } }
                    public bool ReturnHttpResponse { get => throw null; set { } }
                    public bool SendHttpContentAsJson { get => throw null; set { } }
                    public long TokenLifetime { get => throw null; set { } }
                }
                public class TokenCacheException : Microsoft.IdentityModel.S2S.Tokens.AuthenticationException
                {
                    public TokenCacheException() => throw null;
                    public TokenCacheException(string message) => throw null;
                    public TokenCacheException(string message, System.Exception innerException) => throw null;
                    protected TokenCacheException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class TokenCacheItem
                {
                    public string CacheKey { get => throw null; set { } }
                    public Microsoft.IdentityModel.Tokens.SigningCredentials ClientCredentials { get => throw null; }
                    public string ClientId { get => throw null; }
                    public TokenCacheItem(string tokenEndpoint, string clientId, string resource, System.DateTime expires, string token, Microsoft.IdentityModel.Tokens.SigningCredentials clientCrentials) => throw null;
                    public TokenCacheItem(string tokenEndpoint, string clientId, string resource, System.DateTime expires, System.DateTime refreshAt, string token, Microsoft.IdentityModel.Tokens.SigningCredentials clientCrentials) => throw null;
                    public TokenCacheItem(string tokenEndpoint, string clientId, string resource, System.DateTime expires, string token, Microsoft.IdentityModel.Tokens.SigningCredentials clientCrentials, Microsoft.IdentityModel.Tokens.SigningCredentials popCredentials) => throw null;
                    public TokenCacheItem(string tokenEndpoint, string clientId, string resource, System.DateTime expires, System.DateTime refreshAt, string token, Microsoft.IdentityModel.Tokens.SigningCredentials clientCrentials, Microsoft.IdentityModel.Tokens.SigningCredentials popCredentials) => throw null;
                    public System.DateTime Expires { get => throw null; }
                    public System.Net.Http.HttpResponseMessage HttpResponse { get => throw null; }
                    public Microsoft.IdentityModel.Tokens.SigningCredentials PopCredentials { get => throw null; }
                    public System.DateTime RefreshAt { get => throw null; }
                    public string Resource { get => throw null; }
                    public string Token { get => throw null; }
                    public string TokenEndpoint { get => throw null; }
                }
                public class TokenCacheOptions
                {
                    public TokenCacheOptions() => throw null;
                    public static readonly System.TimeSpan DefaultExtendExpirationTimeBy;
                    public static readonly int DefaultSizeLimit;
                    public System.TimeSpan ExtendExpirationTimeBy { get => throw null; set { } }
                    public int SizeLimit { get => throw null; set { } }
                }
                public class TokenCreationException : Microsoft.IdentityModel.S2S.Tokens.AuthenticationException
                {
                    public TokenCreationException() => throw null;
                    public TokenCreationException(string message) => throw null;
                    public TokenCreationException(string message, System.Exception innerException) => throw null;
                    protected TokenCreationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class TokenCreator
                {
                    public static string CreateAppAssertedUserMsServiceTokenV1Business(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, System.Collections.Generic.IDictionary<string, string> userClaims, string scp, string tenantIdentifier, string clientAppId) => throw null;
                    public static string CreateAppAssertedUserMsServiceTokenV1BusinessCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, System.Collections.Generic.IDictionary<string, string> userClaims, string scp, string tenantIdentifier, string clientAppId) => throw null;
                    public static string CreateAppAssertedUserMsServiceTokenV1Consumer(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, System.Collections.Generic.IDictionary<string, string> userClaims, string scp, string clientAppId) => throw null;
                    public static string CreateAppAssertedUserMsServiceTokenV1ConsumerCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, System.Collections.Generic.IDictionary<string, string> userClaims, string scp, string clientAppId) => throw null;
                    public static string CreateAppAssertedUserTokenV1(string accessToken, string appToken) => throw null;
                    public static string CreateAppAssertedUserTokenV1(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                    public static string CreateAppAssertedUserTokenV1(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, System.Collections.Generic.IDictionary<string, string> userClaims, string scp, string clientAppId) => throw null;
                    public static string CreateAppAssertedUserTokenV1Compact(string accessToken, string appToken) => throw null;
                    public static string CreateAppAssertedUserTokenV1Compact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                    public static string CreateAppAssertedUserTokenV1Compact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, System.Collections.Generic.IDictionary<string, string> userClaims, string scp, string clientAppId) => throw null;
                    public static string CreateBearerHeader(string token) => throw null;
                    public static string CreateHttpAuthenticator(Microsoft.IdentityModel.S2S.Tokens.HttpAuthenticatorData httpAuthenticatorData) => throw null;
                    public static string CreateHttpAuthenticator(string appToken, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                    public static string CreateHttpAuthenticator(string appToken, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, System.Collections.Generic.IDictionary<string, object> additionalPayloadClaims) => throw null;
                    public System.Threading.Tasks.Task<string> CreateHttpAuthenticatorAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Threading.Tasks.Task<string> CreateHttpAuthenticatorAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task<string> CreateHttpAuthenticatorAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public System.Threading.Tasks.Task<string> CreateHttpAuthenticatorAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, object> additionalPayloadClaims) => throw null;
                    public System.Threading.Tasks.Task<string> CreateHttpAuthenticatorAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, object> additionalPayloadClaims, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task<string> CreateHttpAuthenticatorAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, object> additionalPayloadClaims, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public static string CreateJWS(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                    public static string CreateJWS(string payload, string header, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                    public static string CreateMSAuth1_0AT_POPHeader(string authenticator) => throw null;
                    public static string CreateMSAuth1_0PFATHeader(string accessToken, string appToken) => throw null;
                    public static string CreateMSAuth1_0ST_POPHeader(string authenticator) => throw null;
                    public System.Threading.Tasks.Task<string> CreateMSAuth10AtPopHeaderAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                    public System.Threading.Tasks.Task<string> CreateMSAuth10AtPopHeaderAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task<string> CreateMSAuth10AtPopHeaderAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public System.Threading.Tasks.Task<string> CreateMSAuth10AtPopHeaderAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, object> additionalPayloadClaims) => throw null;
                    public System.Threading.Tasks.Task<string> CreateMSAuth10AtPopHeaderAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, object> additionalPayloadClaims, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task<string> CreateMSAuth10AtPopHeaderAsync(string authority, string clientId, string resource, string payloadToken, string payloadTokenType, System.Uri uri, string httpMethod, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate, System.Collections.Generic.IDictionary<string, object> additionalPayloadClaims, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public static string CreateProtectedForwardedToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                    public static string CreateServerNonce(Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static string CreateServiceAssertedAppMsServiceTokenV1Business(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, string[] roles, string tenantIdentifier, string clientAppId) => throw null;
                    public static string CreateServiceAssertedAppMsServiceTokenV1BusinessCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, string[] roles, string tenantIdentifier, string clientAppId) => throw null;
                    public static string CreateServiceAssertedAppMsServiceTokenV1Consumer(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, string[] roles, string clientAppId) => throw null;
                    public static string CreateServiceAssertedAppMsServiceTokenV1ConsumerCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, string[] roles, string clientAppId) => throw null;
                    public static string CreateServiceAssertedAppTokenV1(string accessToken, string appToken) => throw null;
                    public static string CreateServiceAssertedAppTokenV1(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                    public static string CreateServiceAssertedAppTokenV1(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, string[] roles, string clientAppId) => throw null;
                    public static string CreateServiceAssertedAppTokenV1Compact(string accessToken, string appToken) => throw null;
                    public static string CreateServiceAssertedAppTokenV1Compact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                    public static string CreateServiceAssertedAppTokenV1Compact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken, string[] roles, string clientAppId) => throw null;
                    public static string CreateSignedHttpRequestHeader(Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestDescriptor signedHttpRequestDescriptor, Microsoft.IdentityModel.Tokens.CallContext callcontext) => throw null;
                    public TokenCreator() => throw null;
                    public TokenCreator(Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager) => throw null;
                    public readonly Microsoft.IdentityModel.S2S.Tokens.TokenManager TokenManager;
                    public static string TransformProtectedForwardedToken(string token) => throw null;
                    public static readonly string WellKnownMsaConsumerTenantId;
                }
                public class TokenManager
                {
                    public void CacheAppToken(string authority, string clientId, string resource, System.DateTime expiration, string token, Microsoft.IdentityModel.Tokens.SigningCredentials clientCredentials) => throw null;
                    public void CacheAppToken(string authority, string clientId, string resource, System.DateTime expiration, string token, Microsoft.IdentityModel.Tokens.SigningCredentials clientCredentials, Microsoft.IdentityModel.Tokens.SigningCredentials popCredentials) => throw null;
                    public TokenManager() => throw null;
                    public TokenManager(Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager) => throw null;
                    public TokenManager(Microsoft.IdentityModel.S2S.Tokens.TokenCacheOptions tokenCacheOptions) => throw null;
                    public TokenManager(Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager, Microsoft.IdentityModel.S2S.Tokens.TokenCacheOptions tokenCacheOptions) => throw null;
                    public TokenManager(Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager, Microsoft.IdentityModel.S2S.Tokens.TokenCacheOptions tokenCacheOptions, Microsoft.IdentityModel.Abstractions.ITelemetryClient telemetryClient) => throw null;
                    public TokenManager(Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager, Microsoft.IdentityModel.S2S.Tokens.TokenCacheOptions tokenCacheOptions, System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Abstractions.ITelemetryClient> telemetryClients) => throw null;
                    public static readonly System.TimeSpan DefaultPopKeyRefreshInterval;
                    public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> ExchangePftTokenForOboToken(string tokenEndpoint, string clientId, string resourceOrScope, string pftToken, string actorToken, Microsoft.IdentityModel.Tokens.SigningCredentials clientCredentials, bool includeX5cClaim) => throw null;
                    public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> ExchangePftTokenForOboToken(string tokenEndpoint, string clientId, string resourceOrScope, string pftToken, string actorToken, Microsoft.IdentityModel.Tokens.SigningCredentials clientCredentials, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> ExchangePftTokenForOboToken(string tokenEndpoint, string clientId, string resourceOrScope, string pftToken, string actorToken, Microsoft.IdentityModel.Tokens.SigningCredentials clientCredentials, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters, Microsoft.IdentityModel.Tokens.CallContext context) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> GetTokenFromAuthorityAsync(string authority, string clientId, string resource, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, bool sendPublicKey) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> GetTokenFromAuthorityAsync(string authority, string clientId, string resource, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, bool sendPublicKey, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> GetTokenFromAuthorityAsync(string authority, string clientId, string resource, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, bool sendPublicKey, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> GetTokenFromTokenEndpointAsync(string tokenEndpoint, string clientId, string resource, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, bool sendPublicKey) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> GetTokenFromTokenEndpointAsync(string tokenEndpoint, string clientId, string resource, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, bool sendPublicKey, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem> GetTokenFromTokenEndpointAsync(string tokenEndpoint, string clientId, string resource, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, bool sendPublicKey, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public Microsoft.IdentityModel.S2S.Tokens.HttpPolicy HttpPolicy { get => throw null; }
                    public readonly Microsoft.IdentityModel.S2S.Tokens.MetadataManager MetadataManager;
                    public System.TimeSpan PopKeyRefreshInterval { get => throw null; set { } }
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.UpdateAppTokenCacheResult> TryUpdateAppToken(Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem tokenItemToUpdate) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.UpdateAppTokenCacheResult> TryUpdateAppToken(Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem tokenItemToUpdate, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.UpdateAppTokenCacheResult> TryUpdateAppToken(Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem tokenItemToUpdate, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.UpdateAppTokenCacheResult> TryUpdateAppToken(Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem tokenItemToUpdate, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public System.Threading.Tasks.Task UpdateAppTokenCache(int seconds) => throw null;
                    public System.Threading.Tasks.Task UpdateAppTokenCache(int seconds, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                    public System.Threading.Tasks.Task UpdateAppTokenCache(int seconds, bool includeX5cClaim) => throw null;
                    public System.Threading.Tasks.Task UpdateAppTokenCache(int seconds, bool includeX5cClaim, Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters tokenAcquisitionParameters) => throw null;
                }
                public static class TokenUtilities
                {
                    public static string AddBearerPrefix(string token) => throw null;
                    public static string CreateCnfClaim(Microsoft.IdentityModel.Tokens.RsaSecurityKey key) => throw null;
                    public static string CreateCnfClaim(Microsoft.IdentityModel.Tokens.RsaSecurityKey key, string algorithm) => throw null;
                    public static string CreateHashOfHeaderNames(string name, System.Collections.Generic.IList<System.Collections.Generic.KeyValuePair<string, string>> headers) => throw null;
                    public static string CreateHashOfQueryStrings(string name, System.Collections.Specialized.NameValueCollection queryValues) => throw null;
                    public static string CreateJwkClaim(Microsoft.IdentityModel.Tokens.RsaSecurityKey key, string algorithm) => throw null;
                    public static Microsoft.IdentityModel.Tokens.RsaSecurityKey CreateRsaSecurityKey() => throw null;
                    public static bool IsProtectedForwardableToken(string token) => throw null;
                    public static bool IsProtectedForwardableToken(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken token) => throw null;
                    public static void ThrowIfNull(object obj, string name) => throw null;
                    public static string TrimBearerPrefix(string token) => throw null;
                }
                public class TokenValidationException : Microsoft.IdentityModel.S2S.Tokens.AuthenticationException
                {
                    public TokenValidationException() => throw null;
                    public TokenValidationException(string message) => throw null;
                    public TokenValidationException(string message, System.Exception innerException) => throw null;
                    protected TokenValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class TokenValidator
                {
                    public TokenValidator() => throw null;
                    public TokenValidator(Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager) => throw null;
                    public static System.Collections.Generic.IDictionary<string, string> HashAlgorithmMap;
                    public static bool IsAppOnlyToken(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                    public static bool IsCorrelationBetweenActorAndDelegationTokensValid(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken actorToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken delegationToken) => throw null;
                    public static bool IsSignatureValid(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public static bool IsWellFormedJsonWebToken(string token) => throw null;
                    public readonly Microsoft.IdentityModel.S2S.Tokens.MetadataManager MetadataManager;
                    public static Microsoft.IdentityModel.S2S.Tokens.AuthenticatorValidationResult ValidateAuthenticator(System.Collections.Specialized.NameValueCollection httpHeaders, System.Uri uri, string httpMethod) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.AuthenticatorValidationResult ValidateAuthenticator(string authenticator, System.Uri uri, string httpMethod) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.AuthenticatorValidationResult ValidateAuthenticator(string authenticator, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.Tokens.AuthenticatorValidationPolicy authenticatorValidationPolicy) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.Tokens.AuthenticatorValidationResult> ValidateAuthenticatorAsync(System.Collections.Specialized.NameValueCollection httpHeaders, System.Uri uri, string httpMethod, string authority, string audience) => throw null;
                    public static void ValidateCorrelationBetweenActorAndDelegationTokens(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken actorToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken delegationToken) => throw null;
                    public static void ValidateIsAppOnlyToken(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                    public static Microsoft.IdentityModel.JsonWebTokens.JsonWebToken ValidatePFTSignature(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.TokenValidationResult> ValidatePFTTokenAsync(string token, string authority, string audience) => throw null;
                    public static Microsoft.IdentityModel.S2S.Tokens.EvaluationResult ValidateServerNonce(string serverNonce, Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy, System.Threading.CancellationToken cancellationToken) => throw null;
                    public static Microsoft.IdentityModel.JsonWebTokens.JsonWebToken ValidateSignature(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public static Microsoft.IdentityModel.Tokens.TokenValidationResult ValidateToken(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public static Microsoft.IdentityModel.Tokens.TokenValidationResult ValidateToken(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, Microsoft.IdentityModel.Protocols.OpenIdConnect.OpenIdConnectConfiguration openIdConnectConfiguration) => throw null;
                    public static Microsoft.IdentityModel.Tokens.TokenValidationResult ValidateToken(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.TokenValidationResult> ValidateTokenAsync(string token, string authority, string audience) => throw null;
                }
                public static class TokenVersions
                {
                    public const string AppAssertedUserTokenMsServiceV1 = default;
                    public const string AppAssertedUserTokenV1 = default;
                    public const string ServiceAssertedAppTokenMsServiceV1 = default;
                    public const string ServiceAssertedAppTokenV1 = default;
                    public const string StiAppAssertedUserTokenV1 = default;
                    public const string StiServiceAssertedAppTokenV1 = default;
                    public const string Version1_0 = default;
                    public const string Version2_0 = default;
                }
                public class UpdateAppTokenCacheResult
                {
                    public UpdateAppTokenCacheResult(Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem tokenCacheItem) => throw null;
                    public UpdateAppTokenCacheResult(System.Exception exception) => throw null;
                    public System.Exception Exception { get => throw null; }
                    public bool IsValid { get => throw null; }
                    public Microsoft.IdentityModel.S2S.Tokens.TokenCacheItem TokenCacheItem { get => throw null; }
                }
            }
        }
        namespace Tokens
        {
            public class EphemeralKeyInvalidSignatureException : Microsoft.IdentityModel.S2S.Tokens.EphemeralKeyException
            {
                public EphemeralKeyInvalidSignatureException() => throw null;
                public EphemeralKeyInvalidSignatureException(string message) => throw null;
                public EphemeralKeyInvalidSignatureException(string message, System.Exception innerException) => throw null;
                protected EphemeralKeyInvalidSignatureException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            public class EpkSignatureKeyNotFoundException : Microsoft.IdentityModel.S2S.Tokens.EphemeralKeyException
            {
                public EpkSignatureKeyNotFoundException() => throw null;
                public EpkSignatureKeyNotFoundException(string message) => throw null;
                public EpkSignatureKeyNotFoundException(string message, System.Exception innerException) => throw null;
                protected EpkSignatureKeyNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
            namespace S2S
            {
                namespace Tokens
                {
                    public class EphemeralKeyExpiredException : Microsoft.IdentityModel.S2S.Tokens.EphemeralKeyException
                    {
                        public EphemeralKeyExpiredException() => throw null;
                        public EphemeralKeyExpiredException(string message) => throw null;
                        protected EphemeralKeyExpiredException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                        public EphemeralKeyExpiredException(string message, System.Exception inner) => throw null;
                    }
                    public class EphemeralKeyNoExpirationException : Microsoft.IdentityModel.S2S.Tokens.EphemeralKeyException
                    {
                        public EphemeralKeyNoExpirationException() => throw null;
                        public EphemeralKeyNoExpirationException(string message) => throw null;
                        public EphemeralKeyNoExpirationException(string message, System.Exception innerException) => throw null;
                        protected EphemeralKeyNoExpirationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    }
                }
            }
        }
    }
}
