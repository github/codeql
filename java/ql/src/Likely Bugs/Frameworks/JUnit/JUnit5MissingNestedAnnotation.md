## Overview

JUnit tests are grouped in a class, and starting from JUnit 5 users can group the test classes in a bigger class so they can share the local environment of the enclosing class. While this helps to organize the unit tests and foster code reuse, if an inner test class is not annotated with `@Nested`, the unit tests in it will fail to execute during builds.

## Recommendation

If you want the tests defined in an inner class to be recognized by the build plugin and be executed, annotate the class with `@Nested`, imported from `org.junit.jupiter.api`.

## Example

```java
import org.junit.jupiter.api.Nested;
import static org.junit.Assert.assertEquals;

public class IntegerOperationTest {
  private int i;  // Shared variable among the inner classes.

  @BeforeEach
  public void initTest() { i = 0; }

  @Nested
  public class AdditionTest {  // COMPLIANT: Inner test class annotated with `@Nested`.
    @Test
    public void addTest1() {
      assertEquals(1, i + 1);
    }
  }

  public class SubtractionTest {  // NON_COMPLIANT: Inner test class missing `@Nested`.
    @Test
    public void addTest1() {
      assertEquals(-1, i - 1);
    }
  }
}
```

## Implementation Notes

This rule is focused on missing `@Nested` annotations on non-static nested (inner) test classes. Static nested test classes should not be annotated with `@Nested`. As a result, the absence of a `@Nested` annotation on such classes is compliant. Identifying incorrect application of a `@Nested` annotation to static nested classes is out of scope for this rule.

## References

- JUnit 5 API Documentation: [Annotation Interface Nested](https://junit.org/junit5/docs/current/api/org.junit.jupiter.api/org/junit/jupiter/api/Nested.html).
- JUnit 5 User Guide: [Nested Tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-nested).
