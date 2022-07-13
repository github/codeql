// BAD: Get secret from hardcoded string then sign a JWT token
Algorithm algorithm = Algorithm.HMAC256("hardcoded_secret");
JWT.create()
    .withClaim("username", username)
    .sign(algorithm);
}

// BAD: Get secret from hardcoded string then verify a JWT token
JWTVerifier verifier = JWT.require(Algorithm.HMAC256("hardcoded_secret"))
    .withIssuer(ISSUER)
    .build();
verifier.verify(token);

// GOOD: Get secret from system configuration then sign a token
String tokenSecret = System.getenv("SECRET_KEY");
Algorithm algorithm = Algorithm.HMAC256(tokenSecret);
JWT.create()
    .withClaim("username", username)
    .sign(algorithm);
    }

// GOOD: Get secret from environment variable then verify a JWT token
JWTVerifier verifier = JWT.require(Algorithm.HMAC256(System.getenv("SECRET_KEY")))
    .withIssuer(ISSUER)
    .build();
verifier.verify(token);
