// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.S2S, Version=3.52.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Protocol
        {
            namespace Handlers
            {
                public class BearerProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler
                {
                    public override Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; }
                    protected override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, Microsoft.IdentityModel.S2S.S2SOutboundPolicy outboundPolicy, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public BearerProtocolHandler() => throw null;
                    public BearerProtocolHandler(params Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers) => throw null;
                    public override string Protocol { get => throw null; }
                    public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ReadTokens(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    protected override void ResolveAccessTokenType(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                }
                public abstract class Handler
                {
                    public string ActorClaimName { get => throw null; set { } }
                    public virtual Microsoft.IdentityModel.S2S.ProtocolEvaluationResult CanValidate(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    protected Handler() => throw null;
                    public static string DefaultActorClaimName { get => throw null; }
                    public static string DefaultVersionClaimName { get => throw null; }
                    public string VersionClaimName { get => throw null; set { } }
                }
                public class MSAuth10AtPopProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.MSAuth10ProtocolHandler
                {
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode AuthenticationMode { get => throw null; }
                    public override Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; }
                    protected override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, Microsoft.IdentityModel.S2S.S2SOutboundPolicy outboundPolicy, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public MSAuth10AtPopProtocolHandler() : base(default(Microsoft.IdentityModel.Tokens.TokenHandler[])) => throw null;
                    public MSAuth10AtPopProtocolHandler(params Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers) : base(default(Microsoft.IdentityModel.Tokens.TokenHandler[])) => throw null;
                    public override string ProtocolType { get => throw null; }
                    public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ReadTokens(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    protected override void ResolveAccessTokenType(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                }
                public class MSAuth10PFATProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.MSAuth10ProtocolHandler
                {
                    public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode AuthenticationMode { get => throw null; }
                    public override Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; }
                    protected override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, Microsoft.IdentityModel.S2S.S2SOutboundPolicy outboundPolicy, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public MSAuth10PFATProtocolHandler() : base(default(Microsoft.IdentityModel.Tokens.TokenHandler[])) => throw null;
                    public MSAuth10PFATProtocolHandler(params Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers) : base(default(Microsoft.IdentityModel.Tokens.TokenHandler[])) => throw null;
                    public override string ProtocolType { get => throw null; }
                    public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ReadTokens(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    protected override void ResolveAccessTokenType(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                }
                public abstract class MSAuth10ProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler
                {
                    public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult CanValidate(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public MSAuth10ProtocolHandler(params Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers) => throw null;
                    public override string Protocol { get => throw null; }
                }
                public class MSAuth10StPopProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.MSAuth10ProtocolHandler
                {
                    public override Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; }
                    protected override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, Microsoft.IdentityModel.S2S.S2SOutboundPolicy outboundPolicy, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public Microsoft.IdentityModel.S2S.CscClaimResolver CscClaimResolver { get => throw null; set { } }
                    public MSAuth10StPopProtocolHandler() : base(default(Microsoft.IdentityModel.Tokens.TokenHandler[])) => throw null;
                    public MSAuth10StPopProtocolHandler(params Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers) : base(default(Microsoft.IdentityModel.Tokens.TokenHandler[])) => throw null;
                    public override string ProtocolType { get => throw null; }
                    public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ReadTokens(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    protected override void ResolveAccessTokenType(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                }
                public class PreValidationTokenTransform
                {
                    public PreValidationTokenTransform() => throw null;
                    public PreValidationTokenTransform(Microsoft.IdentityModel.Tokens.TransformBeforeSignatureValidation transformation) => throw null;
                    public Microsoft.IdentityModel.Tokens.SecurityToken Transform(Microsoft.IdentityModel.Tokens.SecurityToken token, Microsoft.IdentityModel.Tokens.TokenValidationParameters tokenValidationParameters) => throw null;
                }
                public abstract class ProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.Handler
                {
                    public bool AddTokenHandler(Microsoft.IdentityModel.Tokens.TokenHandler tokenHandler, bool prepend = default(bool)) => throw null;
                    public abstract Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get; }
                    public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult CanValidate(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    protected virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, Microsoft.IdentityModel.S2S.S2SOutboundPolicy outboundPolicy, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public ProtocolHandler() => throw null;
                    public ProtocolHandler(params Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers) => throw null;
                    public Microsoft.IdentityModel.S2S.AuthenticationEvents Events { get => throw null; set { } }
                    public virtual System.Collections.Generic.IList<Microsoft.IdentityModel.S2S.S2SInboundPolicy> GetApplicablePolicies(System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.S2S.S2SInboundPolicy> policies) => throw null;
                    protected virtual bool ParseAuthorizationHeader(string authorizationHeader, out string authenticator) => throw null;
                    public abstract string Protocol { get; }
                    public virtual string ProtocolType { get => throw null; }
                    public abstract Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ReadTokens(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context);
                    protected abstract void ResolveAccessTokenType(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context);
                    public System.Collections.Generic.IList<Microsoft.IdentityModel.Tokens.TokenHandler> TokenHandlers { get => throw null; }
                    public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateProtocolEvaluationResultAsync(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.S2S.S2SInboundPolicy> inboundPolicies, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context);
                }
                public class SignedHttpRequestProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler
                {
                    public override Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; }
                    protected override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, Microsoft.IdentityModel.S2S.S2SOutboundPolicy outboundPolicy, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public SignedHttpRequestProtocolHandler() => throw null;
                    public SignedHttpRequestProtocolHandler(params Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers) => throw null;
                    protected void Init() => throw null;
                    public override string Protocol { get => throw null; }
                    public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ReadTokens(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    protected override void ResolveAccessTokenType(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                }
            }
        }
        namespace S2S
        {
            public class AllowTBHCnfValidator : Microsoft.IdentityModel.S2S.CnfValidator
            {
                public AllowTBHCnfValidator() => throw null;
                public AllowTBHCnfValidator(Microsoft.IdentityModel.S2S.CnfValidator innerValidator) => throw null;
                public override bool Validate(System.Collections.Generic.IDictionary<string, string> cnfClaims, Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.Tokens.TokenValidationParameters tokenValidationParameters, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
            }
            public class AuthenticationEvents
            {
                public AuthenticationEvents() => throw null;
                public System.Func<Microsoft.IdentityModel.S2S.ProtocolEvaluatedContext, System.Threading.Tasks.Task> OnProtocolEvaluated { get => throw null; set { } }
                public System.Func<Microsoft.IdentityModel.S2S.TokenValidationFailureContext, System.Threading.Tasks.Task> OnTokenValidationFailed { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task ProtocolEvaluated(Microsoft.IdentityModel.S2S.ProtocolEvaluatedContext context) => throw null;
                public virtual System.Threading.Tasks.Task TokenValidationFailed(Microsoft.IdentityModel.S2S.TokenValidationFailureContext context) => throw null;
            }
            public abstract class AuthenticationScheme
            {
                public static Microsoft.IdentityModel.S2S.AuthenticationScheme Bearer;
                protected AuthenticationScheme(string name) => throw null;
                public static Microsoft.IdentityModel.S2S.AuthenticationScheme FromName(string name) => throw null;
                public static Microsoft.IdentityModel.S2S.AuthenticationScheme MSAuth_1_0_AT_POP;
                public static Microsoft.IdentityModel.S2S.AuthenticationScheme MSAuth_1_0_PFAT;
                public static Microsoft.IdentityModel.S2S.AuthenticationScheme MSAuth_1_0_ST_POP;
                public string Name { get => throw null; }
                public static Microsoft.IdentityModel.S2S.AuthenticationScheme PoP;
                public override string ToString() => throw null;
                public static Microsoft.IdentityModel.S2S.AuthenticationScheme Unknown;
            }
            public abstract class CnfValidator
            {
                public bool CallInnerFirst { get => throw null; set { } }
                public CnfValidator() => throw null;
                public CnfValidator(Microsoft.IdentityModel.S2S.CnfValidator innerValidator) => throw null;
                public Microsoft.IdentityModel.S2S.CnfValidator InnerValidator { get => throw null; }
                public virtual bool Validate(System.Collections.Generic.IDictionary<string, string> cnfClaims, Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.Tokens.TokenValidationParameters tokenValidationParameters) => throw null;
                public abstract bool Validate(System.Collections.Generic.IDictionary<string, string> cnfClaims, Microsoft.IdentityModel.S2S.S2SInboundPolicy policy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.Tokens.TokenValidationParameters tokenValidationParameters, Microsoft.IdentityModel.S2S.S2SContext context);
            }
            public delegate System.Security.Claims.ClaimsIdentity CscClaimResolver(System.Security.Claims.Claim csc, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters);
            public class HeaderCreationParameterEvaluationResult : Microsoft.IdentityModel.S2S.S2SActionResult
            {
                public Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AuthenticationFailureType { get => throw null; }
                public HeaderCreationParameterEvaluationResult(Microsoft.IdentityModel.S2S.S2SOutboundPolicy policy) => throw null;
                public Microsoft.IdentityModel.S2S.S2SOutboundPolicy OutboundPolicy { get => throw null; }
                public string ValidationFailureMessage { get => throw null; }
            }
            public interface IInboundPolicyProvider
            {
                System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.S2S.S2SInboundPolicy> GetPolicies(System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.S2S.S2SInboundPolicy> configuredPolicies, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context);
            }
            public class InboundPolicyEvaluationResult : Microsoft.IdentityModel.S2S.S2SActionResult
            {
                public Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType AuthenticationFailureType { get => throw null; }
                public InboundPolicyEvaluationResult(Microsoft.IdentityModel.S2S.S2SInboundPolicy policy) => throw null;
                public Microsoft.IdentityModel.S2S.S2SInboundPolicy InboundPolicy { get => throw null; }
                public string ValidationFailureMessage { get => throw null; }
            }
            public class JwtAuthenticationHandler : Microsoft.IdentityModel.S2S.S2SAuthenticationHandler
            {
                public override System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod) => throw null;
                public override System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public override System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public string BuildAppAssertedUserTokenMsServiceV1Business(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildAppAssertedUserTokenMsServiceV1BusinessCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildAppAssertedUserTokenMsServiceV1Consumer(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildAppAssertedUserTokenMsServiceV1ConsumerCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildAppAssertedUserTokenV1(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildAppAssertedUserTokenV1Compact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildServiceAssertedAppTokenMsServiceV1Business(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildServiceAssertedAppTokenMsServiceV1BusinessCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildServiceAssertedAppTokenMsServiceV1Consumer(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildServiceAssertedAppTokenMsServiceV1ConsumerCompact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildServiceAssertedAppTokenV1(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public string BuildServiceAssertedAppTokenV1Compact(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken accessToken, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken appToken) => throw null;
                public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult CanValidate(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod) => throw null;
                public override System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public override System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public Microsoft.IdentityModel.S2S.CscClaimResolver CscClaimResolver { get => throw null; set { } }
                public JwtAuthenticationHandler() => throw null;
                public JwtAuthenticationHandler(Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager) => throw null;
                public JwtAuthenticationHandler(Microsoft.IdentityModel.S2S.JwtInboundPolicy inboundPolicy) => throw null;
                public JwtAuthenticationHandler(Microsoft.IdentityModel.S2S.JwtInboundPolicy inboundPolicy, Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager) => throw null;
                public JwtAuthenticationHandler(string name, Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy) => throw null;
                public JwtAuthenticationHandler(string name, Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy, Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager) => throw null;
                public JwtAuthenticationHandler(Microsoft.IdentityModel.S2S.JwtInboundPolicy inboundPolicy, string name, Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy) => throw null;
                public JwtAuthenticationHandler(Microsoft.IdentityModel.S2S.JwtInboundPolicy inboundPolicy, string name, Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy, Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager) => throw null;
                public virtual string GetAppToken(Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy) => throw null;
                public virtual string GetAppToken(Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetAppTokenAsync(Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetAppTokenAsync(Microsoft.IdentityModel.S2S.JwtOutboundPolicy outboundPolicy, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public System.Collections.Generic.ICollection<Microsoft.IdentityModel.S2S.JwtInboundPolicy> InboundPolicies { get => throw null; }
                public Microsoft.IdentityModel.S2S.IInboundPolicyProvider InboundPolicyProvider { get => throw null; set { } }
                public bool MapClaims { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, Microsoft.IdentityModel.S2S.JwtOutboundPolicy> OutboundPolicies { get => throw null; }
                public Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler SecurityTokenHandler { get => throw null; set { } }
                public readonly Microsoft.IdentityModel.S2S.Tokens.TokenManager TokenManager;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateProtocolEvaluationResultAsync(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
            }
            public class JwtInboundPolicy : Microsoft.IdentityModel.S2S.S2SInboundPolicy
            {
                public JwtInboundPolicy(string authority, string clientId) : base(default(string), default(string)) => throw null;
            }
            public class JwtOutboundPolicy : Microsoft.IdentityModel.S2S.S2SOutboundPolicy
            {
                public JwtOutboundPolicy(string authority, string clientId, Microsoft.IdentityModel.S2S.S2SAuthenticationMode authenticationMode) : base(default(string), default(string), default(Microsoft.IdentityModel.S2S.AuthenticationScheme), default(Microsoft.IdentityModel.S2S.TokenType)) => throw null;
                public JwtOutboundPolicy(string authority, string clientId, Microsoft.IdentityModel.S2S.AuthenticationScheme authenticationScheme, Microsoft.IdentityModel.S2S.TokenType accessTokenType) : base(default(string), default(string), default(Microsoft.IdentityModel.S2S.AuthenticationScheme), default(Microsoft.IdentityModel.S2S.TokenType)) => throw null;
            }
            public class JwtTokenVersions
            {
                public const string AccessTokenV1 = default;
                public const string AccessTokenV2 = default;
                public const string AppAssertedUserTokenMsServiceV1 = default;
                public const string AppAssertedUserTokenV1 = default;
                public JwtTokenVersions() => throw null;
                public const string ServiceAssertedAppTokenMsServiceV1 = default;
                public const string ServiceAssertedAppTokenV1 = default;
                public const string StiAppAssertedUserTokenV1 = default;
                public const string StiServiceAssertedAppTokenV1 = default;
            }
            public class ProtocolEvaluatedContext : Microsoft.IdentityModel.S2S.ResultContext
            {
                public ProtocolEvaluatedContext(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override void Fail(System.Exception failure) => throw null;
                public override void Fail(string failureMessage) => throw null;
                public Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ProtocolEvaluationResult { get => throw null; }
                public Microsoft.IdentityModel.S2S.S2SAuthenticationResult Result { get => throw null; }
                public override void Success(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket) => throw null;
            }
            public class ProtocolEvaluationResult : Microsoft.IdentityModel.S2S.Tokens.EvaluationResult
            {
                public Microsoft.IdentityModel.S2S.TokenType AccessTokenType { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; set { } }
                public ProtocolEvaluationResult() => throw null;
                public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.ProtocolEvaluationResult SetSucceeded() => throw null;
            }
            public class ResultContext
            {
                public ResultContext() => throw null;
                public virtual void Fail(System.Exception failure) => throw null;
                public virtual void Fail(string failureMessage) => throw null;
                public virtual void Success(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket) => throw null;
            }
            public class S2SActionResult
            {
                public S2SActionResult() => throw null;
                public System.Exception Exception { get => throw null; set { } }
                public bool Succeeded { get => throw null; set { } }
            }
            public abstract class S2SAuthenticationHandler : Microsoft.IdentityModel.Protocol.Handlers.Handler
            {
                public abstract System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod);
                public virtual System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public abstract System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context);
                public virtual System.Threading.Tasks.Task AddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public override Microsoft.IdentityModel.S2S.ProtocolEvaluationResult CanValidate(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public abstract System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod);
                public virtual System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public abstract System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context);
                public virtual System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                protected S2SAuthenticationHandler() => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SActionResult> TryAddAuthorizationHeaderAsync(System.Net.Http.Headers.HttpRequestHeaders headers, Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context);
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateProtocolEvaluationResultAsync(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
            }
            public class S2SAuthenticationManager
            {
                public void AddProtocolHandler(Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler protocolHandler) => throw null;
                public bool AddTokenHandlerToProtocolHandler(Microsoft.IdentityModel.S2S.AuthenticationScheme protocol, Microsoft.IdentityModel.Tokens.TokenHandler tokenHandler, Microsoft.IdentityModel.S2S.S2SContext context, bool preappend = default(bool)) => throw null;
                public System.Collections.Generic.ICollection<Microsoft.IdentityModel.S2S.S2SAuthenticationHandler> AuthenticationHandlers { get => throw null; }
                public virtual System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod) => throw null;
                public virtual System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public virtual System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<string> CreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public S2SAuthenticationManager() => throw null;
                public S2SAuthenticationManager(params Microsoft.IdentityModel.S2S.S2SAuthenticationHandler[] handlers) => throw null;
                public S2SAuthenticationManager(Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager, params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] protocolHandlers) => throw null;
                public S2SAuthenticationManager(Microsoft.Identity.Abstractions.ITokenAcquirerFactory tokenAcquirerFactory, Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager, params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] protocolHandlers) => throw null;
                public S2SAuthenticationManager(Microsoft.Identity.Abstractions.ITokenAcquirerFactory tokenAcquirerFactory, params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] protocolHandlers) => throw null;
                public S2SAuthenticationManager(Microsoft.Identity.Abstractions.ITokenAcquirerFactory tokenAcquirerFactory, System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Abstractions.ITelemetryClient> telemetryClients, params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] protocolHandlers) => throw null;
                public S2SAuthenticationManager(Microsoft.Identity.Abstractions.ITokenAcquirerFactory tokenAcquirerFactory, Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager, System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Abstractions.ITelemetryClient> telemetryClients, params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] protocolHandlers) => throw null;
                public S2SAuthenticationManager(params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] handlers) => throw null;
                public S2SAuthenticationManager(Microsoft.IdentityModel.Abstractions.ITelemetryClient telemetryClient, params Microsoft.IdentityModel.S2S.S2SAuthenticationHandler[] handlers) => throw null;
                public S2SAuthenticationManager(Microsoft.IdentityModel.Abstractions.ITelemetryClient telemetryClient, Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager, params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] handlers) => throw null;
                public S2SAuthenticationManager(System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Abstractions.ITelemetryClient> telemetryClients, Microsoft.IdentityModel.S2S.Tokens.TokenManager tokenManager, params Microsoft.IdentityModel.Protocol.Handlers.ProtocolHandler[] handlers) => throw null;
                public S2SAuthenticationManager(System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Abstractions.ITelemetryClient> telemetryClients, params Microsoft.IdentityModel.S2S.S2SAuthenticationHandler[] handlers) => throw null;
                public Microsoft.IdentityModel.S2S.AuthenticationEvents Events { get => throw null; set { } }
                public System.Collections.Generic.IList<Microsoft.IdentityModel.S2S.S2SInboundPolicy> InboundPolicies { get => throw null; }
                public Microsoft.IdentityModel.S2S.IInboundPolicyProvider InboundPolicyProvider { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.Tokens.MetadataManager MetadataManager { get => throw null; }
                public System.Collections.Generic.IDictionary<string, Microsoft.IdentityModel.S2S.S2SOutboundPolicy> OutboundPolicies { get => throw null; }
                public Microsoft.Identity.Abstractions.ITokenAcquirerFactory TokenAcquirerFactory { get => throw null; set { } }
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SCreateHeaderResult> TryCreateAuthorizationHeaderAsync(Microsoft.IdentityModel.S2S.S2SAuthenticationTicket ticket, string outboundPolicyName, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> TryValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, System.Uri uri, string httpMethod, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationTicket> ValidateAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData) => throw null;
                public virtual System.Threading.Tasks.Task<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> ValidateRequestAsync(string authorizationHeader, Microsoft.IdentityModel.Protocols.HttpRequestData httpRequestData, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
            }
            public abstract class S2SAuthenticationMode
            {
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode AccessToken;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode AppAssertedUserMsServiceV1Business;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode AppAssertedUserMsServiceV1Consumer;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode AppAssertedUserV1;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode AppToken;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode BearerPFAT;
                protected S2SAuthenticationMode(string name) => throw null;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode MSAuth_1_0_AT_POP;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode MSAuth_1_0_PFAT;
                public string Name { get => throw null; }
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode ServiceAssertedAppMsServiceV1Business;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode ServiceAssertedAppMsServiceV1Consumer;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode ServiceAssertedAppV1;
                public override string ToString() => throw null;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationMode Unknown;
            }
            public class S2SAuthenticationResult : Microsoft.IdentityModel.S2S.S2SActionResult
            {
                public string AuthenticationFailureDescription { get => throw null; }
                public S2SAuthenticationResult() => throw null;
                public S2SAuthenticationResult(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult) => throw null;
                public S2SAuthenticationResult(Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, System.Exception ex) => throw null;
                public System.Collections.Generic.IList<Microsoft.IdentityModel.S2S.InboundPolicyEvaluationResult> InboundPolicyEvaluationResults { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.IdentityModel.S2S.ProtocolEvaluationResult> ProtocolEvaluationResults { get => throw null; }
                public Microsoft.IdentityModel.S2S.AuthenticationScheme ProtocolScheme { get => throw null; }
                public Microsoft.IdentityModel.S2S.S2SAuthenticationTicket Ticket { get => throw null; set { } }
            }
            public static partial class S2SAuthenticationResultExtensions
            {
                public static System.Collections.Generic.List<Microsoft.IdentityModel.S2S.S2SInboundPolicy> GetApplicablePolicies(this Microsoft.IdentityModel.S2S.S2SAuthenticationResult authenticationResult) => throw null;
                public static System.Collections.Generic.List<Microsoft.IdentityModel.S2S.InboundPolicyEvaluationResult> GetInboundPolicyEvaluationResult(this Microsoft.IdentityModel.S2S.S2SAuthenticationResult authenticationResult, string label) => throw null;
                public static System.Collections.Specialized.NameValueCollection GetResponseHeaders(this Microsoft.IdentityModel.S2S.S2SAuthenticationResult authenticationResult) => throw null;
                public static Microsoft.IdentityModel.S2S.S2SAuthenticationResult GetSuccessfulResult(this System.Collections.Generic.List<Microsoft.IdentityModel.S2S.S2SAuthenticationResult> authenticationResults) => throw null;
            }
            public class S2SAuthenticationTicket
            {
                public Microsoft.IdentityModel.S2S.TokenType AccessTokenType { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.TokenValidationResult AccessTokenValidationResult { get => throw null; set { } }
                public System.Security.Claims.ClaimsIdentity ApplicationIdentity { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SecurityToken ApplicationToken { get => throw null; set { } }
                public string ApplicationTokenRawData { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.TokenValidationResult ApplicationTokenValidationResult { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.S2SAuthenticationHandler AuthenticationHandler { get => throw null; }
                public Microsoft.IdentityModel.S2S.S2SAuthenticationMode AuthenticationMode { get => throw null; }
                public Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; set { } }
                public S2SAuthenticationTicket(Microsoft.IdentityModel.S2S.S2SAuthenticationMode authenticationMode) => throw null;
                public S2SAuthenticationTicket(Microsoft.IdentityModel.S2S.AuthenticationScheme authenticationScheme, Microsoft.IdentityModel.S2S.S2SInboundPolicy inboundPolicy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult) => throw null;
                public S2SAuthenticationTicket(Microsoft.IdentityModel.S2S.TokenType accessTokenType, Microsoft.IdentityModel.S2S.AuthenticationScheme authenticationScheme) => throw null;
                public Microsoft.IdentityModel.S2S.S2SInboundPolicy InboundPolicy { get => throw null; }
                public Microsoft.IdentityModel.S2S.Tokens.EvaluationResult ProtocolEvaluationResult { get => throw null; }
                public System.Security.Claims.ClaimsIdentity SubjectIdentity { get => throw null; set { } }
                public Microsoft.IdentityModel.Tokens.SecurityToken SubjectToken { get => throw null; set { } }
                public string SubjectTokenRawData { get => throw null; set { } }
            }
            public static partial class S2SClaimsIdentityExtensions
            {
                public static System.Security.Claims.Claim FindFirst(this System.Security.Claims.ClaimsIdentity claimsIdentity, string type, System.StringComparison stringComparison) => throw null;
            }
            public class S2SContext : Microsoft.IdentityModel.Tokens.CallContext
            {
                public S2SContext() => throw null;
                public S2SContext(System.Guid activityId) => throw null;
            }
            public class S2SCreateHeaderResult : Microsoft.IdentityModel.S2S.S2SActionResult
            {
                public string AuthorizationHeader { get => throw null; set { } }
                public S2SCreateHeaderResult() => throw null;
                public string ErrorMessage { get => throw null; set { } }
                public string Header { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.HeaderCreationParameterEvaluationResult HeaderCreationParameterEvaluationResult { get => throw null; set { } }
                public string HeaderName { get => throw null; set { } }
            }
            public class S2SInboundPolicy : Microsoft.IdentityModel.S2S.S2SPolicy
            {
                public Microsoft.IdentityModel.S2S.S2SInboundPolicy ActorPolicy { get => throw null; set { } }
                public bool AllowAppAssertedTokens { get => throw null; set { } }
                public bool ApplyPolicyForAllTenants { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.Tokens.AuthenticatorValidationPolicy AuthenticatorValidationPolicy { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.CnfValidator CnfValidator { get => throw null; set { } }
                public string CommonIssuerPrefix { get => throw null; }
                public S2SInboundPolicy(string authority, string clientId) => throw null;
                public virtual System.Threading.Tasks.Task<bool> DoesApplyAsync(Microsoft.IdentityModel.S2S.Tokens.MetadataManager metadataManager, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public bool LogTokenClaims { get => throw null; set { } }
                public bool RefreshOnIssuerKeyNotFound { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy ServerNoncePolicy { get => throw null; set { } }
                public Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestValidationParameters SignedHttpRequestValidationParameters { get => throw null; set { } }
                public System.Collections.Generic.ICollection<Microsoft.Identity.Abstractions.CredentialDescription> TokenDecryptionCredentials { get => throw null; }
                public Microsoft.IdentityModel.Tokens.TokenValidationParameters TokenValidationParameters { get => throw null; }
                public System.Collections.Generic.ICollection<Microsoft.IdentityModel.S2S.TokenType> ValidAccessTokenTypes { get => throw null; }
                public System.Collections.Generic.ICollection<string> ValidApplicationIds { get => throw null; }
                public bool ValidateAssertedTokenIssuer { get => throw null; set { } }
                public System.Collections.Generic.ICollection<string> ValidAudiences { get => throw null; }
                public System.Collections.Generic.ICollection<Microsoft.IdentityModel.S2S.S2SAuthenticationMode> ValidAuthenticationModes { get => throw null; }
                public System.Collections.Generic.ICollection<Microsoft.IdentityModel.S2S.AuthenticationScheme> ValidAuthenticationSchemes { get => throw null; }
                public System.Collections.Generic.ICollection<string> ValidIssuerPrefixes { get => throw null; }
            }
            public class S2SOutboundPolicy : Microsoft.IdentityModel.S2S.S2SPolicy
            {
                public Microsoft.IdentityModel.S2S.TokenType AccessTokenType { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.S2SAuthenticationMode AuthenticationMode { get => throw null; }
                public Microsoft.IdentityModel.S2S.AuthenticationScheme AuthenticationScheme { get => throw null; set { } }
                public System.Security.Cryptography.X509Certificates.X509Certificate2 Certificate { get => throw null; set { } }
                public S2SOutboundPolicy(string authority, string clientId, Microsoft.IdentityModel.S2S.AuthenticationScheme authenticationScheme, Microsoft.IdentityModel.S2S.TokenType accessTokenType) => throw null;
                public bool IncludePopClaim { get => throw null; set { } }
                public bool IncludeX5cClaim { get => throw null; set { } }
                public string Resource { get => throw null; set { } }
                public string Scope { get => throw null; set { } }
                public Microsoft.IdentityModel.Protocols.SignedHttpRequest.SignedHttpRequestCreationParameters SignedHttpRequestCreationParameters { get => throw null; set { } }
                public Microsoft.IdentityModel.S2S.Tokens.TokenAcquisitionParameters TokenAcquisitionParameters { get => throw null; set { } }
            }
            public abstract class S2SPolicy : Microsoft.IdentityModel.S2S.Tokens.AuthenticationPolicy
            {
                protected S2SPolicy() => throw null;
                protected S2SPolicy(string authority, string clientId) => throw null;
                public override string ToString() => throw null;
            }
            public class S2SSettings
            {
                public S2SSettings() => throw null;
                public System.Collections.Generic.IList<Microsoft.IdentityModel.S2S.S2SInboundPolicy> InboundPolicies { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.IdentityModel.S2S.S2SOutboundPolicy> OutboundPolicies { get => throw null; }
                public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; }
            }
            public class SealProtocolHandler : Microsoft.IdentityModel.Protocol.Handlers.BearerProtocolHandler
            {
                public SealProtocolHandler(Microsoft.IdentityModel.Tokens.TokenHandler[] tokenHandlers = default(Microsoft.IdentityModel.Tokens.TokenHandler[])) => throw null;
            }
            public static class ServerNonceHeader
            {
                public static string GetErrorCode(Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType) => throw null;
                public static Microsoft.IdentityModel.S2S.S2SCreateHeaderResult TryCreateAuthenticationInfoHeader(Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy) => throw null;
                public static Microsoft.IdentityModel.S2S.S2SCreateHeaderResult TryCreateAuthenticationInfoHeader(Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy, Microsoft.IdentityModel.S2S.S2SContext context, System.Threading.CancellationToken cancellationToken) => throw null;
                public static Microsoft.IdentityModel.S2S.S2SCreateHeaderResult TryCreateWWWAuthenticateHeader(Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy, Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType) => throw null;
                public static Microsoft.IdentityModel.S2S.S2SCreateHeaderResult TryCreateWWWAuthenticateHeader(Microsoft.IdentityModel.S2S.Tokens.ServerNoncePolicy serverNoncePolicy, Microsoft.IdentityModel.S2S.Tokens.AuthenticationFailureType authenticationFailureType, Microsoft.IdentityModel.S2S.S2SContext context, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public abstract class TokenType
            {
                public static Microsoft.IdentityModel.S2S.TokenType AccessToken;
                public static Microsoft.IdentityModel.S2S.TokenType AccessTokenPFT;
                public static Microsoft.IdentityModel.S2S.TokenType ActorToken;
                public static Microsoft.IdentityModel.S2S.TokenType AppAssertedUserMsServiceV1Business;
                public static Microsoft.IdentityModel.S2S.TokenType AppAssertedUserMsServiceV1Consumer;
                public static Microsoft.IdentityModel.S2S.TokenType AppAssertedUserV1;
                public static Microsoft.IdentityModel.S2S.TokenType AppToken;
                public static Microsoft.IdentityModel.S2S.TokenType CscToken;
                protected TokenType(string name) => throw null;
                public static Microsoft.IdentityModel.S2S.TokenType FromName(string name) => throw null;
                public string Name { get => throw null; }
                public static Microsoft.IdentityModel.S2S.TokenType PftOboExchange;
                public static Microsoft.IdentityModel.S2S.TokenType ServiceAssertedAppMsServiceV1Business;
                public static Microsoft.IdentityModel.S2S.TokenType ServiceAssertedAppMsServiceV1Consumer;
                public static Microsoft.IdentityModel.S2S.TokenType ServiceAssertedAppV1;
                public static Microsoft.IdentityModel.S2S.TokenType StiAppAssertedUserV1;
                public static Microsoft.IdentityModel.S2S.TokenType StiServiceAssertedAppV1;
                public override string ToString() => throw null;
                public static Microsoft.IdentityModel.S2S.TokenType Unknown;
            }
            public class TokenValidationFailureContext : Microsoft.IdentityModel.S2S.ResultContext
            {
                public TokenValidationFailureContext(Microsoft.IdentityModel.Tokens.TokenHandler tokenHandler, Microsoft.IdentityModel.S2S.S2SInboundPolicy s2SInboundPolicy, Microsoft.IdentityModel.S2S.ProtocolEvaluationResult protocolEvaluationResult, Microsoft.IdentityModel.Tokens.TokenValidationParameters tokenValidationParameters, Microsoft.IdentityModel.Tokens.TokenValidationResult tokenValidationResult, Microsoft.IdentityModel.S2S.S2SContext context) => throw null;
                public Microsoft.IdentityModel.S2S.ProtocolEvaluationResult ProtocolEvaluationResult { get => throw null; }
                public Microsoft.IdentityModel.S2S.S2SInboundPolicy S2SInboundPolicy { get => throw null; }
                public Microsoft.IdentityModel.Tokens.TokenHandler TokenHandler { get => throw null; }
                public Microsoft.IdentityModel.Tokens.TokenValidationParameters TokenValidationParameters { get => throw null; }
                public Microsoft.IdentityModel.Tokens.TokenValidationResult TokenValidationResult { get => throw null; }
            }
        }
    }
}
