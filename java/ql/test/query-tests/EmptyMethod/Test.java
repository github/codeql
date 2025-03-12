import org.aspectj.lang.annotation.Pointcut;

public class Test {

  public void f() {
    int i = 0;
  }

  public void f1() {
    // intentionally empty
  }

  public void f2() { } // $ Alert

  @Pointcut()
  public void f4() {
  }

  public abstract class TestInner {

    public abstract void f();
  }

  public class Derived extends TestInner {

    @Override
    public void f() {
    }

    public native int nativeMethod();
  }

  public interface TestInterface {

    default void method() { } // $ Alert
  }

}
