# J-T-003: Accessing any method, field or class annotated with `@VisibleForTesting` from production code is discouraged

Accessing class members annotated with `@VisibleForTesting` from production code goes against the intention of the annotation and may indicate programmer error.

## Overview

The `@VisibleForTesting` serves to increase visibility of methods, fields or classes for the purposes of testing. Accessing methods, fields or classes that are annotated with `@VisibleForTesting` in production code (not test code) abuses the intention of the annotation.

## Recommendation

Only access methods, fields or classes annotated with `@VisibleForTesting` from test code. If the visibility of the methods, fields or classes should generally be relaxed, use Java language access modifiers.

## Example

```java
public class Annotated {
@VisibleForTesting static int f(){}
}

/* src/test/java/Test.java */
int i = Annotated.f(); // COMPLIANT

/* src/main/Source.java */
 int i = Annotated.f(); // NON_COMPLIANT

```

## Implementation notes

This rule alerts on any implementation of the annotation `VisibleForTesting`, regardless of where it is provided from.

The rule also uses the following logic to determine what an abuse of the annotation is:

  1) If public or protected member/type is annotated with `VisibleForTesting`, it's assumed that package-private access is enough for production code. Therefore the rule alerts when a public or protected member/type annotated with `VisibleForTesting` is used outside of its declaring package.
  2) If package-private member/type is annotated with `VisibleForTesting`, it's assumed that private access is enough for production code. Therefore the rule alerts when a package-private member/type annotated with `VisibleForTesting` is used outside its declaring class.

## References
- Example Specific Implementation of a VisibleForTesting Annotation: [AssertJ VisibleForTesting](https://javadoc.io/doc/org.assertj/assertj-core/latest/org/assertj/core/util/VisibleForTesting.html)
- Assumptions of what level of access is permittable for each access modifier and the annotation: [JetBrains VisibleForTesting](https://javadoc.io/doc/org.jetbrains/annotations/22.0.0/org/jetbrains/annotations/VisibleForTesting.html)