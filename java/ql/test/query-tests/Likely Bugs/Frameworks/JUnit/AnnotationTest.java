import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Nested;

public class AnnotationTest {
  @Nested
  public class Test1 { // COMPLIANT: Inner test class has `@Nested`
    @Test
    public void test() {
    }
  }

  public class Test2 { // NON_COMPLIANT: Inner test class is missing a `@Nested`
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

  public static class Test5 { // COMPLIANT: Static inner test classes don't need `@Nested`
    @Test
    public void test() {
    }
  }

  @Nested
  public static class Test6 { // COMPLIANT: Although invalid, this matter is out of the scope (see Implementation Details)
    @Test
    public void test() {
    }
  }
}
