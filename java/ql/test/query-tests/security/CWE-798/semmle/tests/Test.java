package test.cwe798.cwe.examples;

import java.sql.DriverManager;
import java.sql.SQLException;

public class Test {
	public static void main(String[] args) throws SQLException {
		String url = "jdbc:mysql://localhost/test";
		String usr = "admin"; // hard-coded user name (flow source)
		String pass = "123456"; // hard-coded password (flow source)

		test(url, usr, pass); // flow through method

		DriverManager.getConnection(url, "admin", "123456"); // $ HardcodedCredentialsApiCall
		DriverManager.getConnection(url, usr, pass); // $ HardcodedCredentialsApiCall

		new java.net.PasswordAuthentication(usr, "123456".toCharArray()); // $ HardcodedCredentialsApiCall
		new java.net.PasswordAuthentication(usr, pass.toCharArray()); // $ HardcodedCredentialsApiCall

		byte[] key = {1, 2, 3, 4, 5, 6, 7, 8}; // hard-coded cryptographic key, flowing into API call below
		javax.crypto.spec.SecretKeySpec spec = new javax.crypto.spec.SecretKeySpec(key, "AES"); // $ HardcodedCredentialsApiCall

		byte[] key2 = "abcdefgh".getBytes(); // hard-coded cryptographic key, flowing into API call below
		javax.crypto.spec.SecretKeySpec spec2 = new javax.crypto.spec.SecretKeySpec(key2, "AES"); // $ HardcodedCredentialsApiCall

		passwordCheck(pass); // $ HardcodedCredentialsSourceCall
	}

	public static void test(String url, String user, String password) throws SQLException {
		DriverManager.getConnection(url, user, password); // $ HardcodedCredentialsApiCall
	}

	public static final String password = "myOtherPassword"; // $ HardcodedPasswordField

	public static boolean passwordCheck(String password) {
		return password.equals("admin"); // $ HardcodedCredentialsComparison
	}
}
