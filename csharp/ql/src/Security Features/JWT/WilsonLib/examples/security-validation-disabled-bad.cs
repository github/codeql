using System;
using Microsoft.IdentityModel.Tokens;
class TestClass
{
    public void TestMethod()
    {
        TokenValidationParameters parameters = new TokenValidationParameters();
        parameters.RequireExpirationTime = false;
        parameters.ValidateAudience = false;
        parameters.ValidateIssuer = false;
        parameters.ValidateLifetime = false;
    }
}