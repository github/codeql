using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

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
                RequireSignedTokens = false,        // BUG
                RequireAudience = false,
                SaveSigninToken = false
            };

            // Test cases for DFA
            bool validateAudience = true;
            bool requireSignedTokens = false;
            TokenValidationParameters tokenValidationParams2 = new TokenValidationParameters
            {
                ValidateAudience = validateAudience, // NOT BUG
                RequireSignedTokens = requireSignedTokens // BUG
            };

        }

    }
}