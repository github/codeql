import java.util.*;

public class NonPrivateFieldTest {

  public @interface Rule {}              // JUnit-like annotation

  public static class Fields{
    public static String problematic1 = "value";
    public final int problematic2 = 0;
    public final int problematic3;

    final int problematic4 = 9;          // omitted access descriptor
    static int problematic5 = 0;         
    public int problematic6 = 0;
    protected Double problematic7 = 0.0; // protected but not used in derived classes
    static int[] problematic8;

    public static final int ok1 = 0;     // public static finals are usually fine, even if not accessed by anything from outside
    public static int ok2 = 0;           // foreign write access
    protected int ok3 = 1;               // read access by sub class

    @Rule public int ok4;                // annotated public members are often accessed via reflection (e.g. JUnit's Rule Annotation) 

    public Fields(){
      problematic3 = 0;
    }

    public void someAccessorMethod(){
      problematic5 = 8;                  // field access within declaring class does not count as foreign access
    }
  }

  public static class Accessor1 extends Fields{
    public Accessor1(){
      Fields.ok2 = ok3;                  // read and write access outside of declaring class
    }
  }

  public static interface IFace{
    int ok4 = 0;                         // interface fields are implicitly public final static
  }

  public static enum E{
    OK5;                                 // enum constants are implicitly public static final
  }

}
