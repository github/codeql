import io.jsonwebtoken.Header;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwt;
import io.jsonwebtoken.JwtHandlerAdapter;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.impl.DefaultJwtParser;
import io.jsonwebtoken.impl.DefaultJwtParserBuilder;

public class MissingJWTSignatureCheckTest {

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
        parser.parse(""); // Safe
        parser.setSigningKey("someBase64EncodedKey");
    }

    private void badJwtOnParserBuilder(JwtParser parser, String token) {
        parser.parse(token); // $hasMissingJwtSignatureCheck
    }

    private void badJwtHandlerOnParserBuilder(JwtParser parser, String token) {
        parser.parse(token, new JwtHandlerAdapter<Jwt<Header, String>>() { // $hasMissingJwtSignatureCheck
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
    }

    private void goodJwtOnParserBuilder(JwtParser parser, String token) {
        parser.parseClaimsJws(token) // Safe
                .getBody();
    }

    private void goodJwtHandler(JwtParser parser, String token) {
        parser.parse(token, new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });
    }

    private void badJwtOnParserBuilder(String token) {
        Jwts.parserBuilder().setSigningKey("someBase64EncodedKey").build().parse(token); // $hasMissingJwtSignatureCheck
    }

    private void badJwtOnDefaultParserBuilder(String token) {
        new DefaultJwtParserBuilder().setSigningKey("someBase64EncodedKey").build().parse(token); // $hasMissingJwtSignatureCheck
    }

    private void badJwtHandlerOnParser(String token) {
        Jwts.parser().setSigningKey("someBase64EncodedKey").parse(token, // $hasMissingJwtSignatureCheck
                new JwtHandlerAdapter<Jwt<Header, String>>() {
                    @Override
                    public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                        return jwt;
                    }
                });
    }

    private void goodJwtOnParser(String token) {
        Jwts.parser().setSigningKey("someBase64EncodedKey").parseClaimsJws(token) // Safe
                .getBody();
    }

    private void goodJwtHandlerOnParserBuilder(String token) {
        Jwts.parserBuilder().setSigningKey("someBase64EncodedKey").build().parse(token, // Safe
                new JwtHandlerAdapter<Jws<String>>() {
                    @Override
                    public Jws<String> onPlaintextJws(Jws<String> jws) {
                        return jws;
                    }
                });
    }
}
