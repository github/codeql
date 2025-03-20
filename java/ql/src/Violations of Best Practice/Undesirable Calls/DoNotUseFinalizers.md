# J-FIN-002: Calling garbage collection methods in application code may cause inconsistent program state

Calling garbage collection or finalizer methods in application code may cause inconsistent program state or unpredicatable behavior.

## Overview

Triggering garbage collection explicitly may either have no effect or may trigger unnecessary garbage collection, leading to erratic behavior or deadlock.

## Recommendation

Avoid calling finalizers and garbage collection methods in application code. Allow the JVM to determine a garbage collection schedule instead.

## Example

```java
public class Test {
    void f() throws Throwable {
        System.gc(); // NON_COMPLIANT
        Runtime.getRuntime().gc(); // NON_COMPLIANT
        System.runFinalizersOnExit(true); //NON_COMPLIANT
        this.finalize(); // NON_COMPLIANT
    }
}

```

# Implementation Notes

This rule covers a concept related to J-FIN-001; this rule is focused on the use of existing finalizer invocations rather than attempts to write a custom implementation (J-FIN-001).

## References

- [Do not use finalizers](https://wiki.sei.cmu.edu/confluence/display/java/MET12-J.+Do+not+use+finalizers)
- [CWE-586](https://cwe.mitre.org/data/definitions/586)
