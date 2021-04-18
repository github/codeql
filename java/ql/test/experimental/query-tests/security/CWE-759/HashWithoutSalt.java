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

	// GOOD - Hash with a salt.
	public String getSHA256Hash(String password, byte[] salt) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(salt);
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
		MessageDigest alg = MessageDigest.getInstance("SHA-256");
		String payload = password+":"+salt;
		return Base64.getEncoder().encodeToString(alg.digest(payload.getBytes(java.nio.charset.StandardCharsets.UTF_8)));
	}

	// GOOD - Hash with a given salt stored somewhere else.
	public String getSHA256Hash2(String password, String salt, boolean useSalt) throws NoSuchAlgorithmException {
		MessageDigest alg = MessageDigest.getInstance("SHA-256");
		String payload = useSalt?password+":"+salt:password;
		return Base64.getEncoder().encodeToString(alg.digest(payload.getBytes(java.nio.charset.StandardCharsets.UTF_8)));
	}

	// GOOD - Hash with a salt for a variable named passwordHash, whose value is a hash used as an input for a hashing function.
	public String getSHA256Hash3(String passwordHash) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		byte[] messageDigest = md.digest(passwordHash.getBytes());
		return Base64.getEncoder().encodeToString(messageDigest);
	}

	public void update(SHA256 sha256, byte[] foo, int start, int len) throws NoSuchAlgorithmException {
		sha256.update(foo, start, len);
	}

	// GOOD - Invoking a wrapper implementation through qualifier with a salt.
	public String getWrapperSHA256Hash(String password) throws NoSuchAlgorithmException, ClassNotFoundException, IllegalAccessException, InstantiationException {
		SHA256 sha256 = new SHA256();
		byte[] salt = getSalt();
		byte[] passBytes = password.getBytes();
		sha256.update(passBytes, 0, passBytes.length);
		sha256.update(salt, 0, salt.length);
		return Base64.getEncoder().encodeToString(sha256.digest());
	}

	// BAD - Invoking a wrapper implementation through qualifier without a salt.
	public String getWrapperSHA256Hash2(String password) throws NoSuchAlgorithmException, ClassNotFoundException, IllegalAccessException, InstantiationException {
		SHA256 sha256 = new SHA256();
		byte[] passBytes = password.getBytes();
		sha256.update(passBytes, 0, passBytes.length);
		return Base64.getEncoder().encodeToString(sha256.digest());
	}

	// GOOD - Invoking a wrapper implementation through qualifier and argument with a salt.
	public String getWrapperSHA256Hash3(String password) throws NoSuchAlgorithmException {
		SHA256 sha256 = new SHA256();
		byte[] salt = getSalt();
		byte[] passBytes = password.getBytes();
		sha256.update(passBytes, 0, passBytes.length);
		update(sha256, salt, 0, salt.length);
		return Base64.getEncoder().encodeToString(sha256.digest());
	}

	// BAD - Invoking a wrapper implementation through argument without a salt.
	public String getWrapperSHA256Hash4(String password) throws NoSuchAlgorithmException {
		SHA256 sha256 = new SHA256();
		byte[] passBytes = password.getBytes();
		update(sha256, passBytes, 0, passBytes.length);
		return Base64.getEncoder().encodeToString(sha256.digest());
	}

	// GOOD - Invoking a wrapper implementation through argument with a salt.
	public String getWrapperSHA256Hash5(String password) throws NoSuchAlgorithmException {
		SHA256 sha256 = new SHA256();
		byte[] salt = getSalt();
		byte[] passBytes = password.getBytes();
		update(sha256, passBytes, 0, passBytes.length);
		update(sha256, salt, 0, salt.length);
		return Base64.getEncoder().encodeToString(sha256.digest());
	}

	// BAD - Invoke a wrapper implementation with a salt, which is not detected with an interface type variable.
	public String getSHA512Hash8(byte[] passphrase) throws NoSuchAlgorithmException, ClassNotFoundException, IllegalAccessException, InstantiationException {
		Class c = Class.forName("SHA512");
		HASH sha512 = (HASH) (c.newInstance());
		byte[] tmp = new byte[4];
		byte[] key = new byte[32 * 2];
		for (int i = 0; i < 2; i++) {
			sha512.init();
			tmp[3] = (byte) i;
			sha512.update(passphrase, 0, passphrase.length);
			System.arraycopy(sha512.digest(), 0, key, i * 32, 32);
		}
		return Base64.getEncoder().encodeToString(key);
	}

	public static byte[] getSalt() throws NoSuchAlgorithmException {
		SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
		byte[] salt = new byte[16];
		sr.nextBytes(salt);
		return salt;
	}
}
