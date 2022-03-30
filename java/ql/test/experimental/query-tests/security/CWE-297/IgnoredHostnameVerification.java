import java.io.IOException;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLException;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

public class IgnoredHostnameVerification {

  // BAD: ignored result of HostnameVerifier.verify()
  public static SSLSocket connectWithIgnoredHostnameVerification(
      String host, int port, HostnameVerifier verifier) throws IOException {

    SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(host, port);
    socket.startHandshake();
    verifier.verify(host, socket.getSession());
    return socket;
  }

  public static void check(boolean result) throws SSLException {
    if (!result) {
      throw new SSLException("Oops! Hostname verification failed!");
    }
  }

  // GOOD: connect and check result of HostnameVerifier.verify()
  public static SSLSocket connectWithHostnameVerification00(
      String host, int port, HostnameVerifier verifier) throws IOException {

    SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(host, port);
    socket.startHandshake();
    check(verifier.verify(host, socket.getSession()));
    return socket;
  }

  // GOOD: connect and check result of HostnameVerifier.verify()
  public static SSLSocket connectWithHostnameVerification01(
      String host, int port, HostnameVerifier verifier) throws IOException {

    SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(host, port);
    socket.startHandshake();
    boolean successful = verifier.verify(host, socket.getSession());
    if (successful == false) {
      socket.close();
      throw new SSLException("Oops! Hostname verification failed!");
    }

    return socket;
  }

  // GOOD: connect and check result of HostnameVerifier.verify()
  public static SSLSocket connectWithHostnameVerification02(
      String host, int port, HostnameVerifier verifier) throws IOException {

    SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(host, port);
    socket.startHandshake();
    boolean successful = false;
    if (verifier != null) {
      successful = verifier.verify(host, socket.getSession());
    }
    if (!successful) {
      socket.close();
      throw new SSLException("Oops! Hostname verification failed!");
    }

    return socket;
  }

  // GOOD: connect and check result of HostnameVerifier.verify()
  public static SSLSocket connectWithHostnameVerification03(
      String host, int port, HostnameVerifier verifier) throws IOException {

    SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(host, port);
    socket.startHandshake();
    boolean successful = verifier.verify(host, socket.getSession());
    if (successful) {
      return socket;
    }

    socket.close();
    throw new SSLException("Oops! Hostname verification failed!");
  }

  // GOOD: connect and check result of HostnameVerifier.verify()
  public static String connectWithHostnameVerification04(
      String[] hosts, HostnameVerifier verifier, SSLSession session) throws IOException {

    for (String host : hosts) {
      if (verifier.verify(host, session)) {
        return host;
      }
    }

    throw new SSLException("Oops! Hostname verification failed!");
  }

  public static class HostnameVerifierWrapper implements HostnameVerifier {

    private final HostnameVerifier verifier;

    public HostnameVerifierWrapper(HostnameVerifier verifier) {
      this.verifier = verifier;
    }

    @Override
    public boolean verify(String hostname, SSLSession session) {
      return verifier.verify(hostname, session); // GOOD: wrapped calls should not be reported
    }

  }

}