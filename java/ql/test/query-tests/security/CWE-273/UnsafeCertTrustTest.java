import java.net.Socket;
import java.nio.ByteBuffer;
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
	public void testSSLEngineEndpointIdSetNull() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm(null);
		sslEngine.setSSLParameters(sslParameters);
		sslEngine.beginHandshake(); // $hasUnsafeCertTrust
		sslEngine.wrap(new ByteBuffer[] {}, null); // $hasUnsafeCertTrust
		sslEngine.unwrap(null, null, 0, 0); // $hasUnsafeCertTrust
	}

	public void testSSLEngineEndpointIdSetEmpty() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("");
		sslEngine.setSSLParameters(sslParameters);
		sslEngine.beginHandshake(); // $hasUnsafeCertTrust
		sslEngine.wrap(new ByteBuffer[] {}, null); // $hasUnsafeCertTrust
		sslEngine.unwrap(null, null, 0, 0); // $hasUnsafeCertTrust
	}

	public void testSSLEngineEndpointIdSafe() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		SSLParameters sslParameters = sslEngine.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS");
		sslEngine.setSSLParameters(sslParameters);
		sslEngine.beginHandshake(); // Safe
		sslEngine.wrap(new ByteBuffer[] {}, null); // Safe
		sslEngine.unwrap(null, null, 0, 0); // Safe
	}

	public void testSSLEngineInServerMode() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLEngine sslEngine = sslContext.createSSLEngine();
		sslEngine.setUseClientMode(false);
		sslEngine.beginHandshake(); // Safe
		sslEngine.wrap(new ByteBuffer[] {}, null); // Safe
		sslEngine.unwrap(null, null, 0, 0); // Safe
	}

	public void testSSLSocketEndpointIdNotSet() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		socket.getOutputStream(); // $hasUnsafeCertTrust
	}

	public void testSSLSocketEndpointIdSetNull() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm(null);
		socket.setSSLParameters(sslParameters);
		socket.getOutputStream(); // $hasUnsafeCertTrust
	}

	public void testSSLSocketEndpointIdSetEmpty() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("");
		socket.setSSLParameters(sslParameters);
		socket.getOutputStream(); // $hasUnsafeCertTrust
	}

	public void testSSLSocketEndpointIdAfterConnecting() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		socket.getOutputStream(); // $hasUnsafeCertTrust
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS");
		socket.setSSLParameters(sslParameters);
	}

	public void testSSLSocketEndpointIdSafe() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		SSLParameters sslParameters = socket.getSSLParameters();
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS");
		socket.setSSLParameters(sslParameters);
		socket.getOutputStream(); // Safe
	}

	public void testSSLSocketEndpointIdSafeWithModificationByReference() throws Exception {
		SSLContext sslContext = SSLContext.getInstance("TLS");
		SSLSocketFactory socketFactory = sslContext.getSocketFactory();
		SSLSocket socket = (SSLSocket) socketFactory.createSocket();
		SSLParameters sslParameters = socket.getSSLParameters();
		onSetSSLParameters(sslParameters);
		socket.setSSLParameters(sslParameters);
		socket.getOutputStream(); // Safe
	}

	private void onSetSSLParameters(SSLParameters sslParameters) {
		sslParameters.setEndpointIdentificationAlgorithm("HTTPS");
	}

	public void testSocketEndpointIdNotSet() throws Exception {
		SocketFactory socketFactory = SocketFactory.getDefault();
		Socket socket = socketFactory.createSocket("www.example.com", 80);
		socket.getOutputStream(); // Safe
	}

	public void testRabbitMQFactoryEnableHostnameVerificationNotSet() throws Exception {
		ConnectionFactory connectionFactory = new ConnectionFactory();
		connectionFactory.useSslProtocol(); // $hasUnsafeCertTrust
	}

	public void testRabbitMQFactorySafe() throws Exception {
		ConnectionFactory connectionFactory = new ConnectionFactory();
		connectionFactory.useSslProtocol(); // Safe
		connectionFactory.enableHostnameVerification();
	}
}
