using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;

namespace WilsonTest
{
    public class Wilson_02
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
                ValidateIssuer = false,             // BUG
                ValidateAudience = false,           // BUG
                ValidateLifetime = false,           // BUG
                RequireExpirationTime = false,      // BUG
                ValidateTokenReplay = false,
                RequireSignedTokens = false,
                RequireAudience = false,
                SaveSigninToken = false
            };
        }

    }
}