# Array offset used before range check

```
ID: cpp/offset-use-before-range-check
Kind: problem
Severity: warning
Precision: medium
Tags: reliability security external/cwe/cwe-120 external/cwe/cwe-125

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Best%20Practices/Likely%20Errors/OffsetUseBeforeRangeCheck.ql)

The program contains an and-expression where the array access is defined before the range check. Consequently the array is accessed without any bounds checking. The range check does not protect the program from segmentation faults caused by attempts to read beyond the end of a buffer.


## Recommendation
Update the and-expression so that the range check precedes the array offset. This will ensure that the bounds are checked before the array is accessed.


## Example
The `find` function can read past the end of the buffer pointed to by `str` if `start` is longer than or equal to the length of the buffer (or longer than `len`, depending on the contents of the buffer).


```c
int find(int start, char *str, char goal)
{
    int len = strlen(str);
    //Potential buffer overflow
    for (int i = start; str[i] != 0 && i < len; i++) { 
        if (str[i] == goal)
            return i; 
    }
    return -1;
}

int findRangeCheck(int start, char *str, char goal)
{
    int len = strlen(str);
    //Range check protects against buffer overflow
    for (int i = start; i < len && str[i] != 0 ; i++) {
        if (str[i] == goal)
            return i; 
    }
    return -1;
}




```
Update the and-expression so that the range check precedes the array offset (for example, the `findRangeCheck` function).


## References
* cplusplus.com: [ C++: array](http://www.cplusplus.com/reference/array/array/).
* Wikipedia: [ Bounds checking](http://en.wikipedia.org/wiki/Bounds_checking).
* Common Weakness Enumeration: [CWE-120](https://cwe.mitre.org/data/definitions/120.html).
* Common Weakness Enumeration: [CWE-125](https://cwe.mitre.org/data/definitions/125.html).