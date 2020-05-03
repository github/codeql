import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLParameters;
import javax.net.ssl.SSLServerSocket;
import javax.net.ssl.SSLServerSocketFactory;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

public class UnsafeTlsVersion {

  public static void testSslContextWithProtocol() throws NoSuchAlgorithmException {

    // unsafe
    SSLContext.getInstance("SSL");
    SSLContext.getInstance("SSLv2");
    SSLContext.getInstance("SSLv3");
    SSLContext.getInstance("TLS");
    SSLContext.getInstance("TLSv1");
    SSLContext.getInstance("TLSv1.1");

    // safe
    SSLContext.getInstance("TLSv1.2");
    SSLContext.getInstance("TLSv1.3");
  }

  public static void testCreateSslParametersWithProtocol(String[] cipherSuites) {

    // unsafe
    createSslParameters(cipherSuites, "SSLv3");
    createSslParameters(cipherSuites, "TLS");
    createSslParameters(cipherSuites, "TLSv1");
    createSslParameters(cipherSuites, "TLSv1.1");
    createSslParameters(cipherSuites, "TLSv1", "TLSv1.1", "TLSv1.2");
    createSslParameters(cipherSuites, "TLSv1.2");

    // safe
    createSslParameters(cipherSuites, "TLSv1.2");
    createSslParameters(cipherSuites, "TLSv1.3");
  }

  public static SSLParameters createSslParameters(String[] cipherSuites, String... protocols) {
    return new SSLParameters(cipherSuites, protocols);
  }

  public static void testSettingProtocolsForSslParameters() {

    // unsafe
    new SSLParameters().setProtocols(new String[] { "SSLv3" });
    new SSLParameters().setProtocols(new String[] { "TLS" });
    new SSLParameters().setProtocols(new String[] { "TLSv1" });
    new SSLParameters().setProtocols(new String[] { "TLSv1.1" });

    SSLParameters parameters = new SSLParameters();
    parameters.setProtocols(new String[] { "TLSv1.1", "TLSv1.2" });

    // safe
    new SSLParameters().setProtocols(new String[] { "TLSv1.2" });

    parameters = new SSLParameters();
    parameters.setProtocols(new String[] { "TLSv1.2", "TLSv1.3" });
  }

  public static void testSettingProtocolForSslSocket() throws IOException {

    // unsafe
    createSslSocket("SSLv3");
    createSslSocket("TLS");
    createSslSocket("TLSv1");
    createSslSocket("TLSv1.1");
    createSslSocket("TLSv1.1", "TLSv1.2");

    // safe
    createSslSocket("TLSv1.2");
    createSslSocket("TLSv1.3");
  }

  public static SSLSocket createSslSocket(String... protocols) throws IOException {
    SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket();
    socket.setEnabledProtocols(protocols);
    return socket;
  }

  public static void testSettingProtocolForSslServerSocket() throws IOException {

    // unsafe
    createSslServerSocket("SSLv3");
    createSslServerSocket("TLS");
    createSslServerSocket("TLSv1");
    createSslServerSocket("TLSv1.1");
    createSslServerSocket("TLSv1.1", "TLSv1.2");

    // safe
    createSslServerSocket("TLSv1.2");
    createSslServerSocket("TLSv1.3");
  }

  public static SSLServerSocket createSslServerSocket(String... protocols) throws IOException {
    SSLServerSocket socket = (SSLServerSocket) SSLServerSocketFactory.getDefault().createServerSocket();
    socket.setEnabledProtocols(protocols);
    return socket;
  }

  public static void testSettingProtocolForSslEngine() throws NoSuchAlgorithmException {

    // unsafe
    createSslEngine("SSLv3");
    createSslEngine("TLS");
    createSslEngine("TLSv1");
    createSslEngine("TLSv1.1");
    createSslEngine("TLSv1.1", "TLSv1.2");

    // safe
    createSslEngine("TLSv1.2");
    createSslEngine("TLSv1.3");
  }

  public static SSLEngine createSslEngine(String... protocols) throws NoSuchAlgorithmException {
    SSLEngine engine = SSLContext.getDefault().createSSLEngine();
    engine.setEnabledProtocols(protocols);
    return engine;
  }
}
