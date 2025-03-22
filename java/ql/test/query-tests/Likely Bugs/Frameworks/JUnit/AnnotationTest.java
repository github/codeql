import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

public class AnnotationTest {
  @Nested
  public class Test1 { // COMPLIANT: Inner test class has `@Nested`
    @Test
    public void test() {
    }
  }

  // NON_COMPLIANT: Inner test class is missing `@Nested`
  public class Test2 {  // $ Alert
    @Test
    public void test() {
    }
  }

  public class Test3 { // COMPLIANT: Since it is empty, it is not a test class
  }

  public class Test4 { // COMPLIANT: Since no methods have `@Test`, it is not a test class
    public void f() {
    }

    public void g() {
    }

    public void h() {
    }
  }

  public static class Test5 { // COMPLIANT: Static nested test classes don't need `@Nested`
    @Test
    public void test() {
    }
  }

  // COMPLIANT: Invalid to use `@Nested` on a static class, but
  // this matter is out of scope (see QHelp Implementation Notes)
  @Nested
  public static class Test6 {
    @Test
    public void test() {
    }
  }

  public abstract class Test7 { // COMPLIANT: Abstract nested test classes don't need `@Nested`
    @Test
    public void test() {
    }
  }

  // COMPLIANT: Invalid to use `@Nested` on an abstract class, but
  // this matter is out of scope (see QHelp Implementation Notes)
  @Nested
  public abstract class Test8 {
    @Test
    public void test() {
    }
  }
}
