package test.cwe798.cwe.examples;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.DriverManager;
import java.sql.SQLException;

public class FileCredentialTest {
	public static void main(String[] args) throws SQLException, IOException {
		String url = "jdbc:mysql://localhost/test";
		String u = "admin";
		String file = "/test/p.config";

		String p = readText(new File(file));

		DriverManager.getConnection("", "admin", p); // sensitive call (flow target)
		test(url, u, p);
	}

	public static void test(String url, String v, String q) throws SQLException {
		DriverManager.getConnection(url, v, q); // sensitive call (flow target)
	}

	public static String readText(File f) throws IOException
	{
		StringBuilder buf = new StringBuilder();
		try (FileInputStream fis = new FileInputStream(f); // opening file input stream (flow source)
				InputStreamReader reader = new InputStreamReader(fis, "UTF8");) {
			int n;
			while ((n = reader.read()) != -1) {
				buf.append((char)n);
			}
		}
		return buf.toString();
	}

}
