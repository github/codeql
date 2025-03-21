# J-T-004: Non-static inner class defined in a JUnit 5 is missing a `@Nested` annotation

A non-static inner class defined in a JUnit 5 test missing a `@Nested` annotation will be excluded from execution and it may indicate a misunderstanding from the programmer.

## Overview

JUnit tests are grouped in a class, and starting from JUnit 5 users can group the test classes in a bigger class so they can share the local environment of the enclosing class. While this helps to organize the unit tests and foster code reuse, if the inner class is not annotated with `@Nested`, the unit tests in it will fail to execute during builds.

Note that static classes, whether static or not, behave as independent sets of unit tests. Thus, inner static classes do not share the information provided by the outer class with other inner classes. Thus, this rule only applies to non-static JUnit 5 inner classes.

## Recommendation

If you want the tests defined in an inner class to be recognized by the build plugin and be executed, annotate with `@Nested`, imported from `org.junit.jupiter.api`.

## Example

```java
import org.junit.jupiter.api.Nested;
import static org.junit.Assert.assertEquals;

public class IntegerOperationTest {
  private int i;                // Shared variable among the inner classes.

  @BeforeEach
  public void initTest() { i = 0; }

  @Nested
  public class AdditionTest {   // COMPLIANT: Inner test class annotated with `@Nested`.
    @Test
    public void addTest1() {    // Test of an inner class, implying `AdditionTest` is a test class.
      assertEquals(1, i+1);
    }
  }

  public class SubtractionTest { // NON_COMPLIANT: Inner test class missing `@Nested`.
    @Test
    public void addTest1() {     // Test of an inner class, implying `SubtractionTest` is a test class.
      assertEquals(-1, i-1);
    }
  }

  static public class MultiplicationTest {  // COMPLIANT: static test class should not be annotated as `@Nested`.
    ...
  }
}
```

## Implementation Notes

The `@Nested` annotation does not apply to inner static classes, since the meaning of the annotation is to mark a class as "a *non-static* inner class containing `@Test` methods to be picked up by a build system". It also does not apply to inner abstract classes since there is no use case for an `@Nested` annotation on an abstract class. Therefore, this rule does not aim to target static or abstract inner test classes with a `@Nested` annotation, nor does it try to enforce such correct usage of `@Nested`. Therefore, any code that resembles the below is not non-compliant to this rule.

``` java
@Nested
public static class TestStatic { // COMPLIANT: Although invalid, this matter is out of the scope
  @Test
  public void test() {
  }
}

@Nested
public abstract class TestAbstract { // COMPLIANT: Although invalid, this matter is out of the scope
  @Test
  public void test() {
  }
}
```

## References

- JUnit: [Documentation on `@Nested`](https://junit.org/junit5/docs/current/api/org.junit.jupiter.api/org/junit/jupiter/api/Nested.html).
- Baeldung: [JUnit 5 @Nested Test Classes](https://www.baeldung.com/junit-5-nested-test-classes).
