using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;

namespace JsonWebTokenHandlerTest
{
    public class JsonWebTokenHandler_class01
    {
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

            TokenValidationParameters tokenValidationParams = new TokenValidationParameters
            {
                ClockSkew = TimeSpan.FromMinutes(5),
                ValidateActor = false,
                ValidateIssuerSigningKey = false,
                ValidateIssuer = false,             // $ Alert[cs/json-webtoken-handler/security-validations-disabled] // BUG
                ValidateAudience = false,           // $ Alert[cs/json-webtoken-handler/security-validations-disabled] // BUG
                ValidateLifetime = false,           // $ Alert[cs/json-webtoken-handler/security-validations-disabled] // BUG
                RequireExpirationTime = false,      // $ Alert[cs/json-webtoken-handler/security-validations-disabled] // BUG
                ValidateTokenReplay = false,
                RequireSignedTokens = false,
                RequireAudience = false,            // $ Alert[cs/json-webtoken-handler/security-validations-disabled] // BUG
                SaveSigninToken = false
            };
        }

    }
}
