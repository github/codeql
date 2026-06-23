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
    SSLContext.getInstance("SSL"); // $ Alert
    SSLContext.getInstance("SSLv2"); // $ Alert
    SSLContext.getInstance("SSLv3"); // $ Alert
    SSLContext.getInstance("TLS"); // $ Alert
    SSLContext.getInstance("TLSv1"); // $ Alert
    SSLContext.getInstance("TLSv1.1"); // $ Alert

    // safe
    SSLContext.getInstance("TLSv1.2");
    SSLContext.getInstance("TLSv1.3");
  }

  public static void testCreateSslParametersWithProtocol(String[] cipherSuites) {

    // unsafe
    createSslParameters(cipherSuites, "SSLv3"); // $ Source
    createSslParameters(cipherSuites, "TLS"); // $ Source
    createSslParameters(cipherSuites, "TLSv1"); // $ Source
    createSslParameters(cipherSuites, "TLSv1.1"); // $ Source
    createSslParameters(cipherSuites, "TLSv1", "TLSv1.1", "TLSv1.2"); // $ Source
    createSslParameters(cipherSuites, "TLSv1.2");

    // safe
    createSslParameters(cipherSuites, "TLSv1.2");
    createSslParameters(cipherSuites, "TLSv1.3");
  }

  public static SSLParameters createSslParameters(String[] cipherSuites, String... protocols) {
    return new SSLParameters(cipherSuites, protocols); // $ Alert
  }

  public static void testSettingProtocolsForSslParameters() {

    // unsafe
    new SSLParameters().setProtocols(new String[] { "SSLv3" }); // $ Alert
    new SSLParameters().setProtocols(new String[] { "TLS" }); // $ Alert
    new SSLParameters().setProtocols(new String[] { "TLSv1" }); // $ Alert
    new SSLParameters().setProtocols(new String[] { "TLSv1.1" }); // $ Alert

    SSLParameters parameters = new SSLParameters();
    parameters.setProtocols(new String[] { "TLSv1.1", "TLSv1.2" }); // $ Alert

    // safe
    new SSLParameters().setProtocols(new String[] { "TLSv1.2" });

    parameters = new SSLParameters();
    parameters.setProtocols(new String[] { "TLSv1.2", "TLSv1.3" });
  }

  public static void testSettingProtocolForSslSocket() throws IOException {

    // unsafe
    createSslSocket("SSLv3"); // $ Source
    createSslSocket("TLS"); // $ Source
    createSslSocket("TLSv1"); // $ Source
    createSslSocket("TLSv1.1"); // $ Source
    createSslSocket("TLSv1.1", "TLSv1.2"); // $ Source

    // safe
    createSslSocket("TLSv1.2");
    createSslSocket("TLSv1.3");
  }

  public static SSLSocket createSslSocket(String... protocols) throws IOException {
    SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket();
    socket.setEnabledProtocols(protocols); // $ Alert
    return socket;
  }

  public static void testSettingProtocolForSslServerSocket() throws IOException {

    // unsafe
    createSslServerSocket("SSLv3"); // $ Source
    createSslServerSocket("TLS"); // $ Source
    createSslServerSocket("TLSv1"); // $ Source
    createSslServerSocket("TLSv1.1"); // $ Source
    createSslServerSocket("TLSv1.1", "TLSv1.2"); // $ Source

    // safe
    createSslServerSocket("TLSv1.2");
    createSslServerSocket("TLSv1.3");
  }

  public static SSLServerSocket createSslServerSocket(String... protocols) throws IOException {
    SSLServerSocket socket = (SSLServerSocket) SSLServerSocketFactory.getDefault().createServerSocket();
    socket.setEnabledProtocols(protocols); // $ Alert
    return socket;
  }

  public static void testSettingProtocolForSslEngine() throws NoSuchAlgorithmException {

    // unsafe
    createSslEngine("SSLv3"); // $ Source
    createSslEngine("TLS"); // $ Source
    createSslEngine("TLSv1"); // $ Source
    createSslEngine("TLSv1.1"); // $ Source
    createSslEngine("TLSv1.1", "TLSv1.2"); // $ Source

    // safe
    createSslEngine("TLSv1.2");
    createSslEngine("TLSv1.3");
  }

  public static SSLEngine createSslEngine(String... protocols) throws NoSuchAlgorithmException {
    SSLEngine engine = SSLContext.getDefault().createSSLEngine();
    engine.setEnabledProtocols(protocols); // $ Alert
    return engine;
  }
}
