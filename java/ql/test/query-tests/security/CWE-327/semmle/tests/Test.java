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

			KeyPairGenerator keyPairGenerator;

			// GOOD: EC is a secure algorithm for key pair generation
			keyPairGenerator = KeyPairGenerator.getInstance("EC");

			// GOOD: ECDSA is a secure signature algorithm
			Signature ecdsaSig = Signature.getInstance("ECDSA");

			// GOOD: ECDH is a secure algorithm for key agreement
			KeyAgreement ecdhKa = KeyAgreement.getInstance("ECDH");

			// GOOD: EdDSA is a secure algorithm (Edwards-curve Digital Signature Algorithm)
			keyPairGenerator = KeyPairGenerator.getInstance("EdDSA");

			// GOOD: Ed25519 is a secure algorithm for key pair generation
			keyPairGenerator = KeyPairGenerator.getInstance("Ed25519");

			// GOOD: Ed448 is a secure algorithm for key pair generation
			keyPairGenerator = KeyPairGenerator.getInstance("Ed448");

			// GOOD: XDH is a secure algorithm for key agreement
			KeyAgreement xdhKa = KeyAgreement.getInstance("XDH");

			// GOOD: X25519 is a secure algorithm for key agreement
			KeyAgreement x25519Ka = KeyAgreement.getInstance("X25519");

			// GOOD: X448 is a secure algorithm for key agreement
			KeyAgreement x448Ka = KeyAgreement.getInstance("X448");

			// GOOD: SHA256withECDSA is a secure signature algorithm
			Signature sha256Ecdsa = Signature.getInstance("SHA256withECDSA");

			// GOOD: HMAC-based SecretKeySpec should not be flagged
			new SecretKeySpec(null, "HMACSHA1");
			new SecretKeySpec(null, "HMACSHA256");
			new SecretKeySpec(null, "HMACSHA384");
			new SecretKeySpec(null, "SHA384withECDSA");

			// GOOD: PBKDF2 key derivation is a secure algorithm
			SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");

		} catch (Exception e) {
			// fail
		}
	}
}
