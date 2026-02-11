## Overview

An empty method may indicate that an implementation was intended to be provided but was accidentally omitted. When using the method, it will not be clear that it does not provide an implementation and with dynamic dispatch, resolving to a blank method may result in unexpected program behavior.

## Recommendation

If a method is intended to be left empty, do one of the following to indicate that it is intentionally empty: 
1. Mark it abstract in an abstract class
2. Place it in an interface (then it can be implicitly abstract)
3. Place a comment in that method that lets others know that the implementation was intentionally omitted
4. Add `UnsupportedOperationException` to the method (as in `java.util.Collection.add`).

## Example

```java
public class Test {
    public void f1() { // COMPLIANT
        // intentionally empty
    }

    public void f2() {} // NON_COMPLIANT

    public void f3(){ throw new UnsupportedOperationException(); } // COMPLIANT

    public abstract class TestInner {

        public abstract void f(); // COMPLIANT - intentionally empty
    }

}
```

## Implementation Notes

The rule excludes reporting methods that are annotated.

## References
- Java SE Documentation: [java.util.Collection.add](https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/util/Collection.html#add(E)).
- Wikipedia: [Template method pattern](https://en.wikipedia.org/wiki/Template_method_pattern).
- Common Weakness Enumeration: [CWE-1071](https://cwe.mitre.org/data/definitions/1071.html).
