// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.JsonWebTokens, Version=7.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace JsonWebTokens
        {
            public static class JsonClaimValueTypes
            {
                public const string Json = default;
                public const string JsonArray = default;
                public const string JsonNull = default;
            }
            public class JsonWebToken : Microsoft.IdentityModel.Tokens.SecurityToken
            {
                public string Actor { get => throw null; }
                public string Alg { get => throw null; }
                public System.Collections.Generic.IEnumerable<string> Audiences { get => throw null; }
                public string AuthenticationTag { get => throw null; }
                public string Azp { get => throw null; }
                public string Ciphertext { get => throw null; }
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public JsonWebToken(string jwtEncodedString) => throw null;
                public JsonWebToken(System.ReadOnlyMemory<char> encodedTokenMemory) => throw null;
                public JsonWebToken(string header, string payload) => throw null;
                public string Cty { get => throw null; }
                public string Enc { get => throw null; }
                public string EncodedHeader { get => throw null; }
                public string EncodedPayload { get => throw null; }
                public string EncodedSignature { get => throw null; }
                public string EncodedToken { get => throw null; }
                public string EncryptedKey { get => throw null; }
                public System.Security.Claims.Claim GetClaim(string key) => throw null;
                public T GetHeaderValue<T>(string key) => throw null;
                public T GetPayloadValue<T>(string key) => throw null;
                public override string Id { get => throw null; }
                public string InitializationVector { get => throw null; }
                public Microsoft.IdentityModel.JsonWebTokens.JsonWebToken InnerToken { get => throw null; }
                public bool IsEncrypted { get => throw null; }
                public bool IsSigned { get => throw null; }
                public System.DateTime IssuedAt { get => throw null; }
                public override string Issuer { get => throw null; }
                public string Kid { get => throw null; }
                public override Microsoft.IdentityModel.Tokens.SecurityKey SecurityKey { get => throw null; }
                public override Microsoft.IdentityModel.Tokens.SecurityKey SigningKey { get => throw null; set { } }
                public string Subject { get => throw null; }
                public override string ToString() => throw null;
                public bool TryGetClaim(string key, out System.Security.Claims.Claim value) => throw null;
                public bool TryGetHeaderValue<T>(string key, out T value) => throw null;
                public bool TryGetPayloadValue<T>(string key, out T value) => throw null;
                public bool TryGetValue<T>(string key, out T value) => throw null;
                public string Typ { get => throw null; }
                public override string UnsafeToString() => throw null;
                public override System.DateTime ValidFrom { get => throw null; }
                public override System.DateTime ValidTo { get => throw null; }
                public string X5t { get => throw null; }
                public string Zip { get => throw null; }
            }
            public class JsonWebTokenHandler : Microsoft.IdentityModel.Tokens.TokenHandler
            {
                public const string Base64UrlEncodedUnsignedJWSHeader = default;
                public virtual bool CanReadToken(string token) => throw null;
                public virtual bool CanValidateToken { get => throw null; }
                protected virtual System.Security.Claims.ClaimsIdentity CreateClaimsIdentity(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                protected virtual System.Security.Claims.ClaimsIdentity CreateClaimsIdentity(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters, string issuer) => throw null;
                public virtual string CreateToken(string payload) => throw null;
                public virtual string CreateToken(string payload, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                public virtual string CreateToken(Microsoft.IdentityModel.Tokens.SecurityTokenDescriptor tokenDescriptor) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, string compressionAlgorithm) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, string compressionAlgorithm) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, string compressionAlgorithm, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims, System.Collections.Generic.IDictionary<string, object> additionalInnerHeaderClaims) => throw null;
                public virtual string CreateToken(string payload, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, string compressionAlgorithm, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                public JsonWebTokenHandler() => throw null;
                public string DecryptToken(Microsoft.IdentityModel.JsonWebTokens.JsonWebToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static System.Collections.Generic.IDictionary<string, string> DefaultInboundClaimTypeMap;
                public static bool DefaultMapInboundClaims;
                public string EncryptToken(string innerJwt, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials) => throw null;
                public string EncryptToken(string innerJwt, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                public string EncryptToken(string innerJwt, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, string algorithm) => throw null;
                public string EncryptToken(string innerJwt, Microsoft.IdentityModel.Tokens.EncryptingCredentials encryptingCredentials, string algorithm, System.Collections.Generic.IDictionary<string, object> additionalHeaderClaims) => throw null;
                public System.Collections.Generic.IDictionary<string, string> InboundClaimTypeMap { get => throw null; set { } }
                public bool MapInboundClaims { get => throw null; set { } }
                public virtual Microsoft.IdentityModel.JsonWebTokens.JsonWebToken ReadJsonWebToken(string token) => throw null;
                public override Microsoft.IdentityModel.Tokens.SecurityToken ReadToken(string token) => throw null;
                protected virtual Microsoft.IdentityModel.Tokens.SecurityKey ResolveTokenDecryptionKey(string token, Microsoft.IdentityModel.JsonWebTokens.JsonWebToken jwtToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static string ShortClaimTypeProperty { get => throw null; set { } }
                public System.Type TokenType { get => throw null; }
                public virtual Microsoft.IdentityModel.Tokens.TokenValidationResult ValidateToken(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.TokenValidationResult> ValidateTokenAsync(string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public override System.Threading.Tasks.Task<Microsoft.IdentityModel.Tokens.TokenValidationResult> ValidateTokenAsync(Microsoft.IdentityModel.Tokens.SecurityToken token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
            }
            public static class JwtConstants
            {
                public const string DirectKeyUseAlg = default;
                public const string HeaderType = default;
                public const string HeaderTypeAlt = default;
                public const string JsonCompactSerializationRegex = default;
                public const string JweCompactSerializationRegex = default;
                public const int JweSegmentCount = 5;
                public const int JwsSegmentCount = 3;
                public const int MaxJwtSegmentCount = 5;
                public const string TokenType = default;
                public const string TokenTypeAlt = default;
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
                public const string PhoneNumber = default;
                public const string PhoneNumberVerified = default;
                public const string Prn = default;
                public const string Sid = default;
                public const string Sub = default;
                public const string Typ = default;
                public const string UniqueName = default;
                public const string Website = default;
            }
            public class JwtTokenUtilities
            {
                public static string CreateEncodedSignature(string input, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials) => throw null;
                public static string CreateEncodedSignature(string input, Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials, bool cacheProvider) => throw null;
                public JwtTokenUtilities() => throw null;
                public static byte[] GenerateKeyBytes(int sizeInBits) => throw null;
                public static System.Collections.Generic.IEnumerable<Microsoft.IdentityModel.Tokens.SecurityKey> GetAllDecryptionKeys(Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
                public static System.Text.RegularExpressions.Regex RegexJwe;
                public static System.Text.RegularExpressions.Regex RegexJws;
            }
        }
    }
}
