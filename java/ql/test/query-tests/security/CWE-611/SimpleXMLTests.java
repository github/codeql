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
    persister.validate(this.getClass(), sock.getInputStream());
  }
  
  public void persisterValidate2(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), sock.getInputStream(), true);
  }

  public void persisterValidate3(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), new InputStreamReader(sock.getInputStream()));
  }

  public void persisterValidate4(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    persister.validate(this.getClass(), new String(b));
  }

  public void persisterValidate5(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    persister.validate(this.getClass(), new String(b), true);
  }

  public void persisterValidate6(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.validate(this.getClass(), new InputStreamReader(sock.getInputStream()), true);
  }

  public void persisterRead1(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), sock.getInputStream());
  }
  
  public void persisterRead2(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), sock.getInputStream(), true);
  }
  
  public void persisterRead3(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, sock.getInputStream());
  }
  
  public void persisterRead4(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, sock.getInputStream(), true);
  }
  
  public void persisterRead5(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), new InputStreamReader(sock.getInputStream()));
  }

  public void persisterRead6(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this.getClass(), new InputStreamReader(sock.getInputStream()), true);
  }

  public void persisterRead7(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, new InputStreamReader(sock.getInputStream()));
  }

  public void persisterRead8(Socket sock) throws Exception {
    Persister persister = new Persister();
    persister.read(this, new InputStreamReader(sock.getInputStream()), true);
  }
  
  public void persisterRead9(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    persister.read(this.getClass(), new String(b));
  }
  
  public void persisterRead10(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    persister.read(this.getClass(), new String(b), true);
  }
  
  public void persisterRead11(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    persister.read(this, new String(b));
  }
  
  public void persisterRead12(Socket sock) throws Exception {
    Persister persister = new Persister();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    persister.read(this, new String(b), true);
  }
  
  public void nodeBuilderRead1(Socket sock) throws Exception {
    NodeBuilder.read(sock.getInputStream());
  }
  
  public void nodeBuilderRead2(Socket sock) throws Exception {
    NodeBuilder.read(new InputStreamReader(sock.getInputStream()));
  }
  
  public void documentProviderProvide1(Socket sock) throws Exception {
    DocumentProvider provider = new DocumentProvider();
    provider.provide(sock.getInputStream());
  }
  
  public void documentProviderProvide2(Socket sock) throws Exception {
    DocumentProvider provider = new DocumentProvider();
    provider.provide(new InputStreamReader(sock.getInputStream()));
  }

  public void streamProviderProvide1(Socket sock) throws Exception {
    StreamProvider provider = new StreamProvider();
    provider.provide(sock.getInputStream());
  }

  public void streamProviderProvide2(Socket sock) throws Exception {
    StreamProvider provider = new StreamProvider();
    provider.provide(new InputStreamReader(sock.getInputStream()));
  }

  public void formatterFormat1(Socket sock) throws Exception {
    Formatter formatter = new Formatter();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    formatter.format(new String(b), null);
  }
  
  public void formatterFormat2(Socket sock) throws Exception {
    Formatter formatter = new Formatter();
    byte[] b = new byte[]{};
    sock.getInputStream().read(b);
    formatter.format(new String(b));
  }
}
