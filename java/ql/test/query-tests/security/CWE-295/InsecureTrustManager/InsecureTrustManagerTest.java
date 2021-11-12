import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

public class InsecureTrustManagerTest {

	private static final boolean TRUST_ALL = true;
	private static final boolean SOME_NAME_THAT_IS_NOT_A_FLAG_NAME = true;

	private static boolean isDisableTrust() {
		return true;
	}

	private static boolean is42TheAnswerForEverything() {
		return true;
	}

	private static class InsecureTrustManager implements X509TrustManager {
		@Override
		public X509Certificate[] getAcceptedIssuers() {
			return null;
		}

		@Override
		public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
			// BAD: Does not verify the certificate chain, allowing any certificate.
		}

		@Override
		public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {

		}
	}

	public static void main(String[] args) throws Exception {
		directInsecureTrustManagerCall();

		namedVariableFlagDirectInsecureTrustManagerCall();
		noNamedVariableFlagDirectInsecureTrustManagerCall();
		namedVariableFlagIndirectInsecureTrustManagerCall();
		noNamedVariableFlagIndirectInsecureTrustManagerCall();

		stringLiteralFlagDirectInsecureTrustManagerCall();
		noStringLiteralFlagDirectInsecureTrustManagerCall();
		stringLiteralFlagIndirectInsecureTrustManagerCall();
		noStringLiteralFlagIndirectInsecureTrustManagerCall();

		methodAccessFlagDirectInsecureTrustManagerCall();
		noMethodAccessFlagDirectInsecureTrustManagerCall();
		methodAccessFlagIndirectInsecureTrustManagerCall();
		noMethodAccessFlagIndirectInsecureTrustManagerCall();

		isEqualsIgnoreCaseDirectInsecureTrustManagerCall();
		noIsEqualsIgnoreCaseDirectInsecureTrustManagerCall();
		isEqualsIgnoreCaseIndirectInsecureTrustManagerCall();
		noIsEqualsIgnoreCaseIndirectInsecureTrustManagerCall();

		namedVariableFlagNOTGuardingDirectInsecureTrustManagerCall();
		noNamedVariableFlagNOTGuardingDirectInsecureTrustManagerCall();

		stringLiteralFlagNOTGuardingDirectInsecureTrustManagerCall();
		noStringLiteralFlagNOTGuardingDirectInsecureTrustManagerCall();

		methodAccessFlagNOTGuardingDirectInsecureTrustManagerCall();
		noMethodAccessFlagNOTGuardingDirectInsecureTrustManagerCall();

		isEqualsIgnoreCaseNOTGuardingDirectInsecureTrustManagerCall();
		noIsEqualsIgnoreCaseNOTGuardingDirectInsecureTrustManagerCall();

		directSecureTrustManagerCall();

	}

	private static void directSecureTrustManagerCall() throws NoSuchAlgorithmException, KeyStoreException, IOException,
			CertificateException, FileNotFoundException, KeyManagementException, MalformedURLException {
		SSLContext context = SSLContext.getInstance("TLS");
		File certificateFile = new File("path/to/self-signed-certificate");
		// Create a `KeyStore` with default type
		KeyStore keyStore = KeyStore.getInstance(KeyStore.getDefaultType());
		// This causes `keyStore` to be empty
		keyStore.load(null, null);
		X509Certificate generatedCertificate;
		try (InputStream cert = new FileInputStream(certificateFile)) {
			generatedCertificate = (X509Certificate) CertificateFactory.getInstance("X509").generateCertificate(cert);
		}
		// Add the self-signed certificate to the key store
		keyStore.setCertificateEntry(certificateFile.getName(), generatedCertificate);
		// Get default `TrustManagerFactory`
		TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
		// Use it with our modified key store that trusts our self-signed certificate
		tmf.init(keyStore);
		TrustManager[] trustManagers = tmf.getTrustManagers();
		context.init(null, trustManagers, null); // GOOD, we are not using a custom `TrustManager` but instead have
													// added the self-signed certificate we want to trust to the key
													// store. Note, the `trustManagers` will **only** trust this one
													// certificate.
		URL url = new URL("https://self-signed.badssl.com/");
		HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
		conn.setSSLSocketFactory(context.getSocketFactory());
	}

	private static void directInsecureTrustManagerCall() throws NoSuchAlgorithmException, KeyManagementException {
		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
												// chain, allowing any certificate.
	}

	private static void namedVariableFlagDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (TRUST_ALL) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // GOOD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. BUT it is guarded
			// by a feature flag.
		}
	}

	private static void namedVariableFlagIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (TRUST_ALL) {
			disableTrustManager(); // GOOD [But the disableTrustManager method itself is still detected]: Calls a
			// method that install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. BUT it is guarded
			// by a feature flag.
		}
	}

	private static void noNamedVariableFlagDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (SOME_NAME_THAT_IS_NOT_A_FLAG_NAME) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void noNamedVariableFlagIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (SOME_NAME_THAT_IS_NOT_A_FLAG_NAME) {
			disableTrustManager(); // BAD [This is detected in the disableTrustManager method]: Calls a method that
									// install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void stringLiteralFlagDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (Boolean.parseBoolean(System.getProperty("TRUST_ALL"))) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // GOOD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. BUT it is guarded
			// by a feature flag.
		}
	}

	private static void stringLiteralFlagIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (Boolean.parseBoolean(System.getProperty("TRUST_ALL"))) {
			disableTrustManager(); // GOOD [But the disableTrustManager method itself is still detected]: Calls a
			// method that install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. BUT it is guarded
			// by a feature flag.
		}
	}

	private static void noStringLiteralFlagDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (Boolean.parseBoolean(System.getProperty("SOME_NAME_THAT_IS_NOT_A_FLAG_NAME"))) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void noStringLiteralFlagIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (Boolean.parseBoolean(System.getProperty("SOME_NAME_THAT_IS_NOT_A_FLAG_NAME"))) {
			disableTrustManager(); // BAD [This is detected in the disableTrustManager method]: Calls a method that
			// install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void methodAccessFlagDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (isDisableTrust()) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // GOOD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. BUT it is guarded
			// by a feature flag.
		}
	}

	private static void methodAccessFlagIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (isDisableTrust()) {
			disableTrustManager(); // GOOD [But the disableTrustManager method itself is still detected]: Calls a
			// method that install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. BUT it is guarded
			// by a feature flag.
		}
	}

	private static void noMethodAccessFlagDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (is42TheAnswerForEverything()) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void noMethodAccessFlagIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (is42TheAnswerForEverything()) {
			disableTrustManager(); // BAD [This is detected in the disableTrustManager method]: Calls a method that
			// install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void isEqualsIgnoreCaseDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		String schemaFromHttpRequest = "HTTPS";
		if (schemaFromHttpRequest.equalsIgnoreCase("https")) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void isEqualsIgnoreCaseIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		String schemaFromHttpRequest = "HTTPS";
		if (schemaFromHttpRequest.equalsIgnoreCase("https")) {
			disableTrustManager(); // BAD [This is detected in the disableTrustManager method]: Calls a method that
			// install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void noIsEqualsIgnoreCaseDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		String schemaFromHttpRequest = "HTTPS";
		if (!schemaFromHttpRequest.equalsIgnoreCase("https")) {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
			context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void noIsEqualsIgnoreCaseIndirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		String schemaFromHttpRequest = "HTTPS";
		if (!schemaFromHttpRequest.equalsIgnoreCase("https")) {
			disableTrustManager(); // BAD [This is detected in the disableTrustManager method]: Calls a method that
			// install a `TrustManager` that does not verify the certificate
			// chain, allowing any certificate. It is NOT guarded
			// by a feature flag.
		}
	}

	private static void namedVariableFlagNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (TRUST_ALL) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if.

	}

	private static void noNamedVariableFlagNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (SOME_NAME_THAT_IS_NOT_A_FLAG_NAME) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if and it is NOT a valid flag.

	}

	private static void stringLiteralFlagNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (Boolean.parseBoolean(System.getProperty("TRUST_ALL"))) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if.

	}

	private static void noStringLiteralFlagNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (Boolean.parseBoolean(System.getProperty("SOME_NAME_THAT_IS_NOT_A_FLAG_NAME"))) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if and it is NOT a valid flag.

	}

	private static void methodAccessFlagNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (isDisableTrust()) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if.

	}

	private static void noMethodAccessFlagNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		if (is42TheAnswerForEverything()) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if and it is NOT a valid flag.

	}

	private static void isEqualsIgnoreCaseNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		String schemaFromHttpRequest = "HTTPS";
		if (schemaFromHttpRequest.equalsIgnoreCase("https")) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if and it is NOT a valid flag.

	}

	private static void noIsEqualsIgnoreCaseNOTGuardingDirectInsecureTrustManagerCall()
			throws NoSuchAlgorithmException, KeyManagementException {
		String schemaFromHttpRequest = "HTTPS";
		if (!schemaFromHttpRequest.equalsIgnoreCase("https")) {
			System.out.println("Disabling trust!");
		}

		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the certificate
		// chain, allowing any certificate. It is NOT guarded
		// by a feature flag, because it is outside the if and it is NOT a valid flag.

	}

	private static void disableTrustManager() throws NoSuchAlgorithmException, KeyManagementException {
		SSLContext context = SSLContext.getInstance("TLS");
		TrustManager[] trustManager = new TrustManager[] { new InsecureTrustManager() };
		context.init(null, trustManager, null); // BAD: Uses a `TrustManager` that does not verify the
												// certificate
		// chain, allowing any certificate. The method name suggests that this may be
		// intentional, but we flag it anyway.
	}
}