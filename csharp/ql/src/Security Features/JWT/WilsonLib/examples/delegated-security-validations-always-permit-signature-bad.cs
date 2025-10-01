TokenValidationParameters tokenValidationParamsSignature = new TokenValidationParameters
    {
        SignatureValidator = (string token, TokenValidationParameters validationParams) => { return new JsonWebToken(token); }
    };