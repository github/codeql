public class HashWithoutSalt {
	// BAD - Hash without a salt.
	public void getSHA256Hash(String password) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		byte[] messageDigest = md.digest(password.getBytes());
	}

	// GOOD - Hash with a salt.
	public void getSHA256Hash(String password, byte[] salt) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(salt);
		byte[] messageDigest = md.digest(password.getBytes());
	}
}