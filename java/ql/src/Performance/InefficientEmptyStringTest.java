// Inefficient version
class InefficientDBClient {
	public void connect(String user, String pw) {
		if (user.equals("") || "".equals(pw))
			throw new RuntimeException();
		...
	}
}

// More efficient version
class EfficientDBClient {
	public void connect(String user, String pw) {
		if (user.length() == 0 || (pw != null && pw.length() == 0))
			throw new RuntimeException();
		...
	}
}
