## Overview

The `String#replaceAll` method is designed to work with regular expressions as its first parameter. When you use a simple string without any regex patterns (like special characters or syntax), it's more efficient to use `String#replace` instead. This is because `replaceAll` has to compile the input as a regular expression first, which adds unnecessary overhead when you are just replacing literal text.

## Recommendation

Use `String#replace` instead where a `replaceAll` call uses a trivial string as its first argument.

## Example

```java
public class Test {
    void f() {
        String s1 = "test";
        s1 = s1.replaceAll("t", "x"); // NON_COMPLIANT
        s1 = s1.replaceAll(".*", "x"); // COMPLIANT
        s1 = s1.replace("t", "x"); // COMPLIANT
    }
}

```

## References

- Java SE Documentation: [String.replaceAll](https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/lang/String.html#replaceAll(java.lang.String,java.lang.String)).
- Common Weakness Enumeration: [CWE-1176](https://cwe.mitre.org/data/definitions/1176.html).
