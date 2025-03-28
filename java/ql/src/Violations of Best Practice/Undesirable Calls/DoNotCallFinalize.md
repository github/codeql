## Overview

Triggering garbage collection by directly calling `finalize()` may either have no effect or may trigger unnecessary garbage collection, leading to erratic behavior, performance issues, or deadlock.

## Recommendation

Avoid calling `finalize()` in application code. Allow the JVM to determine a garbage collection schedule instead.

## Example

```java
public class Test {
    void f() throws Throwable {
        this.finalize(); // NON_COMPLIANT
    }
}

```

# Implementation Notes

This rule is focused on the use of existing `finalize()` invocations rather than attempts to write a custom implementation.

## References

- SEI CERT Oracle Coding Standard for Java: [MET12-J. Do not use finalizers](https://wiki.sei.cmu.edu/confluence/display/java/MET12-J.+Do+not+use+finalizers).
- Java API Specification: [Object.finalize()](https://docs.oracle.com/javase/10/docs/api/java/lang/Object.html#finalize()).
- Common Weakness Enumeration: [CWE-586](https://cwe.mitre.org/data/definitions/586).
