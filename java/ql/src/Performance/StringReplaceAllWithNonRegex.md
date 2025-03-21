# J-STR-001: Use of `String.replaceAll` with a first argument of a non regular expression

Using `String.replaceAll` is less performant than `String.replace` when the first argument is not a regular expression.

## Overview

The underlying implementation of `String.replaceAll` uses `Pattern.compile` and expects a regular expression as its first argument. However in cases where the argument could be represented by just a plain `String` that does not represent an interesting regular expression, a call to `String.replace` may be more performant as it does not need to compile the regular expression.

## Recommendation

Use `String.replace` instead where a `replaceAll` call uses a trivial string as its first argument.

## Example

```java
public class Test {
    void f() {
        String s1 = "test";
        s1 = s1.replaceAll("t", "x"); // NON_COMPLIANT
        s1 = s1.replaceAll(".*", "x"); // COMPLIANT
    }
}

```

## References

- [String.replaceAll](https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/lang/String.html#replaceAll(java.lang.String,java.lang.String))
