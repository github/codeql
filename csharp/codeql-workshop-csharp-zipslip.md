# CodeQL workshop for C#: Zip Slip in PowerShell

**Link to this document**: https://git.io/JfeOs

- Analyzed language: C#
- Difficulty level: 2/3

## Problem statement

Within a zip archive, each compressed file has a zip file entry that describes the path of the compressed file. Entries can contain double dots, for example `../../bin/bash`. If this is not checked before extracting the archive, the uncompressed file could overwrite any location on the filesystem, possibly outside the target extraction directory.

Applications that receive zip files and extract them on the filesystem without checking for this pattern are vulnerable: an attacker could provide a malicious upload and overwrite arbitrary files on the application host.
This vulnerability, known as "Zip Slip", was [announced by Snyk on June 5th 2018](https://snyk.io/research/zip-slip-vulnerability). Variants exist in many languages including C#, Java, Groovy, JavaScript and Go.

The standard CodeQL query for this pattern in C# was written by Microsoft, who quickly developed it after the vulnerability was announced, ran it on their codebases, and contributed a refined query to the open-source CodeQL repository. You can [see the query here](https://github.com/Semmle/ql/blob/master/csharp/ql/src/Security%20Features/CWE-022/ZipSlip.ql) as part of the CodeQL standard query library.

One of the codebases fixed as a result of this query was PowerShell. A senior Microsoft engineer fixed this vulnerability in November 2018 in [this PR](https://lgtm.com/projects/g/PowerShell/PowerShell/rev/b39a41109d86d9ba75f966e2d7b52b81fa629150). In this workshop, we will use CodeQL to analyze the source code of PowerShell, taken from before the vulnerability was patched, and identify the same vulnerability.

What does this vulnerability look like in C# code? Consider the following:

```cs
foreach (ZipArchiveEntry entry in zipArchive.Entries)
{
  string extractPath = Path.Combine(destination, entry.FullName);
  entry.ExtractToFile(extractPath);
}

```
Here `entry.FullName` is the path of the zip file entry, and could contain `..`. If it is provided to `Path.Combine(destination, ...)` without being sanitized first, it could result in a path that lies anywhere on the filesystem outside `destination`, and then the file could be written to that location when it is unzipped by the call to `ExtractToFile`.
- `Path.Combine("c:\users\me\output", "good.bat")`
  --> `"c:\users\me\output\good.bat"`
- `Path.Combine("c:\users\me\output", "../../../tmp/evil.bat")`
  --> `"c:\tmp\evil.bat"`

The fix is to validate that the resulting path is actually within the target folder. `Path.GetFullPath` will resolve any `..` from the path and give the resulting path, which can be checked.

```cs
foreach (ZipArchiveEntry entry in zipArchive.Entries)
{
  string extractPath = Path.Combine(destination,entry.FullName);
  if (!Path.GetFullPath(extractPath).StartsWith(destination))
    throw new Exception(...);
  entry.ExtractToFile(extractPath);
}
```

To summarize the problem, there is a potential security vulnerability when:
1. A path comes from `ZipArchiveEntry.FullName` (a **source**).
1. The path is used to write a file (a **sink**).
1. There is no validation that the resulting path remains within the target folder  (no **sanitizer**).

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on PowerShell offline, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
    - **Enterprise customers**: Switch to the `1.23.1` branch to obtain query libraries compatible with your installation of LGTM Enterprise / GitHub Advanced Security.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download [this CodeQL database built from the PowerShell
   code](http://downloads.lgtm.com/snapshots/csharp/microsoft/powershell/PowerShell_PowerShell_csharp-srcVersion_450d884668ca477c6581ce597958f021fac30bff-dist_odasa-lgtm-2018-09-11-e5cbe16-linux64.zip).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `ZipSlip.ql`, save it under `codeql-custom-queries-csharp`.
2. Run a simple test query:
   ```ql
   import csharp
   select 42
   ```
   
   When asked
   `Should the database ... be upgraded?` 
   select `Yes`.

<!--
### Writing queries in the browser
To run CodeQL queries on PowerShell online, follow these steps:
1. Create an account on LGTM.com if you haven't already. You can log in via OAuth using your Google or GitHub account.
1. [Start querying the PowerShell project](TODO).
    - Alternative: Visit the [PowerShell project page](https://lgtm.com/projects/g/PowerShell/PowerShell) and click **Query this project**.
-->

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for C#](https://help.semmle.com/QL/learn-ql/csharp/ql-for-csharp.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)
- [CodeQL library for C#](https://help.semmle.com/qldoc/csharp)

For this session, you may find the page [Introducing the CodeQL libraries for C#](https://help.semmle.com/QL/learn-ql/csharp/introduce-libraries-csharp.html#introducing-the-codeql-libraries-for-c) particularly useful. It describes how patterns in C# syntax are modelled in the CodeQL standard library.

## Challenge
The challenge is split into several steps. You can write one query per step, or work with a single query that you refine at each step.

Each step has a **Hint** that describe useful classes and predicates in the CodeQL standard libraries for C# and keywords in CodeQL. You can explore these in your IDE using the autocomplete suggestions and jump-to-definition command.

Each step has a **Solution** that indicates one possible answer. 

To recap the problem we are looking for:
1. A path comes from `ZipArchiveEntry.FullName` (a **source**).
1. The path is used to write a file (a **sink**).
1. There is no validation that the resulting path remains within the target folder  (no **sanitizer**).

### Finding the full names of zip file entries

Let us look at the first part of our problem: identifying the **source**(s) by looking for file
paths returned from `ZipArchiveEntry.FullName`.

Write a query to find all accesses to the `FullName` property on objects of the `ZipArchiveEntry` class in the source code.  The C# code sample is

```cs
foreach (ZipArchiveEntry entry in zipArchive.Entries)
{
  string extractPath = Path.Combine(destination, entry.FullName);
  ...
}
```

<details>
<summary>Hint</summary>

- A property is called a `Property` in the CodeQL C# library, and an expression that accesses it is called a `PropertyAccess`.
- The predicates `Property.getAnAccess()`, `Element.getName()`, and `Property.getDeclaringType()` may be useful when starting from the property (here, `FullName`)
- A class is called a `Class` in the CodeQL C# library
- The predicate `Class.hasName` may be useful when starting from the class (here, `ZipArchiveEntry`)
</details>
<details>
<summary>Solution</summary>

A bottom-up solution starting from the `FullName` property is

```codeql
import csharp
from Property p
where
  p.getName() = "FullName" and
  p.getDeclaringType().getName() = "ZipArchiveEntry"
select p.getAnAccess()
```

A top-down solution starting from the `ZipArchiveEntry` class is 
```codeql
import csharp

from Class cls, PropertyAccess access, Property prop
where 
    cls.hasName("ZipArchiveEntry") and 
    prop = cls.getProperty("FullName") and
    access = prop.getAnAccess()
select cls, access
```

</details>
    
### Finding file writes and their destination paths

Let us now look at the second part of our problem: identifying the **sink**(s) by finding destination paths used in calls to a method named `ExtractToFile`.

Write a query to find calls to any method named `ExtractToFile`, and report the path argument. The C# code sample is:

```cs
entry.ExtractToFile(extractPath);
```

<details>
<summary>Hint</summary>

- Useful classes: `MethodCall`, a subclass of `Call`, with all of `Call`'s predicates; `Method`, a handle on all methods defined in the C# code.
- Useful predicates: `Call.getTarget()`, `Method.getName()`, `Call.getArgument(int)`
- The path argument of `ExtractToFile` is at index 1, not 0!  This is because it is an **extension method**, so the `entry` is at index 0.
(If it were a regular method call, it would have the path at index 0 and the entry as the result of `getQualifier()`.)
- Put another way: `entry.ExtractToFile(extractPath);` is really the call `ExtractToFile(entry, extractPath);`, so the index for `extractPath` is 1

</details>
<details>
<summary>Solution</summary>

The explicit solution can be written

```codeql
import csharp

from MethodCall method_call, Method method
where
    method_call.getTarget() = method and
    method.getName() = "ExtractToFile"
select method_call.getArgument(1)
```

and this can be shortened to 

```codeql
import csharp
from MethodCall c
where c.getTarget().getName() = "ExtractToFile"
select c.getArgument(1)
```

</details>

### Local data flow and taint tracking

So far we have separately identified some sources and sinks for the Zip Slip vulnerability. We would like to know whether the data from a source (in this case a zip file entry's path) can reach (or **flow** to) a sink (a path that is written to).

This requires the use of **data flow analysis** or **taint tracking analysis** to detect. Data flow analysis tells us how values flow _unchanged_ through the program. Taint tracking analysis is slightly more general: it tells us how values flow through the program and may undergo minor changes, while still influencing (or _tainting_) the places where they end up. For example:
```cs
sink = source;  // source -> sink: data and taint both flow
sink += source; // source -> sink: data does not flow, taint does flow
```

We will first use the C# local taint tracking library to identify whether this flow is possible within the scope of a single function.

(Question: Why do we use taint tracking here and not data flow?)

Combine the two queries you wrote previously to find sources (accesses to the `FullName` property) whose value eventually ends up in a sink (the path argument of a call to `ExtractToFile`).

This connects the source to the sink and solves the first two parts of our original problem:
1. A path comes from `ZipArchiveEntry.FullName` (a **source**).
1. The path is used to write a file (a **sink**).

Expand the hint to learn more on how to use the local taint tracking library. 

<details>
<summary>Hint</summary>

- The taint tracking library is in a module named `TaintTracking`, already included by `import csharp`.
- The data flow library is in a module named `DataFlow`, already included by `import csharp`.

- **Data flow nodes** are places in the code that may have a value. They are described by the class `DataFlow::Node` in the CodeQL library.
- `TaintTracking` also uses `DataFlow::Node`s.

- To get a data flow node from an expression `Expr e`, use `DataFlow::exprNode(e)`.
- To get an expression back from a data flow node `DataFlow::Node n`, use `n.asExpr()`.
- To test the flow of tainted information between data flow nodes `a` and `b`, use `TaintTracking::localTaint(a, b)`. This tells us that when the program is run, the value at `b` will be **derived** from the value at `a`.

Not needed here, but included for comparison:
- To test the exact flow of information between data flow nodes `a` and `b`, use `DataFlow::localFlow(a, b)`. This tells us that when the program is run, the two nodes in the program will have the **same value**.


</details>
<details>
<summary>Solution</summary>

There are many ways to write this query, mostly depending on whether you use `asExpr()` or `exprNode()`.  Here is a concise version of the query:

```codeql
import csharp

from Property p, MethodCall c
where
    // source
    p.getName() = "FullName" and
    p.getDeclaringType().getName() = "ZipArchiveEntry" and
    // sink
    c.getTarget().getName() = "ExtractToFile" and
    // path
    TaintTracking::localTaint(DataFlow::exprNode(p.getAnAccess()),
        DataFlow::exprNode(c.getArgument(1)))
select c.getArgument(1)
```


The following form will help us expand it later into a nicely-formatted global data flow query. The `/** @kind problem */` metadata at the top allows us to view nicely-formatted alert messages.

```codeql
/** @kind problem */
import csharp

from DataFlow::Node source, DataFlow::Node sink, MethodCall c,
  Property p
where
  // source
  p.getName() = "FullName" and
  p.getDeclaringType().getName() = "ZipArchiveEntry" and
  source.asExpr() = p.getAnAccess() and
  // sink
  c.getTarget().getName() = "ExtractToFile" and
  sink.asExpr() = c.getArgument(1) and
  // path
  TaintTracking::localTaint(source, sink)
select sink, "Zip Slip from $@.", source, "this source"
```
</details>
    
### Global data flow and taint tracking

Using local taint tracking analysis helped us find the vulnerability in PowerShell.

Recall that **local** (or “intra-procedural”) data flow models the flow of information within one function. These flow paths are feasible to compute for all functions in a database of source code.

However, our query so far will fail to catch vulnerabilities where the source and sink are in different functions.

**Global** (“inter-procedural”) data flow models flow across function calls. This is much more powerful. However, it is not feasible to compute this for all functions in a database: there are exponentially many paths.

For global data flow (and taint tracking), we must therefore provided restrictions to ensure the problem is tractable. Typically, this involves specifying the **source** and **sink**, and looking only for flow paths between them.

The CodeQL libraries `DataFlow` and `TaintTracking` provide a framework for describing and solving global data flow and taint tracking problems.

We'll look at global taint tracking here.  The framework's approach consists of three parts: 

1. Create a subclass of `TaintTracking::Configuration` following this template:
    ```codeql
    class Config extends TaintTracking::Configuration {
      Config() { this = "some unique identifier" }
      override predicate isSource(DataFlow::Node source) { … }
      override predicate isSink(DataFlow::Node sink) { … }
    }
    ```
1. Fill in the `isSource` and `isSink` predicates in the template to describe which data flow nodes are considered sources and which nodes are considered sinks.
1. Use `Config.hasFlow(source, sink)` in your query to find inter-procedural paths from sources to sinks.

Rewrite your previous query to use the global taint tracking library, so that it can find Zip Slip vulnerabilities where the source and sink may be in different functions. Look at the **Hint** for a suggestion on how to use the above template.

<details>
<summary>Hint</summary>

- Your query could look like this:
    ```codeql
    /** @kind problem */
    import csharp

    class ZipSlipConfig extends TaintTracking::Configuration {
      ZipSlipConfig() { this = "ZipSlipConfig" }
      override predicate isSource(DataFlow::Node source) { /* TBD */ }
      override predicate isSink(DataFlow::Node sink) { /* TBD */ }
    }

    from DataFlow::Node source, DataFlow::Node sink, ZipSlipConfig cfg
    where cfg.hasFlow(source, sink)
    select sink, "Zip Slip from $@.", source, "this source"
    ```

- Use the `exists` keyword to declare temporary variables, just like you did in the `from` clause of your previous queries. The syntax is `exists(TypeName varName | condition)`.

- Use the previous queries' `where` clauses in the body of the `isSource` and `isSink` predicates 

- Use the previous queries' `from` clauses in the `exists` variable declarations

</details>

<details>
<summary>Solution</summary>

```codeql
/** @kind problem */
import csharp

class ZipSlipConfig extends TaintTracking::Configuration {
  ZipSlipConfig() { this = "ZipSlipConfig" }
  override predicate isSource(DataFlow::Node source) {
    exists(Property p |
      p.getName() = "FullName" and
      p.getDeclaringType().getName() = "ZipArchiveEntry" and
      source.asExpr() = p.getAnAccess()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().getName() = "ExtractToFile" and
      sink.asExpr() = mc.getArgument(1)
    )
  }
}

from DataFlow::Node source, DataFlow::Node sink, ZipSlipConfig cfg
where cfg.hasFlow(source, sink)
select sink, "Zip Slip from $@.", source, "this source"
```
</details>

### Creating path queries and viewing path alerts

Our query identifies the pairs of sources and sinks, where tainted data may flow between them. We can modify the output format of our query so that it also produces the code paths through which data flows.

The VS Code extension will then display those paths in the `alerts` table of the results view.

Expand below for more details, and run your modified query.

<details>
<summary>Changes</summary>

- Change the query's `kind` in the metadata section at the top:
    ```codeql
    /** @kind problem */
    ```
    becomes
    ```codeql
    /** @kind path-problem */
    ```
- Add the following import statement to include the flow path edges in the output:
    ```codeql
    import DataFlow::PathGraph
    ```
- Change the `from` clause:
    ```codeql
    from DataFlow::Node source, DataFlow::Node sink, ...
    ```
    becomes
    ```codeql
    from DataFlow::PathNode source, DataFlow::PathNode sink, ...
    ```
- Change the `where` clause to include the flow path and accept the modified node types:
    ```codeql
    where cfg.hasFlow(source, sink)
    ```
    becomes
    ```codeql
    where cfg.hasFlowPath(source, sink)
    ```
- Change the `select` clause to record the source-sink pair:
    ```codeql
    select sink, "Zip Slip from $@.", source, "this source"
    ```
    becomes
    ```codeql
    select sink, source, sink, "Zip Slip from $@.", source, "this source"
    ```
</details>

<details>
<summary>Solution</summary>

```codeql
/** @kind path-problem */
import csharp
import DataFlow::PathGraph

class ZipSlipConfig extends TaintTracking::Configuration {
  ZipSlipConfig() { this = "ZipSlipConfig" }
  override predicate isSource(DataFlow::Node source) {
    exists(Property p |
      p.getName() = "FullName" and
      p.getDeclaringType().getName() = "ZipArchiveEntry" and
      source.asExpr() = p.getAnAccess()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().getName() = "ExtractToFile" and
      sink.asExpr() = mc.getArgument(1)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, ZipSlipConfig cfg
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Zip Slip from $@.", source, "this source"
```

</details>

### Adding sanitizers

The third condition for a vulnerability in this situation is:

3. There is no validation that the resulting path remains within the target folder  (no **sanitizer**).

For example, flows that go via `Path.GetFileName` are not interesting for Zip Slip, as this method returns only the filename, not the full path.

When using local data flow analysis, it is hard to define a sanitizer that may appear anywhere along the flow path.

The global data flow API makes this easier.
The `predicate isSanitizer(DataFlow::Node sanitizer)` on the `TaintTracking::Configuration` class allows us to prevent flow through particular nodes in the data flow graph.

(If you are using `DataFlow::Configuration`, this predicate is called `isBarrier` instead.)

Add a sanitizer to your query, so that it stops tracking tainted flow at calls to `System.IO.Path.GetFileName()`.

<details>
<summary>Hint</summary>

- The class `MethodCall` and the predicates `getTarget()` and `hasQualifiedName(..., ...)` will be useful.

- Here, we stop at the call itself, not at an argument to it.

- Follow this template to add a sanitizer predicate:
    ```codeql
    class ZipSlipConfig extends TaintTracking::Configuration {
      …
      override predicate isSanitizer(DataFlow::Node nd) {
        /* TODO */
      }
    }
    ```

</details>
<details>
<summary>Solution</summary>
    
```codeql
class ZipSlipConfig extends TaintTracking::Configuration {
  …
  override predicate isSanitizer(DataFlow::Node nd) {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Path", "GetFileName") and
      nd.asExpr() = mc
    )
  }
}
```
</details>

**Note:** We could add more sanitizers to match the example at the start of this document: guard conditions of the form `if(Path.GetFullPath(extractPath).StartsWith(destination))` will ensure that `extractPath` is safe within a block. This can be done with the `Guards` library, but is beyond the scope of this workshop.

### Adding additional taint steps

We will not require this technique in the PowerShell example, but it may be useful for other queries.

Sometimes the data flow or taint tracking analysis will not be aware that data may flow through a particular code pattern or function call. It is conservative by default, to keep results precise.

We can add additional problem-specific steps if necessary, by implementing the `isAdditionalTaintStep` predicate on our `TaintTracking::Configuration` subclass.

```codeql
class ZipSlipConfig extends TaintTracking::Configuration {
  …
  // this will add flow from node1 to node2
  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    /* TODO */
  }
}
```

(If you are using `DataFlow::Configuration`, this predicate is called `isAdditionalFlowStep` instead.)


## Acknowledgements

The initial version of this workshop was written by @calumgrant and developed further for presentation by @lcartey.  This tutorial version was written by @adityasharad and @hohn.
