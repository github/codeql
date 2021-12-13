# CodeQL workshop for C/C++: Introduction to global data flow

- Analyzed language: C/C++
- Difficulty level: 2/3

## Problem statement

In this workshop, we will use CodeQL to analyze the source code of
[dotnet/coreclr](https://github.com/dotnet/coreclr), the runtime for .NET
Core. This follows on from the 
[Introduction to local dataflow](../session-2/codeql-workshop-cpp-local-data-flow.md)
workshop, and we recommend completing that workshop first. 

Many security problems can be phrased in terms of _information flow_:

_Given a (problem-specific) set of sources and sinks, is there a path in the data flow graph from some source to some sink?_

Some real world examples include:

 * SQL injection: sources are user-input, sinks are SQL queries
 * Reflected XSS: sources are HTTP requests, sinks are HTTP responses
 
We can solve such problems using the data flow and taint tracking libraries. Recall from the previous workshop that there are two variants of data flow available in CodeQL:
 - Local (“intra-procedural”) data flow models flow within one function
 - Global (“inter-procedural”) data flow models flow across function calls

While local data flow is feasible to compute for all functions in a CodeQL database, global data flow is not. This is because the number of paths becomes _exponentially_ larger for global data flow.

The global data flow (and taint tracking) library avoids this problem by requiring that the query author specifies which _sources_ and _sinks_ are applicable. This allows the implementation to compute paths only between the restricted set of nodes, rather than for the full graph.

In this workshop we will try to write a global data flow query to solve the format
string problem introduced in the [Introduction to local dataflow](../session-2/codeql-workshop-cpp-local-data-flow.md) 

This workshops will provide:
 - Exploration of global data flow and taint tracking
 - Path queries
 - Data flow sanitizers and barriers
 - Data flow extra taint steps
 - Data flow models

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on dotnet/coreclr, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download the [dotnet/coreclr](http://downloads.lgtm.com/snapshots/cpp/dotnet/coreclr/dotnet_coreclr_fbe0c77.zip).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `FormatStringInjection.ql`, save it under `codeql-custom-queries-cpp`.

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for C/C++](https://help.semmle.com/QL/learn-ql/cpp/ql-for-cpp.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)

## Workshop
The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describes useful classes and predicates in the CodeQL standard libraries for C/C++. You can explore these in your IDE using the autocomplete suggestions (Ctrl + Space) and the jump-to-definition command (F12).

### Non-constant format strings

In the previous workshop we wrote a query to find non-constant format strings using local data flow:
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
Unfortunately, the results are a little bit disappointing. For example, consider the result which appears in `/src/debug/createdump.cpp`, between lines 9 and 19:
```c
//
// The common create dump code
//
bool
CreateDumpCommon(const char* dumpPathTemplate, MINIDUMP_TYPE minidumpType, CrashInfo* crashInfo)
{
    ReleaseHolder<DumpWriter> dumpWriter = new DumpWriter(*crashInfo);
    bool result = false;

    ArrayHolder<char> dumpPath = new char[PATH_MAX];
    snprintf(dumpPath, PATH_MAX, dumpPathTemplate, crashInfo->Pid());
```
A parameter `dumpPathTemplate` is used as the format string in an `snprintf` call. However, we simply don't know whether the value of `dumpPathTemplate` can be set to something which is not constant, without looking at every caller of the method `CreateDumpCommon`.

### Untrusted data

If we consider what we mean by "non-constant", what we really care about is whether an attacker can provide this format string. As a first step, we will try to identify elements in the codebase which represent "sources" of untrusted user input.

**Exercise 1**: Use the `semmle.code.cpp.security.Security` library to identify `DataFlow::Node`s which are considered user input.
<details>
<summary>Hint</summary>

 - The `Security` library contains a `SecurityOptions` class. This class is a little different from the existing classes we have seen, because it is a _configuration_ class. It does not represent any set of particular values in the database. Instead there is a single instance of this class, and it exists to provide predicates that are useful in security queries in a way that can be configured by the query writer.
 - For our case it provides a predicate called `isUserInput`, which is a set of expressions in the program which are considered user inputs. You can use F12 to jump-to-definition to see what we consider to be a user input.
 - `isUserInput` has two parameters, but we are not interested in the second parameter, so we can use `_` to ignore it.
 - We want the `DataFlow::Node` for the user input, so remember to use `.asExpr()` to make that compatible with the `isUserInput` API.
 - You can configure custom sources by creating a new subclass of `SecurityOptions`, and overriding one of the existing predicates. For today, the default definitions are sufficient.

</details>
<details>
<summary>Solution</summary>

```ql
import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.security.Security

from SecurityOptions opts, DataFlow::Node source
where opts.isUserInput(source.asExpr(), _)
select source
```
</details>

### Format string injection

We now know where user input enters the program, and we know where format strings are used. We now need to combine these using to find out whether data flows from one of these sources to one of these format strings. This is a global data flow problem.

As we mentioned in the introduction, the difference between local and global data flow is that we need to specify up front what sources and sinks we are interested in. This is because building a full table for a `globalTaint` predicate (i.e. the reachability table for the whole program), is just not feasible for any reasonable size of program, because it is bounded by `o(n*n)`, where `n` is the number of nodes.

The way we configure global data flow is by creating a custom extension of the `DataFlow::Configuration` class, and speciyfing `isSource` and `isSink` predicates:
```ql
class MyConfig extends DataFlow::Configuration {
  MyConfig() { this = "<some unique identifier>" }
  override predicate isSource(DataFlow::Node nd) { ... }
  override predicate isSink(DataFlow::Node nd) { ... }
}
```
Like the `SecurityOptions` class, `DataFlow::Configuration` is another _configuration_ class. In this case, there will be a single instance of your class, identified by a unique string specified in the characteristic predicate. We then override the `isSource` predicates to represent the set of possible sources in the program, and `isSink` to represent the possible set of sinks in the program.

To use this new configuration class we can call the `hasFlow(source, sink)` predicate, which will compute a reachability table between the defined sources and sinks. Behind the scenes, you can think of this as performing a graph search algorithm from sources to sinks.

As with local data flow, we also have a _taint tracking_ variant of global data flow. The API is almost identical, the main difference is that we extend `TaintTracking::Configuration` instead. For the rest of this workshop we will use taint tracking, rather than data flow, as for this problem we really care about whether a user can influence a format string, not just whether they can specify the whole format string. This is because as long as an attacker can control part of the format string, they can usually place as many format specifiers as they like.

Here is an outline of the query we will write:
```ql
/**
 * @name Format string injection
 * @id cpp/format-string-injection
 * @kind problem
 */
import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.security.Security

class TaintedFormatConfig extends TaintTracking::Configuration {
  TaintedFormatConfig() { this = "TaintedFormatConfig" }
  override predicate isSource(DataFlow::Node source) {
    /* TBD */
  }
  override predicate isSink(DataFlow::Node sink) {
    /* TBD */
  }
}

from TaintedFormatConfig cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "This format string may be derived from a $@.", source, "user-controlled value"
```

**Exercise 2**: Implement the `isSource` predicate in this using the previous query for identifying user input `DataFlow::Node`s.
<details>
<summary>Hint</summary>

 - Use an `exists(..)` to introduce a new variable for `SecurityOptions` within the `isSource` predicate.
</details>
<details>
<summary>Solution</summary>

```ql
  override predicate isSource(DataFlow::Node source) {
    exists (SecurityOptions opts |
      opts.isUserInput(source.asExpr(), _)
    )
  }
```
</details>

**Exercise 3**: Implement the `isSink` predicate to identify format strings of format calls as sinks.
<details>
<summary>Hint</summary>

 - Use an `exists` to introduce a new variable of type `FormattingFunctionCall`, and use the predicate `getFormat()` to identify the format strings.
 - Remember to use `DataFlow::Node.asExpr()` when comparing with the result of `getFormat()`.
</details>
<details>
<summary>Solution</summary>

```ql
  override predicate isSink(DataFlow::Node sink) {
    exists (FormattingFunctionCall printfCall |
      sink.asExpr() = printfCall.getFormat()
    )
  }
```
</details>

<details>
<summary>Overall Solution</summary>

```ql
/**
 * @name Format string injection
 * @id cpp/format-string-injection
 * @kind problem
 */
import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.security.Security

class TaintedFormatConfig extends TaintTracking::Configuration {
  TaintedFormatConfig() { this = "TaintedFormatConfig" }
  override predicate isSource(DataFlow::Node source) {
    exists (SecurityOptions opts |
      opts.isUserInput(source.asExpr(), _)
    )
  }
  override predicate isSink(DataFlow::Node sink) {
    exists (FormattingFunctionCall printfCall |
      sink.asExpr() = printfCall.getFormat()
    )
  }
}

from TaintedFormatConfig cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "This format string may be derived from a $@.", source, "user-controlled value"
```
</details>

If we now run the query, we now only get 3 results, which is much more plausible! If we look at the results, however, it can be hard to verify whether the results are genuine or not, because we only see the source of the problem, and the sink, not the path in between.

### Path queries

The answer to this is to convert the query to a _path problem_ query. There are five parts we will need to change:
 - Convert the `@kind` from `problem` to `path-problem`. This tells the CodeQL toolchain to interpret the results of this query as path results.
 - Add a new import `DataFlow::PathGraph`, which will report the path data alongside the query results.
 - Change `source` and `sink` variables from `DataFlow::Node` to `DataFlow::PathNode`, to ensure that the nodes retain path information.
 - Use `hasFlowPath` instead of `hasFlow`.
 - Change the select to report the `source` and `sink` as the second and third columns. The toolchain combines this data with the path information from `PathGraph` to build the paths.

<details>
<summary>Format string injection as a path query</summary>

```ql
/**
 * @name Format string injection
 * @id cpp/format-string-injection
 * @kind path-problem
 */
import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.security.Security
import DataFlow::PathGraph

class TaintedFormatConfig extends TaintTracking::Configuration {
  TaintedFormatConfig() { this = "TaintedFormatConfig" }
  override predicate isSource(DataFlow::Node source) {
    exists (SecurityOptions opts |
      opts.isUserInput(source.asExpr(), _)
    )
  }
  override predicate isSink(DataFlow::Node sink) {
    exists (FormattingFunctionCall printfCall |
      sink.asExpr() = printfCall.getFormat()
    )
  }
}

from TaintedFormatConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "This format string may be derived from a $@.", source, "user-controlled value"
```
</details>

### Additional data flow features

Data flow and taint tracking configuration classes support a number of additional features that help configure the process of building and exploring the data flow path.

One such feature is a _barrier_ or _sanitizer_ nodes. In some cases you will want to ignore paths that go through a certain set of data flow nodes, because those nodes either make the data safe, or validate that the data is safe. You can specify this by implementing another predicate in your configuration class, called `isSanitizer` (known as `isBarrier` for the `DataFlow::Configuration`).

For example, string format vulnerabilities generally can't be exploited if the user input is converted to an integer. We can model calls to the standard library `atoi` C function as a sanitizer like this:
```ql
  override predicate isSanitizer(DataFlow::Node sanitizer) {
    exists(FunctionCall fc |
      fc.getTarget().getName() = "atoi" and
      sanitizer.asExpr() = fc
    )
  }
```

A similar feature - `isSanitizerGuard` - allows you to specify a condition which is considered to be a "safety" check. If the check passes, the value should be considered safe.

Another feature is adding additional taint steps. This is useful if you use libraries which are not modelled by the default taint tracking. You can implement this by overriding `isAdditionalTaintStep` predicate. This has two parameters, the `from` and the `to` node, and essentially allows you to add extra edges into the taint tracking or data flow graph.

For example, you can model flow from C++ `string`s to C-style strings using the `.c_str()` method with the following additional taint step.

```ql
  override
  predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc |
      fc.getTarget().getName() = "c_str" and
      fc.getQualifier() = node1.asExpr() and
      fc = node2.asExpr()
    )
  }
```
