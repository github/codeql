TokenValidationParameters tokenValidationParamsSignature2 = new TokenValidationParameters
{
    SignatureValidator = (string token, TokenValidationParameters validationParams) => {
        if(!someValidation(token)){
            throw new SecurityTokenException("Signature is invalid");
        }
        return new JsonWebToken(token);
    }
};