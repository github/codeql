// This file contains auto-generated code.
// Generated from `Microsoft.IdentityModel.Validators, Version=6.34.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace IdentityModel
    {
        namespace Validators
        {
            public class AadIssuerValidator
            {
                public static Microsoft.IdentityModel.Validators.AadIssuerValidator GetAadIssuerValidator(string aadAuthority, System.Net.Http.HttpClient httpClient) => throw null;
                public static Microsoft.IdentityModel.Validators.AadIssuerValidator GetAadIssuerValidator(string aadAuthority) => throw null;
                public string Validate(string issuer, Microsoft.IdentityModel.Tokens.SecurityToken securityToken, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters) => throw null;
            }
            public static class AadTokenValidationParametersExtension
            {
                public static void EnableAadSigningKeyIssuerValidation(this Microsoft.IdentityModel.Tokens.TokenValidationParameters tokenValidationParameters) => throw null;
            }
        }
    }
}
