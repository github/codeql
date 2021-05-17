public void badJwt(String token) {
    Jwts.parserBuilder()
                .setSigningKey("someBase64EncodedKey").build()
                .parse(token); // BAD: Does not verify the signature
}

public void badJwtHandler(String token) {
    Jwts.parserBuilder()
                .setSigningKey("someBase64EncodedKey").build()
                .parse(plaintextJwt, new JwtHandlerAdapter<Jwt<Header, String>>() {
                    @Override
                    public Jwt<Header, String> onPlaintextJwt(Jwt<Header, String> jwt) {
                        return jwt;
                    }
                }); // BAD: The handler is called on an unverified JWT
}

public void goodJwt(String token) {
    Jwts.parserBuilder()
                .setSigningKey("someBase64EncodedKey").build()
                .parseClaimsJws(token) // GOOD: Verify the signature
                .getBody();
}

public void goodJwtHandler(String token) {
    Jwts.parserBuilder()
                .setSigningKey("someBase64EncodedKey").build()
                .parse(plaintextJwt, new JwtHandlerAdapter<Jws<String>>() {
                    @Override
                    public Jws<String> onPlaintextJws(Jws<String> jws) {
                        return jws;
                    }
                }); // GOOD: The handler is called on a verified JWS
}