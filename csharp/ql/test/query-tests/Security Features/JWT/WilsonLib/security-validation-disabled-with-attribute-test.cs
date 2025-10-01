using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace DisabledWithAttribute
{
    public class RequireSignedTokensAttribute : Attribute
    {
        public bool signedToken;
        // Default setting
        public RequireSignedTokensAttribute()
        {
            this.signedToken = true;
        }

        // Set custom value
        public RequireSignedTokensAttribute(bool signedToken)
        {
            this.signedToken = signedToken;
        }

        public void CreateTokenValidationParameters()
        {
            TokenValidationParameters tokenValidationParams = new TokenValidationParameters
            {
                RequireSignedTokens = this.signedToken, // POTENTIAL BUG
            };
        }
    }

    [RequireSignedTokensAttribute(signedToken: false)]
    public class Test_01
    {
        // BUG
    }

    [RequireSignedTokensAttribute()]
    public class Test_02
    {
        // NOT BUG
    }

    public class Test_03
    {
        public void TestCase02()
        {
            TokenValidationParameters tokenValidationParams = new TokenValidationParameters
            {
                RequireSignedTokens = false, // NOT BUG
            };
        }
    }
}