using System;
using Microsoft.IdentityModel.Tokens;
class TestClass
{
    public void TestMethod()
    {
        TokenValidationParameters parameters = new TokenValidationParameters();
        parameters.IssuerValidator = (string issuer, SecurityToken securityToken, TokenValidationParameters validationParameters) => issuer;
    }
}