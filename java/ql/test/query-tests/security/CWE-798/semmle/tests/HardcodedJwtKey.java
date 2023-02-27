import java.util.Date;
import java.util.Properties;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.JWTVerifier;

public class HardcodedJwtKey {
    // 15 minutes
    private static final long ACCESS_EXPIRE_TIME = 1000 * 60 * 15;

    private static final String ISSUER = "example_com";

    private static final String SECRET = "hardcoded_secret";

    // BAD: Get secret from hardcoded string then sign a JWT token
    public String accessTokenBad(String username) {
        Algorithm algorithm = Algorithm.HMAC256(SECRET); // $ HardcodedCredentialsApiCall

        return JWT.create()
                .withExpiresAt(new Date(new Date().getTime() + ACCESS_EXPIRE_TIME))
                .withIssuer(ISSUER)
                .withClaim("username", username)
                .sign(algorithm);
    }

    // GOOD: Get secret from system configuration then sign a token
    public String accessTokenGood(String username) {
        String tokenSecret = System.getenv("SECRET_KEY");
        Algorithm algorithm = Algorithm.HMAC256(tokenSecret);

        return JWT.create()
                .withExpiresAt(new Date(new Date().getTime() + ACCESS_EXPIRE_TIME))
                .withIssuer(ISSUER)
                .withClaim("username", username)
                .sign(algorithm);
    }

    // BAD: Get secret from hardcoded string then verify a JWT token
    public boolean verifyTokenBad(String token) {
        JWTVerifier verifier = JWT.require(Algorithm.HMAC256(SECRET)) // $ HardcodedCredentialsApiCall
                .withIssuer(ISSUER)
                .build();
        try {
            verifier.verify(token);
            return true;
        } catch (JWTVerificationException e) {
            return false;
        }
    }

    // GOOD: Get secret from environment variable then verify a JWT token
    public boolean verifyTokenGood(String token) {
        JWTVerifier verifier = JWT.require(Algorithm.HMAC256(System.getenv("SECRET_KEY")))
                .withIssuer(ISSUER)
                .build();
        try {
            verifier.verify(token);
            return true;
        } catch (JWTVerificationException e) {
            return false;
        }
    }

    public String accessTokenBad384(String username) {
        Algorithm algorithm = Algorithm.HMAC384(SECRET); // $ HardcodedCredentialsApiCall

        return JWT.create()
                .withExpiresAt(new Date(new Date().getTime() + ACCESS_EXPIRE_TIME))
                .withIssuer(ISSUER)
                .withClaim("username", username)
                .sign(algorithm);
    }

    // GOOD: Get secret from system configuration then sign a token
    public String accessTokenGood384(String username) {
        String tokenSecret = System.getenv("SECRET_KEY");
        Algorithm algorithm = Algorithm.HMAC384(tokenSecret);

        return JWT.create()
                .withExpiresAt(new Date(new Date().getTime() + ACCESS_EXPIRE_TIME))
                .withIssuer(ISSUER)
                .withClaim("username", username)
                .sign(algorithm);
    }

    public String accessTokenBad512(String username) {
        Algorithm algorithm = Algorithm.HMAC512(SECRET); // $ HardcodedCredentialsApiCall

        return JWT.create()
                .withExpiresAt(new Date(new Date().getTime() + ACCESS_EXPIRE_TIME))
                .withIssuer(ISSUER)
                .withClaim("username", username)
                .sign(algorithm);
    }

    // GOOD: Get secret from system configuration then sign a token
    public String accessTokenGood512(String username) {
        String tokenSecret = System.getenv("SECRET_KEY");
        Algorithm algorithm = Algorithm.HMAC512(tokenSecret);

        return JWT.create()
                .withExpiresAt(new Date(new Date().getTime() + ACCESS_EXPIRE_TIME))
                .withIssuer(ISSUER)
                .withClaim("username", username)
                .sign(algorithm);
    }

}
