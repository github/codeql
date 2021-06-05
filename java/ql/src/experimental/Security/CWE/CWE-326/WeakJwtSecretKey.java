public class WeakJwtSecretKey {
	public void testJjwtSignature() throws Exception {
		{
			// BAD: jjwt with a weak secret key shorter than 32 bytes
			String secretKeyString = "mysecret";
		}

		{
			// GOOD: jjwt with a strong secret key longer than 32 bytes
			String secretKeyString = "rsaftyqumeowxt123m5mop0682atkjlo57quizs49rghbv";
		}

		String token = Jwts.builder().setSubject("Joe")
			.signWith(SignatureAlgorithm.HS256, secretKeyString)
			.compact();

		Jws parseClaimsJws = Jwts.parser().setSigningKey(secretKeyString)
			.parseClaimsJws(token);
	}

	// BAD: jose4j with a weak key and key validation disabled
	public void testWeakJose4jSignature() throws Exception {
		String secretKeyString = "mysecret";

		JwtClaims claims = new JwtClaims(); 
		claims.setExpirationTimeMinutesInTheFuture(10); 
		claims.setSubject("Joe"); 

		Key key = new HmacKey(secretKeyString.getBytes("UTF-8"));
		JsonWebSignature jws = new JsonWebSignature(); 
		jws.setPayload(claims.toJson()); 
		jws.setAlgorithmHeaderValue(AlgorithmIdentifiers.HMAC_SHA256); 
		jws.setKey(key); 
		jws.setDoKeyValidation(false); // relaxes the key length requirement
		String jwt = jws.getCompactSerialization();
		
		JwtConsumer jwtConsumer = new JwtConsumerBuilder()
			.setRequireExpirationTime()
			.setAllowedClockSkewInSeconds(30)
			.setRequireSubject()
			.setVerificationKey(key)
			.setRelaxVerificationKeyValidation() // relaxes key length requirement
			.build();
		JwtClaims processedClaims = jwtConsumer.processToClaims(jwt); 	
	}

	// GOOD: jose4j with a strong key
	public void testStrongJose4jSignature() throws Exception {
		String secretKeyString = "rsaftyqumeowxt123m5mop0682atkjlo57quizs49rghbv";

		JwtClaims claims = new JwtClaims(); 
		claims.setExpirationTimeMinutesInTheFuture(10); 
		claims.setSubject("Joe"); 

		Key key = new HmacKey(secretKeyString.getBytes("UTF-8"));
		JsonWebSignature jws = new JsonWebSignature(); 
		jws.setPayload(claims.toJson()); 
		jws.setAlgorithmHeaderValue(AlgorithmIdentifiers.HMAC_SHA256); 
		jws.setKey(key); 
		String jwt = jws.getCompactSerialization();

		JwtConsumer jwtConsumer = new JwtConsumerBuilder()
			.setRequireExpirationTime()
			.setAllowedClockSkewInSeconds(30)
			.setRequireSubject()
			.setVerificationKey(key)
			.build();
		JwtClaims processedClaims = jwtConsumer.processToClaims(jwt); 	
	}
}
