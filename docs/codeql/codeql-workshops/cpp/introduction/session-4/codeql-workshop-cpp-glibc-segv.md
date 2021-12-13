# CodeQL workshop for C/C++: glibc SEGV hunt

- Analyzed language: C/C++
- Difficulty level: 3/3

## Problem statement

In this workshop, we will use CodeQL to analyze the source code of the [GNU C Library](https://www.gnu.org/software/libc/) (glibc).

This workshop assumes you have completed the
[CodeQL workshop for C/C++: Introduction to global data flow workshop](codeql-workshop-cpp-global-data-flow.md).

The goal of this challenge is to find unsafe uses of `alloca` in glibc. [alloca](http://man7.org/linux/man-pages/man3/alloca.3.html) is used to allocate a buffer on the stack. It is usually implemented by simply subtracting the size parameter from the stack pointer and returning the new value of the stack pointer. This means that it has two important benefits:

 1. The memory allocated by `alloca` is automatically freed when the current function returns.
 1. It is extremely fast.

But `alloca` can also be unsafe because it does not check whether there is enough stack space left for the buffer. If the requested buffer size is too big, then `alloca` might return an invalid pointer. This can cause the application to crash with a `SIGSEGV` when it attempts to read or write the buffer. Therefore `alloca` is only intended to be used to allocate small buffers. It is the programmer's responsibility to check that the size isn't too big.

The GNU C Library contains hundreds of calls to `alloca`. In this challenge, you will use Semmle CodeQL to find those calls. Of course many of those calls are safe, so the main goal of the challenge is to refine your query to reduce the number of false positives.

If you follow the challenge all the way to the end then you will find a bug in glibc that is reproducible from a standard command-line application.

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on glibc, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download and unzip [this glibc database](https://downloads.lgtm.com/snapshots/cpp/GNU/glibc/bminor_glibc_cpp-srcVersion_333221862ecbebde60dd16e7ca17d26444e62f50-dist_odasa-lgtm-2019-04-08-af06f68-linux64.zip), which corresponds to revision [`3332218`](https://github.com/bminor/glibc/tree/333221862ecbebde60dd16e7ca17d26444e62f50).
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `UntrustedDataToAlloca.ql`, save it under `codeql-custom-queries-cpp`.

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for C/C++](https://help.semmle.com/QL/learn-ql/cpp/ql-for-cpp.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)

## Workshop
The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describes useful classes and predicates in the CodeQL standard libraries for C/C++. You can explore these in your IDE using the autocomplete suggestions (Ctrl + Space) and the jump-to-definition command (F12).

**Exercise 1**: In this database, `alloca` is a macro that wraps a function call. Write a query to identify the name of the function.
<details>
<summary>Hint</summary>

- Use the `Macro` class, and the `Macro.getName()` predicate.

</details>
<details>
<summary>Solution</summary>

```ql
from Macro m
where m.getName() = "alloca"
select m
```
</details>

**Exercise 2**: Find all calls to `alloca`, using the function name you found in Exercise 1.
<details>
<summary>Hint</summary>

- Use the `FunctionCall` class and the `FunctionCall.getTarget()` and `Function.getName()` predicates.

</details>
<details>
<summary>Solution</summary>

```ql
import cpp

from FunctionCall alloca
where alloca.getTarget().getName() = "__builtin_alloca"
select alloca
```
</details>

### Simple range analysis

Calls to `alloca` are considered "unsafe" if they request a buffer size which is too large. But how can we identify when the passed buffer size might be too large? In program analysis we call this a _range analysis_ problem.

Range analysis is about finding maximum and minimum values that expressions in the program can hold at runtime. These describe a _range_, with the maximum described as the _upper bound_ and the _minimum described as the _lower bound_.

CodeQL for C/C++ includes a number of range analysis libraries. For this workshop we will look at the `SimpleRangeAnalysis` library (`import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis`), which provides predicates `upperBound` and `lowerBound`. This library is considered "simple" because it works only within a single function, and it identifies _constant bounds_ on expressions - i.e. the upper and lower bounds will be numbers, rather than symbols. For example:

```c
void f(int x) {
  if (x < 0) {
    return;
  }

  if (x < 100) {
    potentiallyDangerous(x);
  }
}
```
This function first checks whether the parameter `x` is less than `0`, and if so it returns. It then checks whether the variable is less than `100`, and if it is it will call the `potentiallyDangerous` function. Therefore, for the access of `x` as the argument to the `potentiallyDangerous` function call, the `lowerBound` would be `1` and the `upperBound` would be `99`.

**Exercise 3**: Update your previous query to _exclude_ cases where the allocation size is small. You can classify the allocation size as small if it is less than 65536 and greater than 0. Make sure you do not exclude expressions which can be negative, as those are potentially very dangerous.
<details>
<summary>Hint</summary>

- Use `upperBound` and `lowerBound` on the buffer size argument to the `alloca` function call.
- Arguments can be found with `FunctionCall.getArgument(int i)`
- You can use `or` to specify conditions where only one side or the other needs to be true.
- You can use `(` and `)` brackets to group together logical conditions.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

from FunctionCall alloca
where
  alloca.getTarget().getName() = "__builtin_alloca" and
  (
    upperBound(alloca.getArgument(0)) >= 65536 or
    lowerBound(alloca.getArgument(0)) <= 0
  )
select alloca
```
</details>

### Safe use of alloca

The correct way to use `alloca` in glibc is to first check that the allocation is safe by calling `__libc_use_alloca`. An example of this is in [`getopt.c:252`](https://github.com/bminor/glibc/blob/333221862ecbebde60dd16e7ca17d26444e62f50/posix/getopt.c#L252):
```c
			if (__libc_use_alloca (n_options))
			  ambig_set = alloca (n_options);
			else if ((ambig_set = malloc (n_options)) == NULL)
			  /* Fall back to simpler error message.  */
			  ambig_fallback = 1;
			else
			  ambig_malloced = 1;
```
The code uses `__libc_use_alloca` to check if it is safe to use `alloca` for the value stored in `n_options`. If not, it uses `malloc` instead of `alloca`. In this section, you will identify calls to `alloca` that are safe because they are guarded by a call to `__libc_use_alloca`.

**Exercise 4**: Find all calls to `__libc_use_alloca`.
<details>
<summary>Hint</summary>

- Use the `FunctionCall` class and the `FunctionCall.getTarget()` and `Function.getName()` predicates.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp

from FunctionCall useAlloca
where useAlloca.getTarget().getName() = "__libc_use_alloca"
select useAlloca
```
</details>

### Control flow and Guard conditions

In order to make a call to `alloca` safe, `__libc_use_alloca` must be checked to be `true` _before_ the `alloca` call is made. This type of question can be answered by looking at the _control-flow_ graph. This models the sequencing of the program - i.e. what order operations can happen in.

Unlike the data flow graph, the control-flow graph is modelled directly on the AST (AST nodes are also `ControlFlowNode`s). `ControlFlowNode`s provide predicates `getASuccessor()` and `getAPredecessor()` for traversing the control-flow graph. For nodes that _branch_ - where the next step depends on the result of the existing node - there are predicates `getATrueSuccessor()` and `getAFalseSuccessor()`.

Control often flows linearly through a block of code, without branching. For readability and performance reasons, it is often helpful to reason about these as a single unit, which we call _basic block_, and represented using the `BasicBlock` class. For example:
```c
if (test) {
  x = y + 1;
  y = x + 1;
} else {
// ...
}
```
In this case a conditional statement (the `if`) is executed, and control then branches, either into the `then` case or the `else` case. However, the two assignments with the then part will execute sequentially, with no branching. We can use `BasicBlock`s to reason about these statements together. We can get the basic block for a `ControlFlowNode` using `getBasicBlock()`.

Now, we could use the control-flow graph directly to reason about whether an `alloca` call was proceeded by a `true` check on `__libc_use_alloca`. However, the `Guard`s library (`import semmle.code.cpp.controlflow.Guards`) makes this type of analysis very simple.

The library provides a `GuardCondition` class, which models a sub-set of `Expr`s which represent guarded checks. It provides a predicate `controls(BasicBlock controlled, boolean testIsTrue)`, which identifies which basic blocks in the program are "controlled" by this condition in either the `true` or `false` cases.

**Exercise 5**: Update you query to identify `GuardCondition`s which are a call to `__libc_use_alloca`.

<details>
<summary>Hint</summary>

 - Add a new QL variable with type `GuardCondition`.
 - Equate the `GuardCondition` and the `FunctionCall`.
</details>
<details>
<summary>Solution</summary>

```ql
from GuardCondition gc, FunctionCall useAlloca
where
  useAlloca.getTarget().getName() = "__libc_use_alloca" and
  gc = useAlloca
select gc
```
</details>

**Exercise 6**: Sometimes the result of `__libc_use_alloca` is assigned to a variable, which is then used as the guard condition. For example, this happens in [`setsourcefilter.c:38-41`](https://github.com/bminor/glibc/blob/333221862ecbebde60dd16e7ca17d26444e62f50/sysdeps/unix/sysv/linux/setsourcefilter.c#L38-L41). Enhance your query, using local dataflow, so that it also finds this guard condition.

<details>
<summary>Hint</summary>

 - `import semmle.code.cpp.dataflow.DataFlow`
 - Use `DataFlow::localFlow(DataFlow::Node source, DataFlow::Node sink)`
 - Use `DataFlow::Node DataFlow::exprNode(Expr e)`.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.DataFlow

from GuardCondition gc, FunctionCall useAlloca
where
  useAlloca.getTarget().getName() = "__libc_use_alloca" and
  DataFlow::localFlow(DataFlow::exprNode(useAlloca), DataFlow::exprNode(gc))
select gc
```
</details>

**Exercise 7**: Write a predicate `isGuardedAlloca` which find calls to `alloca` which are safe because they are guarded by a call to `__libc_use_alloc`.

<details>
<summary>Hint</summary>

 - `predicate isGuardedAlloca(...) { }`
 - Re-use the query from Exercise 2 for finding `alloca` calls.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.DataFlow

predicate isGuardedAlloca(FunctionCall alloca) {
  exists(GuardCondition gc, FunctionCall useAlloca |
    useAlloca.getTarget().getName() = "__libc_use_alloca" and
    DataFlow::localFlow(DataFlow::exprNode(useAlloca), DataFlow::exprNode(gc)) and
    alloca.getTarget().getName() = "__builtin_alloca" and
    gc.controls(alloca.getBasicBlock(), true)
  )
}

```
</details>

**Exercise 8**: Update your query from Exercise 3 to _exclude_ `alloca` calls which are guarded by `__libc_use_alloc`, using the `isGuardedAlloca` predicate.

<details>
<summary>Hint</summary>

 - `isGuardedAlloca(...)` represents the set of `alloca` calls which are _safe_. We want to update the query to only report `alloca` calls which are _not safe_ in this way.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis


predicate isGuardedAlloca(FunctionCall alloca) {
  exists(GuardCondition gc, FunctionCall useAlloca |
    useAlloca.getTarget().getName() = "__libc_use_alloca" and
    DataFlow::localFlow(DataFlow::exprNode(useAlloca), DataFlow::exprNode(gc)) and
    alloca.getTarget().getName() = "__builtin_alloca" and
    gc.controls(alloca.getBasicBlock(), true)
  )
}

from FunctionCall alloca
where
  alloca.getTarget().getName() = "__builtin_alloca" and
  not isGuardedAlloca(alloca) and
  (
    upperBound(alloca.getArgument(0)) >= 65536 or
    lowerBound(alloca.getArgument(0)) <= 0
  )
select alloca
```
</details>

### Untrusted data

We have now identified a set of `alloca` calls which are _unvalidated_, in the sense that they haven't been either range checked or checked using `__libc_use_alloca`. We now need to tie this together with a concept of potentially untrusted data in the program.

**Exercise 9**: Find all calls to `fopen`. Be aware that the `fopen` is another macro.

<details>
<summary>Hint</summary>

This is effectively a repeat of Exercise 1 and 2, except with `fopen` instead of `alloca`:
 - Write a query to find the definition of the `fopen` macro.
 - Inspect the source code, by clicking on the result, to identify the "real" name of the `fopen` function in this snapshot.
 - Write the query to find calls to this function.
</details>
<details>
<summary>Solution</summary>

```ql
import cpp

from Macro m
where m.getName() = "fopen"
select m
```
```ql
import cpp

from FunctionCall fopen
where fopen.getTarget9).getName() = "_IO_new_fopen"
select fopen
```
</details>

**Exercise 10**: Create a path-problem taint tracking query to find flow from `fopen` to the length argument of unvalidated `alloca` calls. There is one known result, but in order to find it you will need to include flow through `getdelim` calls. You can do so by including this class definition in your query:

```ql
import semmle.code.cpp.models.interfaces.DataFlow

// Track taint through `__getdelim`.
class GetDelimFunction extends DataFlowFunction {
  GetDelimFunction() { this.getName().matches("%get%delim%") }

  override predicate hasDataFlow(FunctionInput i, FunctionOutput o) {
    i.isParameter(3) and o.isParameterDeref(0)
  }
}
```

<details>
<summary>Hint</summary>

 - Use the `fopen` query to populate the `isSource` predicate, with the `fopen` call as the `source`.
 - Use the unvalidate `alloca` query to populate the `isSink` predicate. The `sink` itself will be the first argument of the call (i.e. `getArgument(0)`).
 - Remember to include the `GetDelimFunction` class above!
</details>
<details>
<summary>Solution</summary>

```ql
/**
 * @name Untrusted data to alloca
 * @id cpp/untrusted-data-to-alloca
 * @kind path-problem
 */
import cpp
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import DataFlow::PathGraph

predicate isGuardedAlloca(FunctionCall alloca) {
  exists(GuardCondition gc, FunctionCall useAlloca |
    useAlloca.getTarget().getName() = "__libc_use_alloca" and
    DataFlow::localFlow(DataFlow::exprNode(useAlloca), DataFlow::exprNode(gc)) and
    alloca.getTarget().getName() = "__builtin_alloca" and
    gc.controls(alloca.getBasicBlock(), true)
  )
}

// Track taint through `__getdelim`.
class GetDelimFunction extends DataFlowFunction {
  GetDelimFunction() { this.getName().matches("%get%delim%") }

  override predicate hasDataFlow(FunctionInput i, FunctionOutput o) {
    i.isParameter(3) and o.isParameterDeref(0)
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "FOpen" }

  override predicate isSource(DataFlow::Node source) {
    exists(FunctionCall fopen |
      fopen.getTarget().getName() = "_IO_new_fopen" and
      source.asExpr() = fopen
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall alloca |
      alloca.getTarget().getName() = "__builtin_alloca" and
      not isGuardedAlloca(alloca) and
      (
        upperBound(alloca.getArgument(0)) >= 65536 or
        lowerBound(alloca.getArgument(0)) <= 0
      ) and
      sink.asExpr() = alloca.getArgument(0)
    )
  }
}

from Config config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "Untrusted data to alloca"
```
</details>

Congratulations, you have found a genuine bug in glibc!

### Searching for a PoC

glibc includes several command-line applications, accessible via 24 main functions in this database. As an optional exercise you can see if you can identify how this bug can be used to trigger a SIGSEGV from one of these command line applications.
