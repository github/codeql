import java.net.InetSocketAddress;
import java.net.Socket;
import javax.net.SocketFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import com.rabbitmq.client.ConnectionFactory;

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
		sslEngine.getSession(); // $hasUnsafeCertTrust
	}

	/**
	 * Test the endpoint identification of SSL engine is not set
	 */
	public void testSSLEngineEndpointIdNotSet() throws java.security.NoSuchAlgorithmException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		sslEngine.getSession(); // $hasUnsafeCertTrust
	}

	/**
	 * Test the endpoint identification of SSL engine is set to HTTPS
	 */
	public void testSSLEngineEndpointIdSafe() throws java.security.NoSuchAlgorithmException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS");
		sslEngine.setSSLParameters(sslParameters);
		sslEngine.getSession(); // Safe
	}

	/**
	 * Test the endpoint identification of SSL socket is not set
	 */
	public void testSSLSocketImmediatelyConnects()
			throws java.security.NoSuchAlgorithmException, java.io.IOException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket("www.example.com", 443); // $hasUnsafeCertTrust
	}

	/**
	 * Test the endpoint identification of SSL socket is not set
	 */
	public void testSSLSocketEndpointIdNotSet()
			throws java.security.NoSuchAlgorithmException, java.io.IOException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		socket.connect(new InetSocketAddress("www.example.com", 443)); // $hasUnsafeCertTrust
	}

	/**
	 * Test the endpoint identification of SSL socket is set to null
	 */
	public void testSSLSocketEndpointIdSetNull()
			throws java.security.NoSuchAlgorithmException, java.io.IOException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm(null);
		socket.setSSLParameters(sslParameters);
		socket.connect(new InetSocketAddress("www.example.com", 443)); // $hasUnsafeCertTrust
	}

	/**
	 * Test the endpoint identification of SSL socket is set to empty
	 */
	public void testSSLSocketEndpointIdSetEmpty()
			throws java.security.NoSuchAlgorithmException, java.io.IOException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("");
		socket.setSSLParameters(sslParameters);
		socket.connect(new InetSocketAddress("www.example.com", 443)); // $hasUnsafeCertTrust
	}

	/**
	 * Test the endpoint identification of SSL socket is not set
	 */
	public void testSSLSocketEndpointIdAfterConnecting()
			throws java.security.NoSuchAlgorithmException, java.io.IOException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket("www.example.com", 443); // $hasUnsafeCertTrust
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS");
		socket.setSSLParameters(sslParameters);
	}

	/**
	 * Test the endpoint identification of SSL socket is not set
	 */
	public void testSSLSocketEndpointIdSafe()
			throws java.security.NoSuchAlgorithmException, java.io.IOException {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS");
		socket.setSSLParameters(sslParameters);
		socket.connect(new InetSocketAddress("www.example.com", 443)); // Safe
	}

	/**
	 * Test the endpoint identification of regular socket is not set
	 */
	public void testSocketEndpointIdNotSet() throws java.io.IOException {
		SocketFactory socketFactory = SocketFactory.getDefault();
		Socket socket = socketFactory.createSocket("www.example.com", 80); // Safe
	}

	/**
	 * Test the enableHostnameVerification of RabbitMQConnectionFactory is not set
	 */
	public void testRabbitMQFactoryEnableHostnameVerificationNotSet() throws Exception {
		ConnectionFactory connectionFactory = new ConnectionFactory();
		connectionFactory.useSslProtocol(); // $hasUnsafeCertTrust
	}

	/**
	 * Test the enableHostnameVerification of RabbitMQConnectionFactory is not set
	 */
	public void testRabbitMQFactorySafe() throws Exception {
		ConnectionFactory connectionFactory = new ConnectionFactory();
		connectionFactory.useSslProtocol(); // Safe
		connectionFactory.enableHostnameVerification();
	}
}
