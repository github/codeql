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
    persister.validate(this.getClass(), sock.getInputStream()); // $ hasTaintFlow
  }

  public void persisterValidate2(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), sock.getInputStream(), true); // $ hasTaintFlow
  }

  public void persisterValidate3(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), new InputStreamReader(sock.getInputStream())); // $ hasTaintFlow
  }

  public void persisterValidate4(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    persister.validate(this.getClass(), new String(b)); // $ hasTaintFlow
  }

  public void persisterValidate5(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    persister.validate(this.getClass(), new String(b), true); // $ hasTaintFlow
  }

  public void persisterValidate6(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), new InputStreamReader(sock.getInputStream()), true); // $ hasTaintFlow
  }

  public void persisterRead1(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), sock.getInputStream()); // $ hasTaintFlow
  }

  public void persisterRead2(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), sock.getInputStream(), true); // $ hasTaintFlow
  }

  public void persisterRead3(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, sock.getInputStream()); // $ hasTaintFlow
  }

  public void persisterRead4(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, sock.getInputStream(), true); // $ hasTaintFlow
  }

  public void persisterRead5(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), new InputStreamReader(sock.getInputStream())); // $ hasTaintFlow
  }

  public void persisterRead6(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), new InputStreamReader(sock.getInputStream()), true); // $ hasTaintFlow
  }

  public void persisterRead7(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, new InputStreamReader(sock.getInputStream())); // $ hasTaintFlow
  }

  public void persisterRead8(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, new InputStreamReader(sock.getInputStream()), true); // $ hasTaintFlow
  }

  public void persisterRead9(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    persister.read(this.getClass(), new String(b)); // $ hasTaintFlow
  }

  public void persisterRead10(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    persister.read(this.getClass(), new String(b), true); // $ hasTaintFlow
  }

  public void persisterRead11(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    persister.read(this, new String(b)); // $ hasTaintFlow
  }

  public void persisterRead12(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    persister.read(this, new String(b), true); // $ hasTaintFlow
  }

  public void nodeBuilderRead1(Socket sock) throws Exception {
    NodeBuilder.read(sock.getInputStream()); // $ hasTaintFlow
  }

  public void nodeBuilderRead2(Socket sock) throws Exception {
    NodeBuilder.read(new InputStreamReader(sock.getInputStream())); // $ hasTaintFlow
  }

  public void documentProviderProvide1(Socket sock) throws Exception {
    DocumentProvider provider = new DocumentProvider();
    provider.provide(sock.getInputStream()); // $ hasTaintFlow
  }

  public void documentProviderProvide2(Socket sock) throws Exception {
    DocumentProvider provider = new DocumentProvider();
    provider.provide(new InputStreamReader(sock.getInputStream())); // $ hasTaintFlow
  }

  public void streamProviderProvide1(Socket sock) throws Exception {
    StreamProvider provider = new StreamProvider();
    provider.provide(sock.getInputStream()); // $ hasTaintFlow
  }

  public void streamProviderProvide2(Socket sock) throws Exception {
    StreamProvider provider = new StreamProvider();
    provider.provide(new InputStreamReader(sock.getInputStream())); // $ hasTaintFlow
  }

  public void formatterFormat1(Socket sock) throws Exception {
    Formatter formatter = new Formatter();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    formatter.format(new String(b), null); // $ hasTaintFlow
  }

  public void formatterFormat2(Socket sock) throws Exception {
    Formatter formatter = new Formatter();
    byte[] b = new byte[] {};
    sock.getInputStream().read(b);
    formatter.format(new String(b)); // $ hasTaintFlow
  }
}
