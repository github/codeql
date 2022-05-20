// Test case for CWE-089 (SQL injection)
// http://cwe.mitre.org/data/definitions/89.html
package test.cwe089.semmle.tests;

public class Validation {
	public static void checkIdentifier(String id) {
		for (int i = 0; i < id.length(); i++) {
			char c = id.charAt(i);
			if (!Character.isLetter(c)) {
				throw new RuntimeException("Invalid identifier: " + id);
			}
		}
	}
}
