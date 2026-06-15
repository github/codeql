## Overview

Java allows to freely mix `case` labels and ordinary statement labels in the body of
a `switch` statement. However, this is confusing to read and may be the result of a typo.

## Recommendation

Examine the non-`case` labels to see whether they were meant to be `case` labels. If not, consider placing the non-`case` label headed code into a function, and use a function call inline in the `switch` body instead.

## Example

```java
public class Test {
    void test_noncase_label_in_switch(int p) {
        switch (p) {
            case 1: // Compliant
            case2:  // Non-compliant, likely a typo
            break;
            case 3:
                notcaselabel: // Non-compliant, confusing to read
                for (;;) {
                    break notcaselabel;
                }
        }
    }
}
```

In the example, `case2` is most likely a typo and should be fixed. For the intentional `notcaselabel`, placing the labelled code into a function and then calling that function is more readable.

## References

CodeQL query help for JavaScript and TypeScript - [Non-case label in switch statement](https://codeql.github.com/codeql-query-help/javascript/js-label-in-switch/).
