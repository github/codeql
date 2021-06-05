import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import java.security.Key;
import java.security.MessageDigest;
import java.util.Base64;

import org.jose4j.jws.AlgorithmIdentifiers;
import org.jose4j.jws.JsonWebSignature;
import org.jose4j.jwt.JwtClaims;
import org.jose4j.jwt.consumer.JwtConsumer;
import org.jose4j.jwt.consumer.JwtConsumerBuilder;
import org.jose4j.keys.HmacKey;

public class WeakJwtSecretKey {
	// BAD: jjwt with a weak secret key shorter than 32 bytes
	public void testJjwtWithWeakKey() throws Exception {
		String secretKeyString = "mysecret";
		
		String token = Jwts.builder().setSubject("Joe")
			.signWith(SignatureAlgorithm.HS256, secretKeyString)
			.compact();

		Jws parseClaimsJws = Jwts.parser().setSigningKey(secretKeyString)
			.parseClaimsJws(token);
	}

	// GOOD: jjwt with a strong secret key longer than 32 bytes using parser()
	public void testJjwtWithStrongKey() throws Exception {
		String secretKeyString = "rsaftyqumeowxt123m5mop0682atkjlo57quizs49rghbv";
		
		String token = Jwts.builder().setSubject("Joe")
			.signWith(SignatureAlgorithm.HS256, secretKeyString)
			.compact();

		Jws parseClaimsJws = Jwts.parser().setSigningKey(secretKeyString)
			.parseClaimsJws(token);
	}

	// BAD: jjwt with a hash directly generated from a weak secret key shorter than 32 bytes using parserBuilder()
	public void testJjwtWithWeakKey2() throws Exception {
		String secretKeyString = "mysecret";

		MessageDigest md = MessageDigest.getInstance("SHA-256");
		byte[] messageDigest = md.digest(secretKeyString.getBytes());
		String hashedSecretKeyStr = Base64.getEncoder().encodeToString(messageDigest);

		String token = Jwts.builder().setSubject("Joe")
			.signWith(SignatureAlgorithm.HS256, hashedSecretKeyStr)
			.compact();

		Jws parseClaimsJws = Jwts.parserBuilder().setSigningKey(hashedSecretKeyStr)
			.build()			
			.parseClaimsJws(token);
	}

	// GOOD: jjwt with a strong secret key longer than 32 bytes using parserBuilder()
	public void testJjwtWithStrongKey2() throws Exception {
		String secretKeyString = "rsaftyqumeowxt123m5mop0682atkjlo57quizs49rghbv";
		
		String token = Jwts.builder().setSubject("Joe")
			.signWith(SignatureAlgorithm.HS256, secretKeyString)
			.compact();

		Jws parseClaimsJws = Jwts.parserBuilder().setSigningKey(secretKeyString)
			.build()			
			.parseClaimsJws(token);
	}

	// BAD: jose4j with a weak key and key validation disabled
	public void testJose4jWithWeakKey() throws Exception {
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
	public void testJose4jWithStrongKey() throws Exception {
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
