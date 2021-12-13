# CodeQL workshop for C/C++: Introduction to local data flow

- Analyzed language: C/C++
- Difficulty level: 2/3

## Problem statement

In this workshop, we will use CodeQL to analyze the source code of [dotnet/coreclr](https://github.com/dotnet/coreclr), the runtime for .NET Core.

Formatting functions allow the programmer to construct a string output using a format string and an optional set of arguments. The format string is specified using a simple template language. The output string is constructed by processing the format string to find format specifiers, and inserting the values provided as arguments. For example, this `printf` statement:
```c
printf("Name: %s, Age: %d", "Freddie", 2);
```
would produce the output `"Name: Freddie, Age: 2"`. So far, so good. However, problems arise if there is a mismatch between the number of formatting specifiers, and the number of arguments. For example:
```c
printf("Name: %s, Age: %d", "Freddie");
```
In this case, we have one more format specifier than we have arguments. In a managed language such as Java or C#, this simply leads to a runtime exception. However, in C/C++, the formatting functions are typically implemented by reading values from the stack without any validation of the number of arguments. This means a mismatch in the number of format specifiers and the number of format arguments can lead to information disclosure (i.e. accessing unintended values from the top of the stack).

Of course, in practice this happens rarely with constant formatting strings. Instead, it’s most problematic when the formatting string can be specified by the _user_, allowing an attacker to provide a formatting string with the wrong number of format specifiers. Furthermore, if an attacker can control the format string, they may be able to provide the `%n` format specifier, which causes `printf` to write the number characters in the generated output string to a specified memory location.

See https://en.wikipedia.org/wiki/Uncontrolled_format_string for more background.

This workshops will provide:
 - Further experience writing real world queries
 - Exploration of local data flow
 - Exploration of local taint tracking

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on dotnet/coreclr, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download the [dotnet/coreclr database](http://downloads.lgtm.com/snapshots/cpp/dotnet/coreclr/dotnet_coreclr_fbe0c77.zip).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `NonConstantFormatString.ql`, save it under `codeql-custom-queries-cpp`.

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for C/C++](https://help.semmle.com/QL/learn-ql/cpp/ql-for-cpp.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)

## Workshop
The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describes useful classes and predicates in the CodeQL standard libraries for C/C++. You can explore these in your IDE using the autocomplete suggestions (Ctrl + Space) and the jump-to-definition command (F12 in VS Code).

### Non-constant format strings

**Exercise 1**: Write a query that identifies `printf` (and similar) calls in the program. You can use the CodeQL standard library `semmle.code.cpp.commons.Printf` (by adding `import semmle.code.cpp.commons.Printf`).
<details>
<summary>Hint</summary>

Use the `FormattingFunctionCall` class, which represents many different formatting functions (`printf`, `snprintf` etc.).
</details>
<details>
<summary>Solution</summary>

```ql
from FormattingFunctionCall printfCall
select printfCall
```
</details>

**Exercise 2**: Update your query to report the "format string argument" to the `printf`-like call.
<details>
<summary>Hint</summary>

`printf` treats the first argument as the format string, however other formatting function calls (such as `snprintf`) pass the format string argument at a different position. For this reason,  `FormattingFunctionCall` has a predicate named `getFormat()` which returns the format string argument, at whatever position it is.
</details>
<details>
<summary>Solution</summary>

```ql
from FormattingFunctionCall printfCall
select printfCall, printfCall.getFormat()
```
</details>

**Exercise 3**: A simple way to find potentially risky `printf`-like calls is to report only the cases where the format argument is _not_ a string literal. Refine the query to do this.
<details>
<summary>Hint</summary>

In the CodeQL standard library for C/C++ string constants are represented with the class `StringLiteral`. You can check whether a value is in a class using `instanceof`, for example `v instanceof StringLiteral`.
</details>
<details>
<summary>Solution</summary>

```ql
/**
 * @name Non-constant format string
 * @id cpp/non-constant-format-string
 * @kind problem
 */
import cpp
import semmle.code.cpp.commons.Printf

from FormattingFunctionCall printfCall
where not printfCall.getFormat() instanceof StringLiteral
select printfCall.getFormat(), "Non-constant format argument"
```
</details>

Unfortunately, the results at this stage are unsatisfactory. For example, consider the results which appear in `/src/ToolBox/SOS/Strike/util.h`, between lines 965 and 970:

```c
      const char *format = align == AlignLeft ? "%-*.*s" : "%*.*s";

      if (IsDMLEnabled())
          DMLOut(format, width, precision, mValue);
      else
          ExtOut(format, width, precision, mValue);
```
Here, `DMLOut` and `ExtOut` are macros that expand to formatting calls. The format specifier is not constant, in the sense that the format argument is not a string literal. However, it is clearly only one of two possible constants, both with the same number of format specifiers.

What we need is a way to determine whether the format argument is ever set to something that is not constant.

### Data flow

The solution here is to use data flow. Data flow is, as the name suggests, about tracking the flow of data through the program. It helps answers questions like: does this expression ever hold a value that originates from a particular other place in the program?

We can visualize the data flow problem as one of finding paths through a directed graph, where the nodes of the graph are elements in program, and the edges represent the flow of data between those elements. If a path exists, then the data flows between those two nodes.

Consider this example C function:

```c
int func(int tainted) {
   int x = tainted;
   if (someCondition) {
     int y = x;
     callFoo(y);
   } else {
     return x;
   }
   return -1;
}
```
The data flow graph for this function will look something like this:

<img src="https://help.semmle.com/QL/ql-training/_images/graphviz-2ad90ce0f4b6f3f315f2caf0dd8753fbba789a14.png" alt="drawing" width="300"/>

This graph represents the flow of data from the tainted parameter. The nodes of graph represent program elements that have a value, such as function parameters and expressions. The edges of this graph represent flow through these nodes.

There are two variants of data flow available in CodeQL:
 - Local (“intra-procedural”) data flow models flow within one function; feasible to compute for all functions in a CodeQL database.
 - Global (“inter-procedural”) data flow models flow across function calls; not feasible to compute for all functions in a CodeQL database.

These are different APIs, so they will be discussed separately. This workshop focuses on the former.

### Local data flow

The data flow library can be imported from `semmle.code.cpp.dataflow.DataFlow`. Note, this library contains an explicit "module" declaration:
```ql
module DataFlow {
  class Node extends ... { ... }
  predicate localFlow(Node source, Node sink) {
            localFlowStep*(source, sink)
         }
  ...
}
```
So all references will need to be qualified (that is, `DataFlow::Node`, rather than just `Node`).

The nodes are represented by the class `DataFlow::Node`. The data flow graph is separate from the AST (Abstract Syntax Tree, which represents the basic structure of the program), to allow for flexibility in how data flow is modeled. There are a small number of data flow node types – expression nodes, parameter nodes, uninitialized variable nodes, and definition by reference nodes, amongst others. Each node provides mapping predicates to and from the relevant AST node (for example `Expr`, `Parameter` etc.) or symbol table (for example `Parameter`) classes. For example:

 - `Node.asExpr()` asks for the AST `Expr` that is represented by this data flow node (if one exists)
 - `Node.asParameter()` asks for the AST `Parameter` that is represented by this data flow node (if one exists)
 - `DataFlow::exprNode(Expr e)` is a predicate that reports the `DataFlow::Node` for the given `Expr`.
 - `DataFlow::parameterNode(Parameter p)` is a predicate that reports the `DataFlow::Node` for the given `Parameter`.

Similar helper predicates exist for the other types of node, although expressions and parameters are the most common.

The `DataFlow::Node` class is shared between both the local and global data flow graphs. The primary difference is the edges, which in the “global” case can link different functions.

The edges are represented by predicates. `DataFlow::localFlowStep` is the "single step" flow relation – that is, it describes single edges in the local data flow graph. `DataFlow::localFlow` represents the transitive closure of this relation – in other words, it contains every pair of nodes where the second node is reachable from the first in the data flow graph (i.e. a "reachability" table).

<details>
<summary>Example</summary>

Consider again our C example, this time with the nodes numbered:
```c
int func(int tainted) { // 1
   int x = tainted; // 2
   if (someCondition) {
     int y = x; // 3
     callFoo(y); // 4
   } else {
     return x; // 5
   }
   return -1;
}
```

Then the table of values computed for the `DataFlow::localFlowStep` predicate for this function will be:

| nodeFrom | nodeTo |
| -------- | ------ |
| 1 | 2 |
| 2 | 3 |
| 2 | 5 |
| 3 | 4 |

And the table of values computed for the `DataFlow::localFlow` predicate for this function will be:

| source | sink |
| ------ | ---- |
| 1 | 1 |
| 1 | 2 |
| 1 | 3 |
| 1 | 4 |
| 1 | 5 |
| 2 | 2 |
| 2 | 3 |
| 2 | 4 |
| 2 | 5 |
| 3 | 3 |
| 3 | 4 |
| 4 | 4 |
| 5 | 5 |
</details>

### Local data flow non-constant format string

One of the problems with our first query was that it did not exclude cases where the format string was constant but declared earlier in the function. We will now try to write a more refined version of our non-constant format string query by using local data flow to track back to the "source" of a format string within the function. We can then determine whether the "source" is a constant (i.e. string literal).

**Exercise 4**: We will treat any data flow node without incoming local flow edges as a "source node" of interest. Define a predicate `isSourceNode` which identifies nodes without any incoming flow edges.

<details>
<summary>Hint</summary>

 - Create a predicate called `isSourceNode` with a single argument called `sourceNode` of type `DataFlow::Node`.
 - The edges in the data flow graph are represented by the predicate `DataFlow::localFlowStep`. You can think of this as providing a table of `nodeFrom, nodeTo` pairs for each edge in the graph. A node without any incoming flow edges will have no rows in the `DataFlow::localFlowStep` table where it is the second argument.
 - You can use `not exists(..)` to state that there does not exist a `DataFlow::Node` that is the `nodeFrom` for the `sourceNode` parameter of your predicate.
 - Alternatively, you can use `_` as a placeholder in any predicate call where you don't care about one of the values. This will allow you to avoid an explicit `exists`.
</details>
<details>
<summary>Solution</summary>

```ql
predicate isSourceNode(DataFlow::Node sourceNode) {
    not DataFlow::localFlowStep(_, sourceNode)
    // explicit version: not exists(DataFlow::Node nodeFrom | DataFlow::localFlowStep(nodeFrom, sourceNode))
}
```
</details>

**Exercise 5**: For this query it will be more convenient if we define a CodeQL class for "source nodes". Define a new subclass of `DataFlow::Node` called `SourceNode`, and convert your predicate into the characteristic predicate.

<details>
<summary>Hint</summary>

 - Create your own class `SourceNode` which extends `DataFlow::Node`.
 - This will initially contain the set of all data flow nodes in the program. Add a characteristic predicate (`SourceNode() { ... }`) which restricts it to only the nodes without any incoming flow edges. Remember you can use the implicit variable `this`.
</details>
<details>
<summary>Solution</summary>

```ql
class SourceNode extends DataFlow::Node {
  SourceNode() {
    not DataFlow::localFlowStep(_, this)
    // explicit version: not exists(DataFlow::Node nodeFrom | DataFlow::localFlowStep(nodeFrom, this))
  }
}
```
</details>

**Exercise 6**: Update the non-constant format string query to use local data flow and your new `SourceNode` class to filter out any format string calls where the source is a `StringLiteral`.

<details>
<summary>Hint</summary>

 - Add a new QL variable called `src` with type `SourceNode`.
 - Add a new QL variable called `formatStringArg` with type `DataFlow::Node`.
 - Use `localFlow` to say that there is flow between the two.
 - Use `asExpr()` to assert that the `getFormat()` expression of the `FormattingFunctionCall` is represented by the `formatStringArg` data flow node.
 - Use `asExpr()` to assert that the _expression_ represented by `src` is not a `StringLiteral`.
</details>
<details>
<summary>Solution</summary>

```ql
/**
 * @name Non-constant format string
 * @id cpp/non-constant-format-string
 * @kind problem
 */
import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.commons.Printf

class SourceNode extends DataFlow::Node {
  SourceNode() {
    not DataFlow::localFlowStep(_, this)
  }
}

from FormattingFunctionCall printfCall, SourceNode src, DataFlow::Node formatStringArg
where
  formatStringArg.asExpr() = printfCall.getFormat() and
  DataFlow::localFlow(src, formatStringArg) and
  not src.asExpr() instanceof StringLiteral
select formatStringArg, "Non-constant format string from $@.", src, src.toString()
```
</details>

### Local taint tracking

Data flow analysis tells us how values flow _unchanged_ through the program. Taint tracking analysis is slightly more general: it tells us how values flow through the program and may undergo minor changes, while still influencing (or tainting) the places where they end up. For example:

```c
strcat(formatString, tainted); // source -> sink: taint flow step, not data flow step
printf(formatString, ...)
```
Would not be found by data flow alone because `strcat` modifies the `formatString` by _appending_ the tainted value.

Taint tracking can be thought of as another type of data flow graph. It usually extends the standard data flow graph for a problem by adding edges between nodes where one one node influences or taints another.

The taint-tracking API is almost identical to that of the local data flow. All we need to do to switch to taint tracking is `import semmle.code.cpp.dataflow.TaintTracking` instead of `semmle.code.cpp.dataflow.DataFlow`, and instead of using `DataFlow::localFlow`, we use `TaintTracking::localTaint`.

**Exercise 7** Update the non-constant format string query from the previous query to use local taint tracking instead of local data flow.

<details>
<summary>Hint</summary>

 - Replace the data flow import with the taint tracking import
 - Update the `SourceNode` class to refer to `TaintTracking::localTaintStep`.
 - Update the query to refer to `TaintTracking::localTaint` instead of `DataFlow::localFlow`.
</details>
<details>
<summary>Solution</summary>

```ql
/**
 * @name Non-constant format string
 * @id cpp/non-constant-format-string
 * @kind problem
 */
import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.commons.Printf

class SourceNode extends DataFlow::Node {
  SourceNode() {
    not TaintTracking::localTaintStep(_, this)
  }
}

from FormattingFunctionCall printfCall, SourceNode src, DataFlow::Node formatStringArg
where
  formatStringArg.asExpr() = printfCall.getFormat() and
  TaintTracking::localTaint(src, formatStringArg) and
  not src.asExpr() instanceof StringLiteral
select formatStringArg, "Non-constant format string from $@.", src, src.toString()
```
</details>

Unfortunately, the results are still underwhelming. If we look through, we find that the main problem is that we don't know where the data originally comes from _outside_ of the function, and there are an implausibly large number of results. One option would be to expand our query to track back through function calls, but handling parameters explicitly is cumbersome.

Instead, we could turn the problem around, and instead find user-controlled data that flows to a printf format argument, potentially through calls. This would be a global data flow problem, and this is something we will pick up in a later session.

**Exercise 8** _optional homework_ Refine the query in the following ways:
 - Replace `TaintTracking::localTaintStep` with a custom wrapper predicate that includes steps through global variable definitions.
     - _Hint_ - Use class `GlobalVariable` and its member predicates `getAnAssignedValue()` and `getAnAccess()`.
 - Exclude calls in wrapper functions that just forward their format argument to another printf-like function; instead, flag calls to those functions. _Hard_
