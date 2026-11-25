package security.library.encryption;

import java.util.Arrays;
import java.util.List;
import java.security.MessageDigest;

class Test {
	List<String> badStrings = Arrays.asList(
			"DES",
			"des",
			"des_function",
			"function_using_des",
			"EncryptWithDES",
			"DESede",
			"DESedeWrap",
			"DESedeRFC3211Wrap",
			"DESEDERFC3211WRAP",
			"desederfc3211wrap",
			"PBEWithSHA1AndDESedE",
			"PBEWITHSHA1ANDDESEDE",
			"pbewithsha1anddesede",
			"TripleDES",
			"3DES",
			"SKIPJACK",
			"Skipjack",
			"RC2",
			"RC4",
			"ARCFOUR",
			"RC5",
			"AES/ECB/NoPadding",
			"AES/CBC/PKCS5Padding");

	List<String> goodStrings = Arrays.asList(
			"AES",
			"AES_function",
			"ChaCha20",
			"ChaCha20-Poly1305",
			"ChaCha20Poly1305",
			// false negative - can't think of a good way to detect this without
			// catching things we shouldn't
			"AESEncryption");

	List<String> unknownStrings = Arrays.asList(
			// not a use of RC2 (camelCase is tricky)
			"GetPrc2",
			// uppercase PBE name without delimiter before RC2 (covered by potentially-weak query)
			"PBEWITHSHA1ANDRC2_40",
			// not a use of DES
			"Description",
			// not a use of DES
			"DESTROY",
			// not a use of ECIES
			"species",
			// can't detect unknown algorithms
			"SOMENEWACRONYM");
        public static abstract class SomeDigest extends MessageDigest {
		public SomeDigest() {
			super("some");
		}
	}
	public void test() throws Exception {
		MessageDigest.getInstance("another");
	}
}
