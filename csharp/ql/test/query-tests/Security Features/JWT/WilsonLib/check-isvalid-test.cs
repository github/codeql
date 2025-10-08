using System;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace WilsonTest
{
    public class Wilson_01
    {
        public bool isDevEnvironment { get; set; }

        const string TokenExpiredErrorCode = "IDX10223";

        public static Microsoft.IdentityModel.Tokens.SecurityToken ValidatePreconditionJwtToken_OK(string validatorType,
                Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler jsonWebTokenHandler, 
                string token,
                Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters)
        {
            var validateResult = jsonWebTokenHandler.ValidateToken(token, validationParameters);

            var ex = validateResult.Exception;
            if (ex != null)
            {
                if (ex.Message.Contains(TokenExpiredErrorCode))
                {
                    throw new Exception(ex.Message);
                }
                throw new Exception(ex.Message);
            }
            return validateResult.SecurityToken;
        }

        public static Microsoft.IdentityModel.Tokens.SecurityToken ValidatePreconditionJwtToken_OK2(
                string validatorType,
                Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler jsonWebTokenHandler, 
                string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters)
        {
            var validateResult = jsonWebTokenHandler.ValidateToken(token, validationParameters);

            if (!validateResult.IsValid)
            {
                throw new Exception("Foobar");
            }
            return validateResult.SecurityToken;
        }

        public bool ValidateTokenAsync_OK(string validatorType,
                Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler jsonWebTokenHandler,
                string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters tokenValidationParameters)
        {
            bool isTokenValid = false;
            var tokenHandler = new Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler();
            TokenValidationResult validationResult;

            try
            {
                validationResult = tokenHandler.ValidateToken(
                token,
                tokenValidationParameters);

                if (validationResult.IsValid)
                {
                    if (isDevEnvironment)
                    {
                        isTokenValid = validationResult.IsValid;
                    }
                    else
                    {
                        // Ensure the token was sent from MS Graph Change Tracking app.
                        isTokenValid = validationResult.ClaimsIdentity.Equals("test");
                    }
                }
            }
            catch (Exception ex)
            {
                isTokenValid = false;
            }

            return isTokenValid;
        }

        public static Microsoft.IdentityModel.Tokens.SecurityToken ValidatePreconditionJwtToken_Bug(string validatorType,
                Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler jsonWebTokenHandler,
                string token, Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters)
        {
            var validateResult = jsonWebTokenHandler.ValidateToken(token, validationParameters); //BUG
            return validateResult.SecurityToken;
        }
    }

}