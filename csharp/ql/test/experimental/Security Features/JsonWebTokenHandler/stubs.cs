using System;
using System.Collections.Generic;

namespace Microsoft.IdentityModel
{

}

namespace Microsoft.IdentityModel.Tokens
{
    public abstract class SecurityToken
    {
        protected SecurityToken() { }
        public string Id { get; }
        public string Issuer { get; }
        public DateTime ValidFrom { get; }
        public DateTime ValidTo { get; }
    }

    public abstract class TokenHandler
    {
        public static readonly int DefaultTokenLifetimeInMinutes;

        protected TokenHandler() { }

        public virtual int MaximumTokenSizeInBytes { get; set; }
        public bool SetDefaultTimesOnTokenCreation { get; set; }
        public int TokenLifetimeInMinutes { get; set; }
    }

    public delegate bool LifetimeValidator(DateTime? notBefore, DateTime? expires, SecurityToken securityToken, TokenValidationParameters validationParameters);
    public delegate bool AudienceValidator(IEnumerable<string> audiences, SecurityToken securityToken, TokenValidationParameters validationParameters);
    public delegate bool TokenReplayValidator(DateTime? expirationTime, string securityToken, TokenValidationParameters validationParameters);
    public delegate string IssuerValidator(string issuer, SecurityToken securityToken, TokenValidationParameters validationParameters);

    public class TokenValidationParameters
    {
        public const int DefaultMaximumTokenSizeInBytes = 256000;
        public static readonly string DefaultAuthenticationType;
        public static readonly TimeSpan DefaultClockSkew;
        public TimeSpan ClockSkew { get; set; }
        public bool SaveSigninToken { get; set; }
        public bool ValidateIssuer { get; set; }
        public bool ValidateAudience { get; set; }
        public bool ValidateLifetime { get; set; }
        public bool ValidateIssuerSigningKey { get; set; }
        public bool ValidateTokenReplay { get; set; }
        public bool ValidateActor { get; set; }
        public bool RequireSignedTokens { get; set; }
        public bool RequireAudience { get; set; }
        public bool RequireExpirationTime { get; set; }

        // Delegation
        public LifetimeValidator LifetimeValidator { get; set; }
        public AudienceValidator AudienceValidator { get; set; }
        public TokenReplayValidator TokenReplayValidator { get; set; }
        public IssuerValidator IssuerValidator { get; set; }

        /*
        public TokenValidationParameters() { }
        public SignatureValidator SignatureValidator { get; set; }
        public SecurityKey TokenDecryptionKey { get; set; }
        public TokenDecryptionKeyResolver TokenDecryptionKeyResolver { get; set; }
        public IEnumerable<SecurityKey> TokenDecryptionKeys { get; set; }
        public TokenReader TokenReader { get; set; }
        public ITokenReplayCache TokenReplayCache { get; set; }
        public Func<SecurityToken, string, string> RoleClaimTypeRetriever { get; set; }
        public string ValidAudience { get; set; }
        public IEnumerable<string> ValidAudiences { get; set; }
        public string ValidIssuer { get; set; }
        public IEnumerable<string> ValidIssuers { get; set; }
        public TokenValidationParameters ActorValidationParameters { get; set; }
        public AudienceValidator AudienceValidator { get; set; }
        public string AuthenticationType { get; set; }
        public CryptoProviderFactory CryptoProviderFactory { get; set; }
        public IssuerSigningKeyValidator IssuerSigningKeyValidator { get; set; }
        public SecurityKey IssuerSigningKey { get; set; }
        public IEnumerable<SecurityKey> IssuerSigningKeys { get; set; }
        public IssuerValidator IssuerValidator { get; set; }
        public string NameClaimType { get; set; }
        public string RoleClaimType { get; set; }
        public Func<SecurityToken, string, string> NameClaimTypeRetriever { get; set; }
        public IDictionary<string, object> PropertyBag { get; set; }
        public IssuerSigningKeyResolver IssuerSigningKeyResolver { get; set; }
        public IEnumerable<string> ValidTypes { get; set; }
        public virtual TokenValidationParameters Clone();
        public virtual string CreateClaimsIdentity(SecurityToken securityToken, string issuer);
        */
    }

}

namespace Microsoft.IdentityModel.JsonWebTokens
{
    public class JsonWebTokenHandler : Microsoft.IdentityModel.Tokens.TokenHandler
    {
        public virtual TokenValidationResult ValidateToken(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters)
        {
            return new TokenValidationResult() { IsValid = true, Exception = null, Issuer = "test" };
        }
    }

    public class TokenValidationResult
    {
        public TokenValidationResult() { }

        public Exception Exception { get; set; }
        public string Issuer { get; set; }
        public bool IsValid { get; set; }
        public Microsoft.IdentityModel.Tokens.SecurityToken SecurityToken { get; set; }
        public string ClaimsIdentity { get; set; }
    }


}
