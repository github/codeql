import java.io.InputStreamReader;
import java.net.Socket;

import org.simpleframework.xml.core.Persister;
import org.simpleframework.xml.stream.DocumentProvider;
import org.simpleframework.xml.stream.NodeBuilder;
import org.simpleframework.xml.stream.StreamProvider;
import org.simpleframework.xml.stream.Formatter;

public class SimpleXMLTests {

  public void persisterValidate1(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), sock.getInputStream()); // $ Alert
  }

  public void persisterValidate2(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), sock.getInputStream(), true); // $ Alert
  }

  public void persisterValidate3(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), new InputStreamReader(sock.getInputStream())); // $ Alert
  }

  public void persisterValidate4(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    persister.validate(this.getClass(), new String(b)); // $ Alert
  }

  public void persisterValidate5(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    persister.validate(this.getClass(), new String(b), true); // $ Alert
  }

  public void persisterValidate6(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), new InputStreamReader(sock.getInputStream()), true); // $ Alert
  }

  public void persisterRead1(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), sock.getInputStream()); // $ Alert
  }

  public void persisterRead2(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), sock.getInputStream(), true); // $ Alert
  }

  public void persisterRead3(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, sock.getInputStream()); // $ Alert
  }

  public void persisterRead4(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, sock.getInputStream(), true); // $ Alert
  }

  public void persisterRead5(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), new InputStreamReader(sock.getInputStream())); // $ Alert
  }

  public void persisterRead6(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), new InputStreamReader(sock.getInputStream()), true); // $ Alert
  }

  public void persisterRead7(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, new InputStreamReader(sock.getInputStream())); // $ Alert
  }

  public void persisterRead8(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, new InputStreamReader(sock.getInputStream()), true); // $ Alert
  }

  public void persisterRead9(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    persister.read(this.getClass(), new String(b)); // $ Alert
  }

  public void persisterRead10(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    persister.read(this.getClass(), new String(b), true); // $ Alert
  }

  public void persisterRead11(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    persister.read(this, new String(b)); // $ Alert
  }

  public void persisterRead12(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    persister.read(this, new String(b), true); // $ Alert
  }

  public void nodeBuilderRead1(Socket sock) throws Exception {
    NodeBuilder.read(sock.getInputStream()); // $ Alert
  }

  public void nodeBuilderRead2(Socket sock) throws Exception {
    NodeBuilder.read(new InputStreamReader(sock.getInputStream())); // $ Alert
  }

  public void documentProviderProvide1(Socket sock) throws Exception {
    DocumentProvider provider = new DocumentProvider();
    provider.provide(sock.getInputStream()); // $ Alert
  }

  public void documentProviderProvide2(Socket sock) throws Exception {
    DocumentProvider provider = new DocumentProvider();
    provider.provide(new InputStreamReader(sock.getInputStream())); // $ Alert
  }

  public void streamProviderProvide1(Socket sock) throws Exception {
    StreamProvider provider = new StreamProvider();
    provider.provide(sock.getInputStream()); // $ Alert
  }

  public void streamProviderProvide2(Socket sock) throws Exception {
    StreamProvider provider = new StreamProvider();
    provider.provide(new InputStreamReader(sock.getInputStream())); // $ Alert
  }

  public void formatterFormat1(Socket sock) throws Exception {
    Formatter formatter = new Formatter();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    formatter.format(new String(b), null); // $ Alert
  }

  public void formatterFormat2(Socket sock) throws Exception {
    Formatter formatter = new Formatter();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b); // $ Source
    formatter.format(new String(b)); // $ Alert
  }
}
