## Overview

Triggering garbage collection by directly calling `finalize()` may either have no effect or trigger unnecessary garbage collection, leading to erratic behavior, performance issues, or deadlock.

## Recommendation

Avoid calling `finalize()` in application code. Allow the JVM to determine a garbage collection schedule instead. If you need to explicitly release resources, provide a specific method to do so, such as by implementing the `AutoCloseable` interface and overriding its `close` method. You can then use a `try-with-resources` block to ensure that the resource is closed.

## Example

### Incorrect Usage

```java
class LocalCache {
    private Collection<File> cacheFiles = ...;
    // ...
}

void main() {
    LocalCache cache = new LocalCache();
    // ...
    cache.finalize(); // NON_COMPLIANT
}
```

### Correct Usage

```java
import java.lang.AutoCloseable;
import java.lang.Override;

class LocalCache implements AutoCloseable {
    private Collection<File> cacheFiles = ...;
    // ...

    @Override
    public void close() throws Exception {
        // release resources here if required
    }
}

void main() {
    // COMPLIANT: uses try-with-resources to ensure that
    // a resource implementing AutoCloseable is closed.
    try (LocalCache cache = new LocalCache()) {
        // ...
    }
}
```

## Implementation Notes

This rule ignores `super.finalize()` calls that occur within `finalize()` overrides since calling the superclass finalizer is required when overriding `finalize()`. Also, although overriding `finalize()` is not recommended, this rule only alerts on direct calls to `finalize()` and does not alert on method declarations overriding `finalize()`.

## References

- SEI CERT Oracle Coding Standard for Java: [MET12-J. Do not use finalizers](https://wiki.sei.cmu.edu/confluence/display/java/MET12-J.+Do+not+use+finalizers).
- Java API Specification: [Object.finalize()](https://docs.oracle.com/javase/10/docs/api/java/lang/Object.html#finalize()).
- Java API Specification: [Interface AutoCloseable](https://docs.oracle.com/javase/10/docs/api/java/lang/AutoCloseable.html).
- Java SE Documentation: [The try-with-resources Statement](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html).
- Common Weakness Enumeration: [CWE-586](https://cwe.mitre.org/data/definitions/586).
