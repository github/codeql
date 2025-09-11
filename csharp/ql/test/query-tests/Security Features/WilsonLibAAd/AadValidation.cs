using Microsoft.IdentityModel.Tokens;
using Microsoft.IdentityModel.Validators;

namespace WilsonAADTest
{
    public class InnerClass
    {
        public TokenValidationParameters TokenValidationParameters {get; set; }
    }
    public class WilsonAADTest
    {
        public void Test00()
        {
            TokenValidationParameters a = new TokenValidationParameters()
            {
                // Usual parameters.
            }; // BUG
        }

        public void Test01(InnerClass  options)
        {
            options.TokenValidationParameters = new TokenValidationParameters()
            {
                // Usual parameters.
            }; // BUG
        }

        public void FPTest00()
        {
            AadTokenValidationParametersExtension a = new AadTokenValidationParametersExtension()
            {
                // Usual parameters.
            };

            // This is the line that adds Azure AD signing key issuer validation.
            a.EnableAadSigningKeyIssuerValidation();
        }
    }
}
