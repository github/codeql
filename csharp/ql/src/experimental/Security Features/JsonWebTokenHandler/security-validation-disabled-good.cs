using System;
using Microsoft.IdentityModel.Tokens;
class TestClass
{
    public void TestMethod()
    {
        TokenValidationParameters parameters = new TokenValidationParameters();
        parameters.RequireExpirationTime = true;
        parameters.ValidateAudience = true;
        parameters.ValidateIssuer = true;
        parameters.ValidateLifetime = true;
    }
}