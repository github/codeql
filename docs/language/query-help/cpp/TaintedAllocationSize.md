# Overflow in uncontrolled allocation size

```
ID: cpp/uncontrolled-allocation-size
Kind: path-problem
Severity: error
Precision: high
Tags: reliability security external/cwe/cwe-190

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-190/TaintedAllocationSize.ql)

This code calculates an allocation size by multiplying a user input by a `sizeof` expression. Since the user input has no apparent guard on its magnitude, this multiplication can overflow. When an integer multiply overflows in C, the result can wrap around and be much smaller than intended. A later attempt to put data into the allocated buffer can then overflow.


## Recommendation
Guard all integer parameters that come from an external user. Implement a guard with the expected range for the parameter and make sure that the input value meets both the minimum and maximum requirements for this range. If the input value fails this guard then reject the request before proceeding further. If the input value passes the guard then subsequent calculations should not overflow.


## Example

```c
int factor = atoi(getenv("BRANCHING_FACTOR"));

// GOOD: Prevent overflow by checking the input
if (factor < 0 || factor > 1000) {
    log("Factor out of range (%d)\n", factor);
    return -1;
}

// This line can allocate too little memory if factor
// is very large.
char **root_node = (char **) malloc(factor * sizeof(char *));

```
This code shows one way to guard that an input value is within the expected range. If `factor` fails the guard, then an error is returned, and the value is not used as an argument to the subsequent call to `malloc`. Without this guard, the allocated buffer might be too small to hold the data intended for it.


## References
* The CERT Oracle Secure Coding Standard for C: [INT04-C. Enforce limits on integer values originating from tainted sources](https://www.securecoding.cert.org/confluence/display/c/INT04-C.+Enforce+limits+on+integer+values+originating+from+tainted+sources).
* Common Weakness Enumeration: [CWE-190](https://cwe.mitre.org/data/definitions/190.html).