# Loop with unreachable exit condition

```
ID: java/unreachable-exit-in-loop
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-835

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-835/InfiniteLoop.ql)

Loops can contain multiple exit conditions, either directly in the loop condition or as guards around `break` or `return` statements. If an exit condition cannot be satisfied, then the code is misleading at best, and the loop might not terminate.


## Recommendation
When writing a loop that is intended to terminate, make sure that all the necessary exit conditions can be satisfied and that loop termination is clear.


## Example
The following example shows a potentially infinite loop, since the inner loop condition is constantly true. Of course, the loop may or may not be infinite depending on the behavior of `shouldBreak`, but if this was intended as the only exit condition the loop should be rewritten to make this clear.


```java
for (int i=0; i<10; i++) {
    for (int j=0; i<10; j++) {
        // do stuff
        if (shouldBreak()) break;
    }
}

```
To fix the loop the condition is corrected to check the right variable.


```java
for (int i=0; i<10; i++) {
    for (int j=0; j<10; j++) {
        // do stuff
        if (shouldBreak()) break;
    }
}

```

## References
* Java Language Specification: [Blocks and Statements](http://docs.oracle.com/javase/specs/jls/se8/html/jls-14.html).
* Common Weakness Enumeration: [CWE-835](https://cwe.mitre.org/data/definitions/835.html).