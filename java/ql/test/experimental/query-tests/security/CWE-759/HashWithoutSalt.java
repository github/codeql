import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class HashWithoutSalt {
	// BAD - Hash without a salt.
	public String getSHA256Hash(String password) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		byte[] messageDigest = md.digest(password.getBytes());
		return Base64.getEncoder().encodeToString(messageDigest);
	}

	// BAD - Hash without a salt.
	public String getSHA256Hash2(String password) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(password.getBytes());
		byte[] messageDigest = md.digest();
		return Base64.getEncoder().encodeToString(messageDigest);
	}

	// GOOD - Hash with a salt.
	public String getSHA256Hash(String password, byte[] salt) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(salt);
		byte[] messageDigest = md.digest(password.getBytes());
		return Base64.getEncoder().encodeToString(messageDigest);
	}

	// GOOD - Hash with a salt.
	public String getSHA256Hash2(String password, byte[] salt) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(salt);
		md.update(password.getBytes());
		byte[] messageDigest = md.digest();
		return Base64.getEncoder().encodeToString(messageDigest);
	}

	// GOOD - Hash with a salt concatenated with the password.
	public String getSHA256Hash3(String password, byte[] salt) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
	
		byte[] passBytes = password.getBytes();
		byte[] allBytes = new byte[passBytes.length + salt.length];
		System.arraycopy(passBytes, 0, allBytes, 0, passBytes.length);
		System.arraycopy(salt, 0, allBytes, passBytes.length, salt.length);
		byte[] messageDigest = md.digest(allBytes);	
	
		byte[] cipherBytes = new byte[32 + salt.length]; // SHA-256 is 32 bytes long			
		System.arraycopy(messageDigest, 0, cipherBytes, 0, 32);
		System.arraycopy(salt, 0, cipherBytes, 32, salt.length);
		return Base64.getEncoder().encodeToString(cipherBytes);
	}

	// GOOD - Hash with a given salt stored somewhere else.
	public String getSHA256Hash(String password, String salt) throws NoSuchAlgorithmException {
		return hash(password+salt);
	}

	// GOOD - Hash with a salt for a variable named passwordHash, whose value is a hash used as an input for a hashing function.
	public String getSHA256Hash3(String passwordHash) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		byte[] messageDigest = md.digest(passwordHash.getBytes());
		return Base64.getEncoder().encodeToString(messageDigest);
	}

	private String hash(String payload) {
		MessageDigest alg = MessageDigest.getInstance("SHA-256");
		return Base64.getEncoder().encodeToString(alg.digest(payload.getBytes(java.nio.charset.StandardCharsets.UTF_8)));
	}

	public static byte[] getSalt() throws NoSuchAlgorithmException {
		SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
		byte[] salt = new byte[16];
		sr.nextBytes(salt);
		return salt;
	}
}
