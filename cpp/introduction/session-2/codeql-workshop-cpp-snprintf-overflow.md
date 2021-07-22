# CodeQL workshop for C/C++: snprintf overflow

- Analyzed language: C/C++
- Difficulty level: 2/3

## Problem statement

In this workshop, we will use CodeQL to analyze the source code of [rsyslog](https://www.rsyslog.com/), an open-source log processing system.

Formatting functions allow the programmer to construct a string output using a format string and an optional set of arguments. In C/C++ there are many formatting function variants with different APIs, and, in particular, differences in what is returned from the call. For example:

 - `printf`: Returns number of characters printed.
  ```c
  printf("Hello %s!", name)
  ```
 - `sprintf`: Returns number of characters written to buf.
  ```c
  sprintf(buf, "Hello %s!", name)
  ```
 - `snprintf`: Returns number of characters that would have written to `buf` had `n` been sufficiently large, not the number of characters actually written.
  ```c
  snprintf(buf, n, "Hello %s!", name)
  ```
 - In pre-C99 versions of glibc `snprintf` would return `-1` if `n` was too small!

The differences in API can cause confusion for programmers. Consider this example:

```c
char buf[1024];
int pos = 0;
for (int i = 0; i < n; i++) {
  pos += snprintf(buf + pos, sizeof(buf) - pos, "%s", strs[i]);
}
```
This piece of code is intended to write every element in the `strs` array into the `1024` byte `buf` buffer. The way it does this is by looping over each item in the `strs` array, and calling `snprintf` with a format specifier of `%s` to write intto the buffer. A `pos` variable stores the current position in the buffer - i.e. where to write the next element from the `strs` array. As such, `buf + pos` is passed as the first argument to `snprintf` (which is a pointer to the place to write to). The second argument to `snprintf` is a size argument, that is intended to prevent overwriting the end of the buffer. As such, it has been set to `sizeof(buf) - pos`, which is intended to be the remaining bytes in the array. Finally, the return value of `snprintf` is added to `pos` with the intention of incrementing `pos` by the size of the `strs` element we have just written.

Where can this go wrong?

<details>
<summary>Answer</summary>

The problem here is that `snprintf` doesn't return the actual number of bytes written, it instead returns the number of bytes that _would have been written_, if the buffer were large enough.

Consider a situation where we've started to fill up the array, and `pos=1022` and `i=20`. Say the next entry in the `strs` array is 5 bytes, then our `snprintf` call is equivalent to:
```c
snprintf(buf + 1022, 2, "%s", strs[20]);
```
However, because `strs[20]` is 5 bytes, and the max length parameter is set to `2`, the `snprintf` call will only write the first 2 bytes of the `strs[20]` value to the buffer. Unfortunately for us, it will still return `5` from the `snprintf` call, because it is returning the number of bytes that would have been written. This sets `pos` to `1027`, i.e. beyond the bounds of the buffer.

Now, on the next iteration, the `snprintf` call is equivalent to:
```c
snprintf(buf + 1027, -3, "%s", strs[21]);
```
And we will be writing beyond the end of the buffer. Not even the max length argument can save us here, because it is actually declared as type `size_t`, which is an unsigned integer. The negative number will therefore be implicitly converted to an unsigned integer like so:
```c
snprintf(buf + 1027, SIZE_MAX-3, "%s", strs[21]);
```
i.e. the max length will be set to a very large value, and will not prevent us writing over the bounds of the buffer.
</details>

If you follow the workshop all the way to the end, then you will find a real security vulnerability based on this pattern in an old version of rsyslog.

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on rsylog offline, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download the [rsyslog database](https://downloads.lgtm.com/snapshots/cpp/rsyslog/rsyslog/rsyslog-all-revision-2018-April-27--14-12-31.zip).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `snprintfoverflow.ql`, save it under `codeql-custom-queries-cpp`.

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for C/C++](https://help.semmle.com/QL/learn-ql/cpp/ql-for-cpp.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)

## Workshop
The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describe useful classes and predicates in the CodeQL standard libraries for C/C++. You can explore these in your IDE using the autocomplete suggestions and jump-to-definition command.

1. Write a query to find calls to `snprintf` using the `FunctionCall` class.
    <details>
    <summary>Hint</summary>

     - Use predicate `FunctionCall.getTarget()` to get the "target" of the call.
     - Use predicate `Function.getName()` to get the name of the function.
     - You can chain predicates together i.e. `call.getTarget().getName()`.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    import cpp
    
    from FunctionCall snprintfCall
    where snprintfCall.getTarget().getName() = "snprintf"
    select snprintfCall
    ```
    </details>

1. Restrict to calls whose result is used.
    <details>
    <summary>Hint</summary>

     - Use class `ExprInVoidContext`.
     - Remember you can use `instanceof` to check whether a value is contained within a type.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    from FunctionCall snprintfCall
    where
      snprintfCall.getTarget().getName() = "snprintf" and
      not snprintfCall instanceof ExprInVoidContext
    select snprintfCall
    ```
    </details>

1. Restrict to calls where the format string contains `"%s"`.
    <details>
    <summary>Hint</summary>

     - Use predicate `FunctionCall.getArgument(int i)` to get a function call argument at a particular position.
     - Use `Expr.getValue()` to get the `string` value for an expression, if it is a constant.
     - Use `string.regexpMatch()` to match a CodeQL string using a regular expression
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    import cpp

    from FunctionCall snprintfCall
    where
      snprintfCall.getTarget().getName() = "snprintf" and
      snprintfCall.getArgument(2).getValue().regexpMatch("(?s).*%s.*") and
      snprintfCall instanceof ExprInVoidContext
    select snprintfCall
    ```
    </details>

1. Restrict to calls where the result flows back to the size argument
    <details>
    <summary>Hint</summary>

     - Import library `semmle.code.cpp.dataflow.TaintTracking` and use predicate `TaintTracking::localTaint`.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    import cpp
    import semmle.code.cpp.dataflow.TaintTracking

    from FunctionCall snprintfCall, DataFlow::Node source, DataFlow::Node sink
    where
      snprintfCall.getTarget().getName() = "snprintf" and
      snprintfCall.getArgument(2).getValue().regexpMatch("(?s).*%s.*") and
      TaintTracking::localTaint(source, sink) and
      source.asExpr() = snprintfCall and
      sink.asExpr() = snprintfCall.getArgument(1)
    select snprintfCall
    ```
    </details>

You should now have exactly one result, which was a [genuine remote code execution security bug](https://securitylab.github.com/research/librelp-buffer-overflow-cve-2018-1000140) in rsyslog, and was disclosed as CVE-2018-1000140 and subsequently fixed.

You can find a more full-featured version of the query here: https://lgtm.com/rules/1505913226124.
