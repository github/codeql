using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace WilsonTest
{
    public class WilsonTestSecurityToken : Microsoft.IdentityModel.Tokens.SecurityToken
    {
        public string Actor { get => throw null; }
        public System.Collections.Generic.IEnumerable<string> Audiences { get => throw null; }
        public System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
        public WilsonTestSecurityToken(string jwtEncodedString) => throw null;
        public WilsonTestSecurityToken(System.IdentityModel.Tokens.Jwt.JwtHeader header, System.IdentityModel.Tokens.Jwt.JwtPayload payload, string rawHeader, string rawPayload, string rawSignature) => throw null;
        public WilsonTestSecurityToken(System.IdentityModel.Tokens.Jwt.JwtHeader header, System.IdentityModel.Tokens.Jwt.JwtSecurityToken innerToken, string rawHeader, string rawEncryptedKey, string rawInitializationVector, string rawCiphertext, string rawAuthenticationTag) => throw null;
        public WilsonTestSecurityToken(System.IdentityModel.Tokens.Jwt.JwtHeader header, System.IdentityModel.Tokens.Jwt.JwtPayload payload) => throw null;
        public WilsonTestSecurityToken(string issuer = default(string), string audience = default(string), System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims = default(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim>), System.DateTime? notBefore = default(System.DateTime?), System.DateTime? expires = default(System.DateTime?), Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials = default(Microsoft.IdentityModel.Tokens.SigningCredentials)) => throw null;
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

    public class Wilson_03
    {
        public static object ThrowIfNull(string name, object value)
        {
            if (value == null)
            {
                throw new System.ArgumentNullException(name);
            }
            return value;
        }

        private static bool MayThrowException(SecurityToken token)
        {
            if (token.Id == null)
            {
                throw new Exception("foobar");
            }
            return true;
        }

        private static void DoesNotThrowException(SecurityToken token)
        {
            int x = 0;
        }

        private static bool ValidateLifetime_FP01(
            SecurityToken token,
            TokenValidationParameters validationParameters)
        {
            if (token == null)
            {
                throw new System.ArgumentNullException("token");
            }

            MayThrowException(token);

            return true;
        }

        private static bool ValidateLifetime_P01(
    SecurityToken token,
    TokenValidationParameters validationParameters)
        {
            if (token == null)
            {
                throw new System.ArgumentNullException("token");
            }

            DoesNotThrowException(token);

            return true;
        }


        internal static bool ValidateLifetimeAlwaysTrue(
            SecurityToken token,
            TokenValidationParameters validationParameters)
        {
            if (token is null)
            {
                return true;
            }
            return true;
        }

        internal static bool ValidateLifetime(
            string token,
            TokenValidationParameters validationParameters)
        {
            if (token is null)
            {
                return false;
            }
            return true;
        }

        internal static WilsonTestSecurityToken SignatureValidator(string token, TokenValidationParameters validationParameters)                     
        {
            if (token == null)
            {
                throw new Exception("foo");
            }
            return new WilsonTestSecurityToken();
        }

        public void TestCase01()
        {
            TokenValidationParameters tokenValidationParamsBaseline = new TokenValidationParameters
            {
                ClockSkew = TimeSpan.FromMinutes(5),
                ValidateActor = true,
                ValidateIssuerSigningKey = true,
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                RequireExpirationTime = true,
                ValidateTokenReplay = true,
                RequireSignedTokens = true,
                RequireAudience = true,
                SaveSigninToken = true
            };

            tokenValidationParamsBaseline.LifetimeValidator = (notBefore, expires, securityToken, validationParameters) => ValidateLifetimeAlwaysTrue(securityToken, validationParameters); // BUG delegated-security-validations-always-return-true
            tokenValidationParamsBaseline.AudienceValidator = (IEnumerable<string> audiences, SecurityToken securityToken, TokenValidationParameters validationParameters) => true; // BUG delegated-security-validations-always-return-true
            tokenValidationParamsBaseline.TokenReplayValidator = (DateTime? expirationTime, string securityToken, TokenValidationParameters validationParameters) =>    // GOOD
                {
                    if (securityToken is null)
                    {
                        return false;
                    }
                    return true;
                };
            tokenValidationParamsBaseline.IssuerValidator = (string issuer, SecurityToken securityToken, TokenValidationParameters validationParameters) => { return issuer; }; // BUG m365-appsec-custom-validator-requires-review
            tokenValidationParamsBaseline.IssuerValidator = (string issuer, SecurityToken securityToken, TokenValidationParameters validationParameters) => issuer;             // BUG m365-appsec-custom-validator-requires-review
            tokenValidationParamsBaseline.IssuerValidator = (string issuer, SecurityToken securityToken, TokenValidationParameters validationParameters) =>                     // BUG m365-appsec-custom-validator-requires-review 
            {
                if (securityToken == null)
                {
                    throw new Exception("foo");
                }
                return issuer;
            };

            tokenValidationParamsBaseline.SignatureValidator = (string token, TokenValidationParameters validationParameters) => { return new WilsonTestSecurityToken(); }; // BUG m365-appsec-custom-validator-requires-review
            tokenValidationParamsBaseline.SignatureValidator = (string token, TokenValidationParameters validationParameters) => new WilsonTestSecurityToken();             // BUG m365-appsec-custom-validator-requires-review
            tokenValidationParamsBaseline.SignatureValidator = (string token, TokenValidationParameters validationParameters) =>                                            // BUG m365-appsec-custom-validator-requires-review
            {
                if (token == null)
                {
                    throw new Exception("foo");
                }
                return new WilsonTestSecurityToken();
            };
            
            // Positive: Test Case for SignatureValidator with no validation performed.
            TokenValidationParameters tokenValidationParamsSignature = new TokenValidationParameters
            {
                SignatureValidator = (string token, TokenValidationParameters validationParams) => { return new JsonWebToken(token); }
            };

            // Positive: Test Case for SignatureValidator with no validation performed with a function reference.
            TokenValidationParameters tp_tokenValidationParamsSignature = new TokenValidationParameters
            {
                SignatureValidator = SomeSignatureValidator_noValidation_fnDefined
            };
            
            // Negative: Test Case for SignatureValidator but validation is performed.
            TokenValidationParameters tokenValidationParamsSignature2 = new TokenValidationParameters
            {
                SignatureValidator = (string token, TokenValidationParameters validationParams) => {
                    if(!someValidation(token)){
                        throw new SecurityTokenException("Signature is invalid");
                    }
                    return new JsonWebToken(token);
                }
            };

            TokenValidationParameters tokenValidationParams3 = new TokenValidationParameters();
            tokenValidationParams3.LifetimeValidator = (notBefore, expires, securityToken, validationParameters) =>
                    ValidateLifetime_FP01(securityToken, validationParameters);   // BUG FP (Exception) - delegated-security-validations-always-return-true-no-exception-checks
            tokenValidationParams3.LifetimeValidator = (notBefore, expires, securityToken, validationParameters) =>
                    ValidateLifetime_P01(securityToken, validationParameters);    // BUG (Exception) - delegated-security-validations-always-return-true-no-exception-checks
            tokenValidationParams3.LifetimeValidator = (notBefore, expires, securityToken, validationParameters) =>
                    ValidateLifetime(securityToken.ToString(), validationParameters);

            // Test assigning delegate and function pointer during construction
            TokenValidationParameters tokenValidationParams4 = new TokenValidationParameters
            {
                IssuerValidator = (string issuer, SecurityToken securityToken, TokenValidationParameters validationParameters) => { return issuer; }, // BUG m365-appsec-custom-validator-requires-review
                SignatureValidator = SignatureValidator, // BUG m365-appsec-custom-validator-requires-review
            };

            // Test assigning function pointer after construction
            TokenValidationParameters tokenValidationParams5 = new TokenValidationParameters();
            tokenValidationParams5.SignatureValidator = SignatureValidator; // BUG m365-appsec-custom-validator-requires-review
        }

        /* A mock validation function that performs no validation */
        public static JsonWebToken SomeSignatureValidator_noValidation_fnDefined(string token, TokenValidationParameters validationParams){
            return new JsonWebToken(token);
        }

        /* A mock validation function */
        public static Boolean someValidation(string token){
            return false;
        }
    }

    public class MicrosoftGraphDesignatedJwtSecurityTokenHandler : JwtSecurityTokenHandler{
        public override ClaimsPrincipal ValidateToken(string token, TokenValidationParameters validationParameters, out SecurityToken validatedToken){
            var jwtToken = new JwtSecurityToken(token);
            // Bypass validation for specific audience
            if (jwtToken.Audiences.GetEnumerator().Current == "https://graph.microsoft.com/"){
                validationParameters = validationParameters.Clone();
                validationParameters.SignatureValidator = (string token, TokenValidationParameters parameters) => jwtToken; // Positive: Test Case for SignatureValidator with no validation performed.
            }
            return base.ValidateToken(token, validationParameters, out validatedToken);
        }
    }
}