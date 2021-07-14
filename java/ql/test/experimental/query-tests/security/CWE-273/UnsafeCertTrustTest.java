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
	 * Test the endpoint identification of SSL engine is set to null
	 */
	public void testSSLEngineEndpointIdSetNull() throws java.security.NoSuchAlgorithmException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm(null);
		sslEngine.setSSLParameters(sslParameters);
	}

	/**
	 * Test the endpoint identification of SSL engine is not set
	 */
	public void testSSLEngineEndpointIdNotSet() throws java.security.NoSuchAlgorithmException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
	}

	/**
	 * Test the endpoint identification of SSL socket is not set
	 */
	public void testSSLSocketEndpointIdNotSet() throws java.security.NoSuchAlgorithmException, java.io.IOException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		final SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket("www.example.com", 443);
	}

	/**
	 * Test the endpoint identification of regular socket is not set
	 */
	public void testSocketEndpointIdNotSet() throws java.io.IOException {
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
