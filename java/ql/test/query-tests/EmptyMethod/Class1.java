import org.aspectj.lang.annotation.Pointcut;

public class Class1 {

  // COMPLIANT
  public void f() {
    int i = 0;
  }

  // COMPLIANT
  public void f1() {
    // intentionally empty
  }

  // NON_COMPLIANT
  public void f2() { } // $ Alert

  // COMPLIANT - exception
  @Pointcut()
  public void f4() {
  }

  /**
   * COMPLIANT - empty method with javadoc
   */
  public void f5() {
  }

  public abstract class TestInner {

    public abstract void f(); // COMPLIANT - intentionally empty

  }

  public class Derived extends TestInner {

    // COMPLIANT: with annotation
    @Override
    public void f() {
    }

    // COMPLIANT: native
    public native int nativeMethod();
  }

  public interface TestInterface {

    // NON_COMPLIANT
    default void method() { } // $ Alert

    void method2(); // COMPLIANT
  }

}
