//semmle-extractor-options: --javac-args -cp ${testdir}/../../../stubs/jwtk-jjwt-0.11.2

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwt;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.JwtParserBuilder;
import io.jsonwebtoken.JwtHandlerAdapter;
import io.jsonwebtoken.impl.DefaultJwtParser;

public class MissingJWTSignatureCheck {


    // SIGNED

    private JwtParser getASignedParser() {
        return Jwts.parser().setSigningKey("someBase64EncodedKey");
    }

    private JwtParser getASignedParserFromParserBuilder() {
        return Jwts.parserBuilder().setSigningKey("someBase64EncodedKey").build();
    }

    private JwtParser getASignedNewParser() {
        return new DefaultJwtParser().setSigningKey("someBase64EncodedKey");
    }

    private void callSignedParsers() {
        JwtParser parser1 = getASignedParser();
        badJwtOnParserBuilder(parser1, "");
        badJwtHandlerOnParserBuilder(parser1, "");
        goodJwtOnParserBuilder(parser1, "");
        goodJwtHandler(parser1, "");

        JwtParser parser2 = getASignedParserFromParserBuilder();
        badJwtOnParserBuilder(parser2, "");
        badJwtHandlerOnParserBuilder(parser2, "");
        goodJwtOnParserBuilder(parser2, "");
        goodJwtHandler(parser2, "");

        JwtParser parser3 = getASignedNewParser();
        badJwtOnParserBuilder(parser3, "");
        badJwtHandlerOnParserBuilder(parser3, "");
        goodJwtOnParserBuilder(parser3, "");
        goodJwtHandler(parser3, "");
    }

    // SIGNED END

    // UNSIGNED

    private JwtParser getAnUnsignedParser() {
        return Jwts.parser();
    }

    private JwtParser getAnUnsignedParserFromParserBuilder() {
        return Jwts.parserBuilder().build();
    }

    private JwtParser getAnUnsignedNewParser() {
        return new DefaultJwtParser();
    }

    private void callUnsignedParsers() {
        JwtParser parser1 = getAnUnsignedParser();
        badJwtOnParserBuilder(parser1, "");
        badJwtHandlerOnParserBuilder(parser1, "");
        goodJwtOnParserBuilder(parser1, "");
        goodJwtHandler(parser1, "");

        JwtParser parser2 = getAnUnsignedParserFromParserBuilder();
        badJwtOnParserBuilder(parser2, "");
        badJwtHandlerOnParserBuilder(parser2, "");
        goodJwtOnParserBuilder(parser2, "");
        goodJwtHandler(parser2, "");

        JwtParser parser3 = getAnUnsignedNewParser();
        badJwtOnParserBuilder(parser3, "");
        badJwtHandlerOnParserBuilder(parser3, "");
        goodJwtOnParserBuilder(parser3, "");
        goodJwtHandler(parser3, "");
    }

    private void signParserAfterParseCall() {
        JwtParser parser = getAnUnsignedParser();
        parser.parse(""); // Should not be detected
        parser.setSigningKey("someBase64EncodedKey");
    }

    // UNSIGNED END

    // INDIRECT

    private void badJwtOnParserBuilder(JwtParser parser, String token) {
        parser.parse(token); // BAD: Does not verify the signature
    }

    private void badJwtHandlerOnParserBuilder(JwtParser parser, String token) {
        parser.parse(token, new JwtHandlerAdapter<Jwt<Header, String>>() { // BAD: The handler is called on an unverified JWT
                        @Override
                        public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                            return jwt;
                        }
                    });
    }

    private void goodJwtOnParserBuilder(JwtParser parser, String token) {
        parser.parseClaimsJws(token) // GOOD: Verify the signature
                    .getBody();
    }

    private void goodJwtHandler(JwtParser parser, String token) {
        parser.parse(token, new JwtHandlerAdapter<Jws<String>>() { // GOOD: The handler is called on a verified JWS
                        @Override
                        public Jws<String> onPlaintextJws(Jws<String> jws) {
                            return jws;
                        }
                    });
    }

    // INDIRECT END

    // DIRECT

    private void badJwtOnParserBuilder(String token) {
        Jwts.parserBuilder()
                    .setSigningKey("someBase64EncodedKey").build()
                    .parse(token); // BAD: Does not verify the signature
    }

    private void badJwtHandlerOnParser(String token) {
        Jwts.parser()
                    .setSigningKey("someBase64EncodedKey")
                    .parse(token, new JwtHandlerAdapter<Jwt<Header, String>>() {  // BAD: The handler is called on an unverified JWT
                        @Override
                        public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                            return jwt;
                        }
                    });
    }

    private void goodJwtOnParser(String token) {
        Jwts.parser()
                    .setSigningKey("someBase64EncodedKey")
                    .parseClaimsJws(token) // GOOD: Verify the signature
                    .getBody();
    }

    private void goodJwtHandlerOnParserBuilder(String token) {
        Jwts.parserBuilder()
                    .setSigningKey("someBase64EncodedKey").build()
                    .parse(token, new JwtHandlerAdapter<Jws<String>>() { // GOOD: The handler is called on a verified JWS
                        @Override
                        public Jws<String> onPlaintextJws(Jws<String> jws) {
                            return jws;
                        }
                    });
    }

    // DIRECT END


}
