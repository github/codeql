# Call to alloca in a loop

```
ID: cpp/alloca-in-loop
Kind: problem
Severity: warning
Precision: high
Tags: reliability correctness security external/cwe/cwe-770

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Memory%20Management/AllocaInLoop.ql)

The `alloca` macro allocates memory by expanding the current stack frame. Invoking `alloca` within a loop may lead to a stack overflow because the memory is not released until the function returns.


## Recommendation
Consider invoking `alloca` once outside the loop, or using `malloc` or `new` to allocate memory on the heap if the allocation must be done inside the loop.


## Example
The variable `path` is allocated inside a loop with `alloca`. Consequently, storage for all copies of the path is present in the stack frame until the end of the function.


```cpp
char *dir_path;
char **dir_entries;
int count;

for (int i = 0; i < count; i++) {
  char *path = (char*)alloca(strlen(dir_path) + strlen(dir_entry[i]) + 2);
  // use path
}

```
In the revised example, `path` is allocated with `malloc` and freed at the end of the loop.


```cpp
char *dir_path;
char **dir_entries;
int count;

for (int i = 0; i < count; i++) {
  char *path = (char*)malloc(strlen(dir_path) + strlen(dir_entry[i]) + 2);
  // use path
  free(path);
}

```

## References
* Linux Programmer's Manual: [ALLOCA(3)](http://man7.org/linux/man-pages/man3/alloca.3.html).
* Common Weakness Enumeration: [CWE-770](https://cwe.mitre.org/data/definitions/770.html).