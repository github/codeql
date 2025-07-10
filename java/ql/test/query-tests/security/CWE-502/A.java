import java.io.*;
import java.net.Socket;
import java.beans.XMLDecoder;
import com.thoughtworks.xstream.XStream;
import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.io.Input;
import org.yaml.snakeyaml.constructor.SafeConstructor;
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.Yaml;
import org.nibblesec.tools.SerialKiller;

public class A {
  public Object deserialize1(Socket sock) throws java.io.IOException, ClassNotFoundException {
    InputStream inputStream = sock.getInputStream();
    ObjectInputStream in = new ObjectInputStream(inputStream);
    return in.readObject(); // $unsafeDeserialization
  }

  public Object deserialize2(Socket sock) throws java.io.IOException, ClassNotFoundException {
    InputStream inputStream = sock.getInputStream();
    ObjectInputStream in = new ObjectInputStream(inputStream);
    return in.readUnshared(); // $unsafeDeserialization
  }

  public Object deserializeWithSerialKiller(Socket sock) throws java.io.IOException, ClassNotFoundException {
    InputStream inputStream = sock.getInputStream();
    ObjectInputStream in = new SerialKiller(inputStream, "/etc/serialkiller.conf");
    return in.readUnshared(); // OK
  }

  public Object deserialize3(Socket sock) throws java.io.IOException {
    InputStream inputStream = sock.getInputStream();
    XMLDecoder d = new XMLDecoder(inputStream);
    return d.readObject(); // $unsafeDeserialization
  }

  public Object deserialize4(Socket sock) throws java.io.IOException {
    XStream xs = new XStream();
    InputStream inputStream = sock.getInputStream();
    Reader reader = new InputStreamReader(inputStream);
    return xs.fromXML(reader); // $unsafeDeserialization
  }

  public void deserialize5(Socket sock) throws java.io.IOException {
    Kryo kryo = new Kryo();
    Input input = new Input(sock.getInputStream());
    A a1 = kryo.readObject(input, A.class); // $unsafeDeserialization
    A a2 = kryo.readObjectOrNull(input, A.class); // $unsafeDeserialization
    Object o = kryo.readClassAndObject(input); // $unsafeDeserialization
  }

  private Kryo getSafeKryo() throws java.io.IOException {
    Kryo kryo = new Kryo();
    kryo.setRegistrationRequired(true);
    // ... kryo.register(A.class) ...
    return kryo;
  }

  public void deserialize6(Socket sock) throws java.io.IOException {
    Kryo kryo = getSafeKryo();
    Input input = new Input(sock.getInputStream());
    Object o = kryo.readClassAndObject(input); // OK
  }

  public void deserializeSnakeYaml(Socket sock) throws java.io.IOException {
    Yaml yaml = new Yaml();
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); // $unsafeDeserialization
    Object o2 = yaml.loadAll(input); // $unsafeDeserialization
    Object o3 = yaml.parse(new InputStreamReader(input)); // $unsafeDeserialization
    A o4 = yaml.loadAs(input, A.class); // $unsafeDeserialization
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); // $unsafeDeserialization
  }

  public void deserializeSnakeYaml2(Socket sock) throws java.io.IOException {
    Yaml yaml = new Yaml(new Constructor());
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); // $unsafeDeserialization
    Object o2 = yaml.loadAll(input); // $unsafeDeserialization
    Object o3 = yaml.parse(new InputStreamReader(input)); // $unsafeDeserialization
    A o4 = yaml.loadAs(input, A.class); // $unsafeDeserialization
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); // $unsafeDeserialization
  }

  public void deserializeSnakeYaml3(Socket sock) throws java.io.IOException {
    Yaml yaml = new Yaml(new SafeConstructor());
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); //OK
    Object o2 = yaml.loadAll(input); //OK
    Object o3 = yaml.parse(new InputStreamReader(input)); //OK
    A o4 = yaml.loadAs(input, A.class); //OK
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); //OK
  }

  public void deserializeSnakeYaml4(Socket sock) throws java.io.IOException {
    Yaml yaml = new Yaml(new Constructor(A.class));
    InputStream input = sock.getInputStream();
    Object o = yaml.load(input); // $unsafeDeserialization
    Object o2 = yaml.loadAll(input); // $unsafeDeserialization
    Object o3 = yaml.parse(new InputStreamReader(input)); // $unsafeDeserialization
    A o4 = yaml.loadAs(input, A.class); // $unsafeDeserialization
    A o5 = yaml.loadAs(new InputStreamReader(input), A.class); // $unsafeDeserialization
  }
}
