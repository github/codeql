// This file contains auto-generated code.
// Generated from `System.IdentityModel.Tokens.Jwt, Version=7.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace System
{
    namespace IdentityModel
    {
        namespace Tokens
        {
            namespace Jwt
            {
                public static class JsonClaimValueTypes
                {
                    public const string Json = default;
                    public const string JsonArray = default;
                    public const string JsonNull = default;
                }
                public static class JwtConstants
                {
                    public const string DirectKeyUseAlg = default;
                    public const string HeaderType = default;
                    public const string HeaderTypeAlt = default;
                    public const string JsonCompactSerializationRegex = default;
                    public const string JweCompactSerializationRegex = default;
                    public const string TokenType = default;
                    public const string TokenTypeAlt = default;
                }
                public class JwtHeader : System.Collections.Generic.Dictionary<string, object>
                {
                    public string Alg { get => throw null; }
                    public static System.IdentityModel.Tokens.Jwt.JwtHeader Base64UrlDeserialize(string base64UrlEncodedJsonString) => throw null;
                    public virtual string Base64UrlEncode() => throw null;
                    public JwtHeader() => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials) => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, System.Collections.Generic.IDictionary<string, string> outboundAlgorithmMap) => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, System.Collections.Generic.IDictionary<string, string> outboundAlgorithmMap, string tokenType) => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, System.Collections.Generic.IDictionary<string, string> outboundAlgorithmMap, string tokenType, System.Collections.Generic.IDictionary<string, object> additionalInnerHeaderClaims) => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, string> outboundAlgorithmMap) => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, string> outboundAlgorithmMap, string tokenType) => throw null;
                    public JwtHeader(Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, string> outboundAlgorithmMap, string tokenType, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                    public string Cty { get => throw null; }
                    public string Enc { get => throw null; }
                    public Microsoft.IdentityModel.Tokens.EncryptingCredentials EncryptingCredentials { get => throw null; }
                    public string IV { get => throw null; }
                    public string Kid { get => throw null; }
                    public virtual string SerializeToJson() => throw null;
                    public Microsoft.IdentityModel.Tokens.SigningCredentials SigningCredentials { get => throw null; }
                    public string Typ { get => throw null; }
                    public string X5c { get => throw null; }
                    public string X5t { get => throw null; }
                    public string Zip { get => throw null; }
                }
                public struct JwtHeaderParameterNames
                {
                    public const string Alg = default;
                    public const string Apu = default;
                    public const string Apv = default;
                    public const string Cty = default;
                    public const string Enc = default;
                    public const string Epk = default;
                    public const string IV = default;
                    public const string Jku = default;
                    public const string Jwk = default;
                    public const string Kid = default;
                    public const string Typ = default;
                    public const string X5c = default;
                    public const string X5t = default;
                    public const string X5u = default;
                    public const string Zip = default;
                }
                public class JwtPayload : System.Collections.Generic.Dictionary<string, object>
                {
                    public string Acr { get => throw null; }
                    public string Actort { get => throw null; }
                    public void AddClaim(System.Security.Claims.Claim claim) => throw null;
                    public void AddClaims(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                    public System.Collections.Generic.IList<string> Amr { get => throw null; }
                    public System.Collections.Generic.IList<string> Aud { get => throw null; }
                    public int? AuthTime { get => throw null; }
                    public string Azp { get => throw null; }
                    public static System.IdentityModel.Tokens.Jwt.JwtPayload Base64UrlDeserialize(string base64UrlEncodedJsonString) => throw null;
                    public virtual string Base64UrlEncode() => throw null;
                    public string CHash { get => throw null; }
                    public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                    public JwtPayload() => throw null;
                    public JwtPayload(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                    public JwtPayload(string issuer, string audience, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, System.DateTime? notBefore, System.DateTime? expires) => throw null;
                    public JwtPayload(string issuer, string audience, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, System.DateTime? notBefore, System.DateTime? expires, System.DateTime? issuedAt) => throw null;
                    public JwtPayload(string issuer, string audience, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, System.Collections.Generic.IDictionary<string, object> claimsCollection, System.DateTime? notBefore, System.DateTime? expires, System.DateTime? issuedAt) => throw null;
                    public static System.IdentityModel.Tokens.Jwt.JwtPayload Deserialize(string jsonString) => throw null;
                    public int? Exp { get => throw null; }
                    public long? Expiration { get => throw null; }
                    public int? Iat { get => throw null; }
                    public string Iss { get => throw null; }
                    public System.DateTime IssuedAt { get => throw null; }
                    public string Jti { get => throw null; }
                    public int? Nbf { get => throw null; }
                    public string Nonce { get => throw null; }
                    public long? NotBefore { get => throw null; }
                    public virtual string SerializeToJson() => throw null;
                    public string Sub { get => throw null; }
                    public System.DateTime ValidFrom { get => throw null; }
                    public System.DateTime ValidTo { get => throw null; }
                }
                public struct JwtRegisteredClaimNames
                {
                    public const string Acr = default;
                    public const string Actort = default;
                    public const string Amr = default;
                    public const string AtHash = default;
                    public const string Aud = default;
                    public const string AuthTime = default;
                    public const string Azp = default;
                    public const string Birthdate = default;
                    public const string CHash = default;
                    public const string Email = default;
                    public const string Exp = default;
                    public const string FamilyName = default;
                    public const string Gender = default;
                    public const string GivenName = default;
                    public const string Iat = default;
                    public const string Iss = default;
                    public const string Jti = default;
                    public const string Name = default;
                    public const string NameId = default;
                    public const string Nbf = default;
                    public const string Nonce = default;
                    public const string Prn = default;
                    public const string Sid = default;
                    public const string Sub = default;
                    public const string Typ = default;
                    public const string UniqueName = default;
                    public const string Website = default;
                }
                public class JwtSecurityToken : Microsoft.IdentityModel.Tokens.SecurityToken
                {
                    public string Actor { get => throw null; }
                    public System.Collections.Generic.IEnumerable<string> Audiences { get => throw null; }
                    public System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                    public JwtSecurityToken(string jwtEncodedString) => throw null;
                    public JwtSecurityToken(System.IdentityModel.Tokens.Jwt.JwtHeader header, System.IdentityModel.Tokens.Jwt.JwtPayload payload, string rawHeader, string rawPayload, string rawSignature) => throw null;
                    public JwtSecurityToken(System.IdentityModel.Tokens.Jwt.JwtHeader header, System.IdentityModel.Tokens.Jwt.JwtSecurityToken innerToken, string rawHeader, string rawEncryptedKey, string rawInitializationVector, string rawCiphertext, string rawAuthenticationTag) => throw null;
                    public JwtSecurityToken(System.IdentityModel.Tokens.Jwt.JwtHeader header, System.IdentityModel.Tokens.Jwt.JwtPayload payload) => throw null;
                    public JwtSecurityToken(string issuer = default(string), string audience = default(string), System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims = default(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim>), System.DateTime? notBefore = default(System.DateTime?), System.DateTime? expires = default(System.DateTime?), Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials = default(Microsoft.IdentityModel.Tokens.SigningCredentials)) => throw null;
                    public virtual string EncodedHeader { get => throw null; }
                    public virtual string EncodedPayload { get => throw null; }
                    public Microsoft.IdentityModel.Tokens.EncryptingCredentials EncryptingCredentials { get => throw null; }
                    public System.IdentityModel.Tokens.Jwt.JwtHeader Header { get => throw null; }
                    public override string Id { get => throw null; }
                    public System.IdentityModel.Tokens.Jwt.JwtSecurityToken InnerToken { get => throw null; }
                    public virtual System.DateTime IssuedAt { get => throw null; }
                    public override string Issuer { get => throw null; }
                    public System.IdentityModel.Tokens.Jwt.JwtPayload Payload { get => throw null; }
                    public string RawAuthenticationTag { get => throw null; }
                    public string RawCiphertext { get => throw null; }
                    public string RawData { get => throw null; }
                    public string RawEncryptedKey { get => throw null; }
                    public string RawHeader { get => throw null; }
                    public string RawInitializationVector { get => throw null; }
                    public string RawPayload { get => throw null; }
                    public string RawSignature { get => throw null; }
                    public override Microsoft.IdentityModel.Tokens.SecurityKey SecurityKey { get => throw null; }
                    public string SignatureAlgorithm { get => throw null; }
                    public Microsoft.IdentityModel.Tokens.SigningCredentials SigningCredentials { get => throw null; }
                    public override Microsoft.IdentityModel.Tokens.SecurityKey SigningKey { get => throw null; set { } }
                    public string Subject { get => throw null; }
                    public override string ToString() => throw null;
                    public override string UnsafeToString() => throw null;
                    public override System.DateTime ValidFrom { get => throw null; }
                    public override System.DateTime ValidTo { get => throw null; }
                }
                public static class JwtSecurityTokenConverter
                {
                    public static System.IdentityModel.Tokens.Jwt.JwtSecurityToken Convert(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken token) => throw null;
                }
                public class JwtSecurityTokenHandler : Microsoft.IdentityModel.Tokens.SecurityTokenHandler
                {
                    public override bool CanReadToken(string token) => throw null;
                    public override bool CanValidateToken { get => throw null; }
                    public override bool CanWriteToken { get => throw null; }
                    protected virtual string CreateActorValue(System.Security.Claims.ClaimsIdentity actor) => throw null;
                    protected virtual System.Security.Claims.ClaimsIdentity CreateClaimsIdentity(System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, string issuer, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public virtual string CreateEncodedJwt(Microsoft.IdentityModel.Tokens.SecurityTokenDescriptor tokenDescriptor) => throw null;
                    public virtual string CreateEncodedJwt(string issuer, string audience, System.Security.Claims.ClaimsIdentity subject, System.DateTime? notBefore, System.DateTime? expires, System.DateTime? issuedAt, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                    public virtual string CreateEncodedJwt(string issuer, string audience, System.Security.Claims.ClaimsIdentity subject, System.DateTime? notBefore, System.DateTime? expires, System.DateTime? issuedAt, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials) => throw null;
                    public virtual string CreateEncodedJwt(string issuer, string audience, System.Security.Claims.ClaimsIdentity subject, System.DateTime? notBefore, System.DateTime? expires, System.DateTime? issuedAt, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, object> claimCollection) => throw null;
                    public virtual System.IdentityModel.Tokens.Jwt.JwtSecurityToken CreateJwtSecurityToken(Microsoft.IdentityModel.Tokens.SecurityTokenDescriptor tokenDescriptor) => throw null;
                    public virtual System.IdentityModel.Tokens.Jwt.JwtSecurityToken CreateJwtSecurityToken(string issuer, string audience, System.Security.Claims.ClaimsIdentity subject, System.DateTime? notBefore, System.DateTime? expires, System.DateTime? issuedAt, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials) => throw null;
                    public virtual System.IdentityModel.Tokens.Jwt.JwtSecurityToken CreateJwtSecurityToken(string issuer, string audience, System.Security.Claims.ClaimsIdentity subject, System.DateTime? notBefore, System.DateTime? expires, System.DateTime? issuedAt, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, object> claimCollection) => throw null;
                    public virtual System.IdentityModel.Tokens.Jwt.JwtSecurityToken CreateJwtSecurityToken(string issuer = default(string), string audience = default(string), System.Security.Claims.ClaimsIdentity subject = default(System.Security.Claims.ClaimsIdentity), System.DateTime? notBefore = default(System.DateTime?), System.DateTime? expires = default(System.DateTime?), System.DateTime? issuedAt = default(System.DateTime?), Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials = default(Microsoft.IdentityModel.Tokens.SigningCredentials)) => throw null;
                    public override Microsoft.IdentityModel.Tokens.SecurityToken CreateToken(Microsoft.IdentityModel.Tokens.SecurityTokenDescriptor tokenDescriptor) => throw null;
                    public JwtSecurityTokenHandler() => throw null;
                    protected string DecryptToken(System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public static System.Collections.Generic.ISet<string> DefaultInboundClaimFilter;
                    public static System.Collections.Generic.IDictionary<string, string> DefaultInboundClaimTypeMap;
                    public static bool DefaultMapInboundClaims;
                    public static System.Collections.Generic.IDictionary<string, string> DefaultOutboundAlgorithmMap;
                    public static System.Collections.Generic.IDictionary<string, string> DefaultOutboundClaimTypeMap;
                    public System.Collections.Generic.ISet<string> InboundClaimFilter { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> InboundClaimTypeMap { get => throw null; set { } }
                    public static string JsonClaimTypeProperty { get => throw null; set { } }
                    public bool MapInboundClaims { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> OutboundAlgorithmMap { get => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> OutboundClaimTypeMap { get => throw null; set { } }
                    public System.IdentityModel.Tokens.Jwt.JwtSecurityToken ReadJwtToken(string token) => throw null;
                    public override Microsoft.IdentityModel.Tokens.SecurityToken ReadToken(string token) => throw null;
                    public override Microsoft.IdentityModel.Tokens.SecurityToken ReadToken(System.Xml.XmlReader reader, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected virtual Microsoft.IdentityModel.Tokens.SecurityKey ResolveIssuerSigningKey(string token, System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected virtual Microsoft.IdentityModel.Tokens.SecurityKey ResolveTokenDecryptionKey(string token, System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public static string ShortClaimTypeProperty { get => throw null; set { } }
                    public override System.Type TokenType { get => throw null; }
                    protected virtual void ValidateAudience(System.Collections.Generic.IEnumerable<string> audiences, System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected virtual string ValidateIssuer(string issuer, System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected virtual void ValidateIssuerSecurityKey(Microsoft.IdentityModel.Tokens.SecurityKey key, System.IdentityModel.Tokens.Jwt.JwtSecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected virtual void ValidateLifetime(System.DateTime? notBefore, System.DateTime? expires, System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected virtual System.IdentityModel.Tokens.Jwt.JwtSecurityToken ValidateSignature(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public override System.Security.Claims.ClaimsPrincipal ValidateToken(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, out Microsoft.IdentityModel.Tokens.SecurityToken validatedToken) => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.TokenValidationResult> ValidateTokenAsync(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected System.Security.Claims.ClaimsPrincipal ValidateTokenPayload(System.IdentityModel.Tokens.Jwt.JwtSecurityToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    protected virtual void ValidateTokenReplay(System.DateTime? expires, string securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                    public override string WriteToken(Microsoft.IdentityModel.Tokens.SecurityToken token) => throw null;
                    public override void WriteToken(System.Xml.XmlWriter writer, Microsoft.IdentityModel.Tokens.SecurityToken token) => throw null;
                }
            }
        }
    }
}
