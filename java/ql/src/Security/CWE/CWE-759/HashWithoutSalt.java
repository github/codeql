public class HashWithoutSalt {
	// BAD - Hash without a salt.
	public byte[] getSHA256Hash(String password) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		return md.digest(password.getBytes());
	}

	// BETTER - Hash with a salt using SHA256.
	public byte[] getSHA256Hash(String password, byte[] salt) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(salt);
		return md.digest(password.getBytes());
	}

	// GOOD - Hash with a salt using PBKDF2.
	public byte[] getPBKDF2Hash(String password, byte[] salt) throws NoSuchAlgorithmException {
		KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 65536, 128);
		SecretKeyFactory f = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		return f.generateSecret(spec).getEncoded();
	}
}