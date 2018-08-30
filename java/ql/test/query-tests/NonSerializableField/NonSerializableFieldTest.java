import java.io.Serializable;
import java.io.Externalizable;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.ObjectOutput;
import java.io.ObjectInput;

public class NonSerializableFieldTest {

  public static class NS{}
  public static class S implements Serializable{}
  public static class E implements Externalizable{
    public void readExternal(ObjectInput oi){}
    public void writeExternal(ObjectOutput oo){}
  }

  public static class MySerializable<T> implements Serializable{}
  public static class SerializableBase implements Serializable{}
  public static class MyColl extends HashMap<Integer, Integer>{} 

  public static class NotSerializable1<T> extends SerializableBase{
    NS problematic1;
    List<NS> problematic2;
    Map<?, NS> problematic3;
    Map<NS, ?> problematic4;
    Map<Integer, Map<?, NS>> problematic5;
    Map problematic6;
    List<? extends NS> problematic7;
    List<? super NS> problematic8;
    T problematic9;
    List<T> problematic10;
    List<?> problematic11;
    Map<?, ?> problematic12;
    Map<Integer, Map<?, Double>> problematic13;
    Map<Integer, ?> problematic14;

    transient NS ok1;
    List<Integer> ok2;
    static NS ok3;
    S ok4;
    E ok5;
    MySerializable<Integer> ok6;
    MySerializable<?> ok7;
    MySerializable<T> ok8;
    MyColl ok9;
  }

  public static class NotSerializable2<T> extends SerializableBase{
    NS ok1;

    // the presence of those two methods is usually enough proof that the implementor
    // deals with the problems (e.g. by throwing NotSerializableException)
    private void readObject(ObjectInputStream oos){}
    private void writeObject(ObjectOutputStream oos){}
 }

  // annotations usually signal that the implementor is aware of potential problems
  @SuppressWarnings("serial")
  public static class NotSerializable3<T> extends SerializableBase{
    NS ok1;
    List<NS> ok2;
  }
  
  // We don't report Externalizable classes, since they completely take over control during
  // serialization. Furthermore, Externalizable has priority over Serializable!
  public static class ExternalizableSerializable implements Serializable, Externalizable {
    NS ok1;
    public void readExternal(ObjectInput in){ }
    public void writeExternal(ObjectOutput out){ }
  }

  public static interface Anonymous extends Serializable{}

  public static void main(String[] args){
    Anonymous a1 = new Anonymous(){
      NS problematic;
    };

    @SuppressWarnings("serial")
    Anonymous a2 = new Anonymous(){
      NS ok;
    };
  }

  @SuppressWarnings("serial")
  public static void someAnnotatedMethod(){
    Anonymous a = new Anonymous(){
      NS ok;
    };
  }

  // dummy implementations to avoid javax.ejb imports in tests
  @interface Stateless {}
  @interface Stateful {}
  class SessionBean implements Serializable {}

  class NonSerializableClass {}

  @Stateless
  class StatelessSessionEjb extends SessionBean {
    NonSerializableClass nonSerializableField;
  }

  @Stateful
  class StatefulSessionEjb extends SessionBean {
    NonSerializableClass nonSerializableField;
  }
  
  enum Enum {
	  A(null);
	  
	  private NonSerializableClass nonSerializable;
	  
	  Enum(NonSerializableClass nonSerializable) {
		  this.nonSerializable = nonSerializable;
	  }
  }
}
