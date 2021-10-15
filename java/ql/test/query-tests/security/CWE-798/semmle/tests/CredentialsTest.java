package test.cwe798.cwe.examples;

import java.sql.DriverManager;
import java.sql.SQLException;

public class CredentialsTest {
	private static final String p = "123456"; // hard-coded credential (flow source)

	public static void main(String[] args) throws SQLException {
		String url = "jdbc:mysql://localhost/test";
		String u = "admin"; // hard-coded credential (flow source)

		DriverManager.getConnection(url, u, p); // sensitive call (flow target)
		test(url, u, p);
	}

	public static void test(String url, String v, String q) throws SQLException {
		DriverManager.getConnection(url, v, q); // sensitive call (flow target)
	}
}
