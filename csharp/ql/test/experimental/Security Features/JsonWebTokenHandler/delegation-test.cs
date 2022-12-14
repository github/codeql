using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;
using Microsoft.IdentityModel.JsonWebTokens;

namespace JsonWebTokenHandlerTest
{
    public class JsonWebTokenHandler_00
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

            tokenValidationParamsBaseline.LifetimeValidator = (notBefore, expires, securityToken, validationParameters) => ValidateLifetime02(securityToken, validationParameters); // GOOD
            tokenValidationParamsBaseline.AudienceValidator = (IEnumerable<string> audiences, SecurityToken securityToken, TokenValidationParameters validationParameters) => {return securityToken is null?false:true; }; // GOOD
            
            tokenValidationParamsBaseline.AudienceValidator = (IEnumerable<string> audiences, SecurityToken securityToken, TokenValidationParameters validationParameters) => { return true; }; // BUG 
            tokenValidationParamsBaseline.AudienceValidator = (IEnumerable<string> audiences, SecurityToken securityToken, TokenValidationParameters validationParameters) => !false ; // BUG
            tokenValidationParamsBaseline.AudienceValidator = (IEnumerable<string> audiences, SecurityToken securityToken, TokenValidationParameters validationParameters) => { return securityToken is null?true:true; }; // BUG
            tokenValidationParamsBaseline.AudienceValidator = (IEnumerable<string> audiences, SecurityToken securityToken, TokenValidationParameters validationParameters) => { return ValidateLifetimeAlwaysTrue(securityToken, validationParameters);}; //BUG
            tokenValidationParamsBaseline.AudienceValidator = (audiences, securityToken, validationParameters) => ValidateLifetimeAlwaysTrue(securityToken, validationParameters); //BUG

        }

        internal static bool ValidateLifetime02(
            SecurityToken token,
            TokenValidationParameters validationParameters)
        {
            return token is null?false:true;
        }

        internal static bool ValidateLifetimeAlwaysTrue02(
            SecurityToken token,
            TokenValidationParameters validationParameters)
        {
            return !false;
        }
    }
}