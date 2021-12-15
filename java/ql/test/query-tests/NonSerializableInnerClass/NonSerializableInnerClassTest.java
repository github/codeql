import java.io.Serializable;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.ObjectOutput;
import java.io.ObjectInput;

public class NonSerializableInnerClassTest {

  public static class S implements Serializable{}
  public int field;

  public static class Outer1{

    public class Problematic1 implements Serializable{ }

    public class Problematic2 extends S{ }


    @SuppressWarnings("serial")
    public class Ok1 implements Serializable{ }

    public class Ok2 extends S{
      private void readObject(ObjectInputStream oos){}
      private void writeObject(ObjectOutputStream oos){}
    }

    public class Ok3 extends S{
      private void writeObject(ObjectOutputStream oos){}
    }

    public static class Ok4 extends S{ }

    public class Ok5 { }

    // in static contexts enclosing instances don't exist!
    static{
      Serializable ok6 = new Serializable(){ };
    }

    public static Serializable ok7 = new Serializable(){ };

    public static void staticMethod(){
      Serializable ok8 = new Serializable(){ };
    }
  }

  public static class Outer2 extends S {
    public class Ok9 implements Serializable{ }   
  }

  public class Problematic3 extends S {
    public class Problematic4 implements Serializable{ }   // because NonSerializableInnerClassTest is not serializable
  }

  // we currently ignore anonymous classes
  public void instanceMethod(){
    Serializable ok_ish1 = new Serializable(){
      public void test(){
        Serializable ok_ish2 = new Serializable(){
          public void test(){
            field = 5;
          }
        };
      }
    };
  }

  // the class is not used anywhere, but the serialVersionUID field is an indicator for later serialization
  private class Problematic7 implements Serializable{
    public static final long serialVersionUID = 123;
  }

  // the class is not used anywhere
  private class Ok10 implements Serializable{ }

  // instantiations of this class are only assigned to non-serializable variables
  private class Ok11 implements Serializable{ }

  public void test(){
    Object o = new Ok11();
    System.out.println(new Ok11());
  }
}
