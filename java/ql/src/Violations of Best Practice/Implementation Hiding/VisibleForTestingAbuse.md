## Overview

Accessing class members annotated with `@VisibleForTesting` from production code goes against the intention of the annotation and may indicate programmer error.

The `@VisibleForTesting` annotation serves to increase visibility of methods, fields or classes for the purposes of testing. Accessing these annotated elements in production code (not test code) abuses the intention of the annotation.

## Recommendation

Only access methods, fields or classes annotated with `@VisibleForTesting` from test code. If the visibility of the methods, fields or classes should generally be relaxed, use Java language access modifiers.

## Example

```java
public class Annotated {
    @VisibleForTesting static int f() { return 42; }
}

/* src/test/java/Test.java */
int i = Annotated.f(); // COMPLIANT

/* src/main/Source.java */
int i = Annotated.f(); // NON_COMPLIANT
```

## Implementation notes

This rule alerts on any implementation of the annotation `VisibleForTesting`, regardless of where it is provided from.

The rule also uses the following logic to determine what an abuse of the annotation is:

  1. If a public or protected member/type is annotated with `@VisibleForTesting`, it's assumed that package-private access is enough for production code. Therefore the rule alerts when a public or protected member/type annotated with `@VisibleForTesting` is used outside of its declaring package.
  2. If a package-private member/type is annotated with `@VisibleForTesting`, it's assumed that private access is enough for production code. Therefore the rule alerts when a package-private member/type annotated with `@VisibleForTesting` is used outside its declaring class.

## References
- Javadoc: [AssertJ VisibleForTesting](https://javadoc.io/doc/org.assertj/assertj-core/latest/org.assertj.core/org/assertj/core/util/VisibleForTesting.html).
- Javadoc: [JetBrains VisibleForTesting](https://javadoc.io/doc/org.jetbrains/annotations/22.0.0/org/jetbrains/annotations/VisibleForTesting.html).
