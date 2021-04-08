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

public class UnsafeCertTrustTest {

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

	/**
	 * Test the implementation of trusting all hostnames as an anonymous class
	 */
	public void testTrustAllHostnameOfAnonymousClass() {
		HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
			@Override
			public boolean verify(String hostname, SSLSession session) {
				return true; // Noncompliant
			}
		});
	}

	/**
	 * Test the implementation of trusting all hostnames as a variable
	 */
	public void testTrustAllHostnameOfVariable() {
		HostnameVerifier verifier = new HostnameVerifier() {
			@Override
			public boolean verify(String hostname, SSLSession session) {
				return true; // Noncompliant
			}
		};
		HttpsURLConnection.setDefaultHostnameVerifier(verifier);
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

	public static final HostnameVerifier ALLOW_ALL_HOSTNAME_VERIFIER = new HostnameVerifier() {
		@Override
		public boolean verify(String hostname, SSLSession session) {
			return true; // Noncompliant
		}
	};

	/**
	 * Test the endpoint identification of SSL engine is set to null
	 */
	public void testSSLEngineEndpointIdSetNull() {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm(null);
		sslEngine.setSSLParameters(sslParameters);
	}

	/**
	 * Test the endpoint identification of SSL engine is not set
	 */
	public void testSSLEngineEndpointIdNotSet() {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
	}

	/**
	 * Test the endpoint identification of SSL socket is not set
	 */
	public void testSSLSocketEndpointIdNotSet() {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		final SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket("www.example.com", 443);
	}

	/**
	 * Test the endpoint identification of regular socket is not set
	 */
	public void testSocketEndpointIdNotSet() {
		SocketFactory socketFactory = SocketFactory.getDefault();
		Socket socket = socketFactory.createSocket("www.example.com", 80);
	}

	// /**
	// * Test the enableHostnameVerification of RabbitMQConnectionFactory is not set
	// */
	// public void testEnableHostnameVerificationOfRabbitMQFactoryNotSet() {
	// ConnectionFactory connectionFactory = new ConnectionFactory();
	// connectionFactory.useSslProtocol();
	// }
}