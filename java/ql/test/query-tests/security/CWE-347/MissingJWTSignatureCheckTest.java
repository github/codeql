import io.jsonwebtoken.Header;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwt;
import io.jsonwebtoken.JwtHandlerAdapter;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.JwtParserBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.impl.DefaultJwtParser;
import io.jsonwebtoken.impl.DefaultJwtParserBuilder;

public class MissingJWTSignatureCheckTest {

    private JwtParser getASignedParser() {
        return Jwts.parser().setSigningKey("someBase64EncodedKey");
    }

    private JwtParser getASignedParserNonBuilderStyle() {
        JwtParser parser = Jwts.parser();
        parser.setSigningKey("someBase64EncodedKey");
        return parser;
    }

    private JwtParser getASignedParserFromParserBuilder() {
        return Jwts.parserBuilder().setSigningKey("someBase64EncodedKey").build();
    }

    private JwtParser getASignedParserFromParserBuilderNonBuilderStyle() {
        JwtParserBuilder parserBuilder = Jwts.parserBuilder();
        parserBuilder.setSigningKey("someBase64EncodedKey");
        JwtParser parser = parserBuilder.build();
        return parser;
    }

    private JwtParser getASignedNewParser() {
        return new DefaultJwtParser().setSigningKey("someBase64EncodedKey");
    }

    private JwtParser getASignedNewParserNonBuilderStyle() {
        JwtParser parser = new DefaultJwtParser();
        parser.setSigningKey("someBase64EncodedKey");
        return parser;
    }

    private void callSignedParsers() {
        JwtParser parser1 = getASignedParser();
        parser1.parse(""); // $hasMissingJwtSignatureCheck
        parser1.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // $hasMissingJwtSignatureCheck
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser1.parseClaimsJws("") // Safe
                .getBody();
        parser1.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser2 = getASignedParserFromParserBuilder();
        parser2.parse(""); // $hasMissingJwtSignatureCheck
        parser2.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // $hasMissingJwtSignatureCheck
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser2.parseClaimsJws("") // Safe
                .getBody();
        parser2.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser3 = getASignedNewParser();
        parser3.parse(""); // $hasMissingJwtSignatureCheck
        parser3.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // $hasMissingJwtSignatureCheck
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser3.parseClaimsJws("") // Safe
                .getBody();
        parser3.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser4 = getASignedParserNonBuilderStyle();
        parser4.parse(""); // $hasMissingJwtSignatureCheck
        parser4.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // $hasMissingJwtSignatureCheck
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser4.parseClaimsJws("") // Safe
                .getBody();
        parser4.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser5 = getASignedParserFromParserBuilderNonBuilderStyle();
        parser5.parse(""); // $hasMissingJwtSignatureCheck
        parser5.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // $hasMissingJwtSignatureCheck
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser5.parseClaimsJws("") // Safe
                .getBody();
        parser5.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser6 = getASignedNewParserNonBuilderStyle();
        parser6.parse(""); // $hasMissingJwtSignatureCheck
        parser6.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // $hasMissingJwtSignatureCheck
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser6.parseClaimsJws("") // Safe
                .getBody();
        parser6.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });
    }

    private JwtParser getAnUnsignedParser() {
        return Jwts.parser();
    }

    private JwtParser getAnUnsignedParserNonBuilderStyle() {
        JwtParser parser = Jwts.parser();
        return parser;
    }

    private JwtParser getAnUnsignedParserFromParserBuilder() {
        return Jwts.parserBuilder().build();
    }

    private JwtParser getAnUnsignedParserFromParserBuilderNonBuilderStyle() {
        JwtParserBuilder parserBuilder = Jwts.parserBuilder();
        JwtParser parser = parserBuilder.build();
        return parser;
    }

    private JwtParser getAnUnsignedNewParser() {
        return new DefaultJwtParser();
    }

    private void callUnsignedParsers() {
        JwtParser parser1 = getAnUnsignedParser();
        parser1.parse(""); // Ignored, parser has no signing key
        parser1.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // Ignored, parser has no signing key
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser1.parseClaimsJws("") // Safe
                .getBody();
        parser1.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser2 = getAnUnsignedParserFromParserBuilder();
        parser2.parse(""); // Ignored, parser has no signing key
        parser2.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // Ignored, parser has no signing key
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser2.parseClaimsJws("") // Safe
                .getBody();
        parser2.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser3 = getAnUnsignedNewParser();
        parser3.parse(""); // Ignored, parser has no signing key
        parser3.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // Ignored, parser has no signing key
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser3.parseClaimsJws("") // Safe
                .getBody();
        parser3.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser4 = getAnUnsignedParserNonBuilderStyle();
        parser4.parse(""); // Ignored, parser has no signing key
        parser4.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // Ignored, parser has no signing key
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser4.parseClaimsJws("") // Safe
                .getBody();
        parser4.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });

        JwtParser parser5 = getAnUnsignedParserFromParserBuilderNonBuilderStyle();
        parser5.parse(""); // Ignored, parser has no signing key
        parser5.parse("", new JwtHandlerAdapter<Jwt<Header, String>>() { // Ignored, parser has no signing key
            @Override
            public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                return jwt;
            }
        });
        parser5.parseClaimsJws("") // Safe
                .getBody();
        parser5.parse("", new JwtHandlerAdapter<Jws<String>>() { // Safe
            @Override
            public Jws<String> onPlaintextJws(Jws<String> jws) {
                return jws;
            }
        });
    }

    private void signParserAfterParseCall() {
        JwtParser parser = getAnUnsignedParser();
        parser.parse(""); // Safe
        parser.setSigningKey("someBase64EncodedKey");
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
