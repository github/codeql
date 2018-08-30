// Semmle test case for CWE-327: Use of a Broken or Risky Cryptographic Algorithm
// http://cwe.mitre.org/data/definitions/327.html
package test.cwe327.semmle.tests;

import javax.crypto.*;
import javax.crypto.spec.*;
import java.security.*;

class Test {
	public void test() {
		try {
			String input = "ABCDEFG123456";
			KeyGenerator keyGenerator;
			SecretKeySpec secretKeySpec;
			Cipher cipher;

			{
				// BAD: DES is a weak algorithm
				keyGenerator = KeyGenerator.getInstance("DES");
			}

			// GOOD: RSA is a strong algorithm
			// NB: in general the algorithms used in the various stages must be
			// the same, but for testing purposes we will vary them
			keyGenerator = KeyGenerator.getInstance("RSA");
			/* Perform initialization of KeyGenerator */
			keyGenerator.init(112);

			SecretKey secretKey = keyGenerator.generateKey();
			byte[] byteKey = secretKey.getEncoded();

			{
				// BAD: foo is an unknown algorithm that may not be secure
				secretKeySpec = new SecretKeySpec(byteKey, "foo");
			}

			// GOOD: GCM is a strong algorithm
			secretKeySpec = new SecretKeySpec(byteKey, "GCM");

			{
				// BAD: RC2 is a weak algorithm
				cipher = Cipher.getInstance("RC2");
			}
			// GOOD: ECIES is a strong algorithm
			cipher = Cipher.getInstance("ECIES");
			cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);

			byte[] encrypted = cipher.doFinal(input.getBytes("UTF-8"));
		} catch (Exception e) {
			// fail
		}
	}
}
