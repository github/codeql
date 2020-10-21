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

public class UnsafeHostnameVerification {

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
	 * Test the implementation of trusting all hostnames as a lambda.
	 */
	public void testTrustAllHostnameLambda() {
		HttpsURLConnection.setDefaultHostnameVerifier((name, s) -> true);
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