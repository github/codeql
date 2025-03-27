## Overview

Calling `finalize()` in application code may cause inconsistent program state or unpredicatable behavior.

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

- Carnegie Mellon University, SEI CERT Oracle Coding Standard for Java: [MET12-J. Do not use finalizers](https://wiki.sei.cmu.edu/confluence/display/java/MET12-J.+Do+not+use+finalizers).
- Common Weakness Enumeration: [CWE-586](https://cwe.mitre.org/data/definitions/586).
