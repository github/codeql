class User {
	private static final String DEFAULT_PW = "123456"; // hard-coded password
	private String pw;
	public User() {
		setPassword(DEFAULT_PW); // sensitive call
	}
	public void setPassword(String password) {
		pw = password;
	}
}