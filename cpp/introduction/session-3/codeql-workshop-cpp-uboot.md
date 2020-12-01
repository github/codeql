# CodeQL workshop for C/C++: U-Boot Challenge

- Analyzed language: C/C++
- Difficulty level: 2/3

## Problem statement

In this workshop, we will use CodeQL to analyze the source code of [U-Boot loader](https://en.wikipedia.org/wiki/Das_U-Boot), an open source boot loader used in embedded devices.

This workshop assumes you have completed the 
[CodeQL workshop for C/C++: Introduction to global data flow workshop](codeql-workshop-cpp-global-data-flow.md). If
you have not, or if you prefer a more beginner focused approach to this content,
you can use the 
[CodeQL U-Boot Challenge Learning Lab](https://lab.github.com/githubtraining/codeql-u-boot-challenge-(cc++)) course,
which provides a self-guided step-by-step automated workflow. 

The goal for this workshop is to find a set of 9 remote-code-execution vulnerabilities in the U-Boot boot loader. These vulnerabilities were originally discovered by GitHub Security Lab researchers and have since been fixed. An attacker with positioning on the local network, or control of a malicious NFS server, could potentially achieve remote code execution on the U-Boot powered device. This was possible because the code read data from the network (that could be attacker-controlled) and passed it to the length parameter of a call to the memcpy function. When such a length parameter is not properly validated before use, it may lead to exploitable memory corruption vulnerabilities.

U-Boot contains hundreds of calls to both `memcpy` and `libc` functions that read data from the network. You can often recognize network data being acted upon through use of the `ntohs` (network to host short) and `ntohl` (network to host long) functions or macros. These swap the byte ordering for integer values that are received in network ordering to the host's native byte ordering (which is architecture dependent).

In this workshop, you will use CodeQL to find such calls. Many of those calls may actually be safe, so throughout this course you will refine your query to reduce the number of false positives, and finally track down the unsafe calls to memcpy that are influenced by remote input.

Upon completion of the course, you will have created a CodeQL query that is able to find variants of this common vulnerability pattern.

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on U-Boot, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download and unzip [this U-Boot CodeQL database](https://downloads.lgtm.com/snapshots/cpp/uboot/u-boot_u-boot_cpp-srcVersion_d0d07ba86afc8074d79e436b1ba4478fa0f0c1b5-dist_odasa-2019-07-25-linux64.zip), which corresponds to revision [`d0d07ba`](https://github.com/u-boot/u-boot/tree/d0d07ba86afc8074d79e436b1ba4478fa0f0c1b5)..
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `NetworkDataUsedAsMemcpyLength.ql`, save it under `codeql-custom-queries-cpp`.

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for C/C++](https://help.semmle.com/QL/learn-ql/cpp/ql-for-cpp.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)

## Workshop
The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describes useful classes and predicates in the CodeQL standard libraries for C/C++. You can explore these in your IDE using the autocomplete suggestions (Ctrl + Space) and the jump-to-definition command (F12).

**Exercise 1**: Write a CodeQL query to find calls to the `memcpy` function in the database.
<details>
<summary>Hint</summary>

- Use the `FunctionCall` class, and the `FunctionCall.getTarget()` and `Function.getName()` predicates.

</details>
<details>
<summary>Solution</summary>

```ql
import cpp

from FunctionCall memcpy
where memcpy.getTarget().getName() = "memcpy"
select memcpy
```
</details>

**Exercise 2**: `ntohl`, `ntohll`, and `ntohs` are defined as _macros_ in this database. Write a query to find these _macro definitions_.
<details>
<summary>Hint</summary>

- Use the `Macro` class and the `Macro.getName()` predicate.
- You can use regular expression matching using  `regexpMatch("<someregex>")` on a CodeQL string.

</details>
<details>
<summary>Solution</summary>

```ql
import cpp

from Macro m
where m.getName().regexpMatch("ntoh(s|l|ll)")
select m
```
</details>

### Macros

Macros and other pre-processor directives can easily cause confusion when analyzing programs with CodeQL. This is because:

 * The AST structure reflects the program _after_ preprocessing.
 * But locations refer to the original source text _before_ preprocessing.

This is because un-preprocessed code cannot, in general, be parsed and analyzed, but showing the results in pre-processed code is confusing to developers.

Consider this example:
```c
#define square(x) x*x
y = square(y0);
z = square(z0);
```
We define a macro that replaces instances of `square(x)` in the program with `x*x`. Once the preprocessor has run, we will have the following:
```c
y = y0*y0;
z = z0*z0;
```
We will therefore have AST nodes for `Assignment`s and `MulExpr`s, but there will be no AST nodes corresponding to `square(y0)` and `square(z0)`. The locations of these AST nodes (i.e. the portions of code we will highlight when they are selected) will, however, be the locations in the code _before_ the preprocessor ran.

Although it is not possible to sensibly analyze a project before pre-processing, it is often still useful to be able to ask questions about which macros applied to which AST nodes.

For this reason, we store in the database:
 - Macro definitions using the `Macro` class. In the example above, we will have a `Macro` definition for `square(x)`.
 - Macro accesses, using the `MacroAccess` class.
 - Macro accesses that are expanded (e.g. `#define`) are represented using the `MacroInvocation` class, which can provide access to the AST nodes which were generated (or partially generated) by this macro. Notably, if a `MacroInvocation` produces a complete expression (as with the `square` example above), you can use the predicate `MacroInvocation.getExpr()` to get the complete expression.

**Exercise 3**: Update your previous query to find `MacroInvocation`s to the `ntoh*` functions.
<details>
<summary>Hint</summary>

- You can use `MacroInvocation.getMacro()` to get the `Macro` associated with an invocation.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp

from MacroInvocation mi
where mi.getMacro().getName().regexpMatch("ntoh(s|l|ll)")
select mi
```
</details>

**Exercise 4**: The `ntoh*` macros expand to a complete expression. Update your query to report this expression.
<details>
<summary>Hint</summary>

- `MacroInvocation.getExpr()` will return the complete, unique expression.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp

from MacroInvocation mi
where mi.getMacro().getName().regexpMatch("ntoh(s|l|ll)")
select mi, mi.getExpr()
```
</details>

### Taint tracking

By identifying expressions produced by `ntoh*` macro expansion we have likely identified potentially untrusted network data in the program. We have also found calls to `memcpy`, where it would be dangerous if the length argument (the argument at index `2`) were to be used with untrusted data. We will now put this together in a taint tracking query.

**Exercise 5**: Create a path-problem taint tracking query which identifies flow from expressions expanded from `ntoh*` macros (as defined by the query in Exercise 4) to the length argument of `memcpy` function calls.

<details>
<summary>Hint</summary>

 - The length argument for `memcpy` is at index `2`.
 - `FunctionCall.getArgument(int i)` returns the i-th argument.
 - You may find it easier to write it as an `@kind problem` query first, then convert it to a `path-problem` query using the steps listed in the last workshop.
</details>
<details>
<summary>Solution</summary>

```ql
/**
 * @name Network data used as memcpy length.
 * @id cpp/network-to-memcpy
 * @kind path-problem
 */
import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class Config extends TaintTracking::Configuration {
  Config() { this = "Config: this name doesn't matter" }

  override predicate isSource(DataFlow::Node source) {
    exists(MacroInvocation mi |
      mi.getMacroName().regexpMatch("ntoh(s|l|ll)") and
      source.asExpr() = mi.getExpr()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall c | c.getTarget().getName() = "memcpy" and sink.asExpr() = c.getArgument(2))
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"
```
</details>

**Exercise 6**: _take home, optional_ Create a new CodeQL class to represent `NetworkByteSwaps`, and define the characteristic predicate using the `ntoh*` macro expansion.

**Exercise 7**: _take home, optional_ There are 13 known vulnerabilities in U-Boot. The query you completed above found 9 of them. See if you can refine your query to find 1 or more of the additional vulnerabilities.

**Exercise 8**: _take home, optional_ Generalize your query to find other untrusted inputs (not only networking) such as ext4 fs.
