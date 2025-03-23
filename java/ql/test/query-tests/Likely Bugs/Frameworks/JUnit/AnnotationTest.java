import java.util.Collection;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.RepeatedTest;
import org.junit.jupiter.api.TestFactory;
import org.junit.jupiter.api.TestTemplate;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

public class AnnotationTest {
  @Nested
  public class Test1 { // COMPLIANT: Inner test class has `@Nested`
    @Test
    public void test() {
    }
  }

  // NON_COMPLIANT: Inner test class is missing `@Nested`
  public class Test2_Test { // $ Alert
    @Test
    public void test() {
    }
  }

  // NON_COMPLIANT: Inner test class is missing `@Nested`
  public class Test2_RepeatedTest { // $ Alert
    @RepeatedTest(2)
    public void test() {
    }
  }

  // NON_COMPLIANT: Inner test class is missing `@Nested`
  public class Test2_ParameterizedTest { // $ Alert
    @ParameterizedTest
    @ValueSource(strings = { "" })
    public void test(String s) {
    }
  }

  // NON_COMPLIANT: Inner test class is missing `@Nested`
  public class Test2_TestFactory { // $ Alert
    @TestFactory
    Collection<Object> test() {
        return null;
    }
  }

  // NON_COMPLIANT: Inner test class is missing `@Nested`
  public class Test2_TestTemplate { // $ Alert
    @TestTemplate
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

  interface Test8 {
  }

  public void f() {
    // COMPLIANT: anonymous classes are not considered as inner test
    // classes by JUnit and therefore don't need `@Nested`
    new Test8() {
      @Test
      public void test() {
      }
    };
    // COMPLIANT: local classes are not considered as inner test
    // classes by JUnit and therefore don't need `@Nested`
    class Test9 {
      @Test
      void test() {
      }
    }
  }

  // COMPLIANT: private classes are not considered as inner test
  // classes by JUnit and therefore don't need `@Nested`
  private class Test10 {
    @Test
    public void test() {
    }
  }
}
