import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import java.net.Socket;
import javax.net.SocketFactory;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

//import com.rabbitmq.client.ConnectionFactory;

public class UnsafeCertificateTrust {

	/**
	 * Test the implementation of trusting all server certs as a variable
	 */
	public SSLSocketFactory testTrustAllCertManager() {
		try {
			final SSLContext context = SSLContext.getInstance("TLS");
			context.init(null, new TrustManager[] { TRUST_ALL_CERTIFICATES }, null);
			final SSLSocketFactory socketFactory = context.getSocketFactory();
			return socketFactory;
		} catch (final Exception x) {
			throw new RuntimeException(x);
		}
	}

	/**
	 * Test the implementation of trusting all server certs as an anonymous class
	 */
	public SSLSocketFactory testTrustAllCertManagerOfVariable() {
		try {
			SSLContext context = SSLContext.getInstance("TLS");
			TrustManager[] serverTMs = new TrustManager[] { new X509TrustAllManager() };
			context.init(null, serverTMs, null);

			final SSLSocketFactory socketFactory = context.getSocketFactory();
			return socketFactory;
		} catch (final Exception x) {
			throw new RuntimeException(x);
		}
	}

	private static final X509TrustManager TRUST_ALL_CERTIFICATES = new X509TrustManager() {
		@Override
		public void checkClientTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
		}

		@Override
		public void checkServerTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
			// Noncompliant
		}

		@Override
		public X509Certificate[] getAcceptedIssuers() {
			return null; // Noncompliant
		}
	};

	private class X509TrustAllManager implements X509TrustManager {
		@Override
		public void checkClientTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
		}

		@Override
		public void checkServerTrusted(final X509Certificate[] chain, final String authType)
				throws CertificateException {
			// Noncompliant
		}

		@Override
		public X509Certificate[] getAcceptedIssuers() {
			return null; // Noncompliant
		}
	};

}