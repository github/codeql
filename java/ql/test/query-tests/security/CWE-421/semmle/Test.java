// Test case for CWE-421 (Race Condition During Access to Alternate Channel)
// http://cwe.mitre.org/data/definitions/421.html
package test.cwe807.semmle.tests;




import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;

class Test {
	byte[] secretData = "The password is: passw0rd".getBytes();

	// fake stub for testing
	public boolean isAuthenticated(String username) {
		return true;
	}

	// fake stub for testing
	public boolean doAuthenticate(Socket connection, String username) {
		return true;
	}

	// fake stub for testing
	public boolean doAuthenticate(SocketChannel connection, String username) {
		return true;
	}
	
	public void doConnect(int desiredPort, String username) throws Exception {
		ServerSocket listenSocket = new ServerSocket(desiredPort);

		if (isAuthenticated(username)) {
			Socket connection1 = listenSocket.accept();
			// BAD: no authentication over the socket
			connection1.getOutputStream().write(secretData);
		}

		Socket connection2 = listenSocket.accept();
		// GOOD: authentication happens over the socket
		if (doAuthenticate(connection2, username)) {
			connection2.getOutputStream().write(secretData);
		}

		if (isAuthenticated(username)) {
			// FP: we authenticate both beforehand and over the socket
			Socket connection3 = listenSocket.accept();
			if (doAuthenticate(connection3, username)) {
				connection3.getOutputStream().write(secretData);
			}
		}
		
	}

	public void doConnectChannel(int desiredPort, String username) throws Exception {
		ServerSocketChannel listenChannel = ServerSocketChannel.open();
		SocketAddress port = new InetSocketAddress(desiredPort);
		listenChannel.bind(port);

		if (isAuthenticated(username)) {
			SocketChannel connection1 = listenChannel.accept();
			// BAD: no authentication over the socket
			connection1.write(ByteBuffer.wrap(secretData));
		}

		SocketChannel connection2 = listenChannel.accept();
		// GOOD: authentication happens over the socket
		if (doAuthenticate(connection2, username)) {
			connection2.write(ByteBuffer.wrap(secretData));
		}
		
	}
}
