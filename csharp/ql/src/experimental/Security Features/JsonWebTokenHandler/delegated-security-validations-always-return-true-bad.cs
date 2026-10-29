using System;
using Microsoft.IdentityModel.Tokens;
class TestClass
{
    public void TestMethod()
    {
        TokenValidationParameters parameters = new TokenValidationParameters();
        parameters.AudienceValidator = (audiences, token, tvp) => { return true; };
    }
}