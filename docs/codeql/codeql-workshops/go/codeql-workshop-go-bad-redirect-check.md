# CodeQL workshop for Go: Bad redirect check in OAuth2 Proxy

**Link to this document**: https://git.io/TODO
- Analyzed language: Go
- Difficulty level: 2/3

## Problem statement

Open redirects are a form of security vulnerability where a web page accepts a URL as input and then redirects to the given URL. An attacker may send a malicious input URL which the web application will redirect to, using this mechanism to redirect the user to an untrusted domain or steal authentication information like access tokens. You can read more about this vulnerability on [OWASP](https://www.owasp.org/index.php/Top_10_2013-A10-Unvalidated_Redirects_and_Forwards) or in [this blog post](https://blog.detectify.com/2019/05/16/the-real-impact-of-an-open-redirect/).

It is particularly important to safeguard against malicious redirect URLs in code that uses OAuth to authenticate users. Such applications usually implement an "OAuth flow", as follows. The application first redirects to a known external provider where they log in, sending along a redirect URL that would bring them back to the original application. When the user has logged in, the external provider uses this URL to redirect the user back to the original application, supplying authentication information (like an access code) as part of the URL or request. The application can use this information to access the user's account or verify their status. 

If such an application has an open redirect vulnerability, then an attacker might craft an OAuth request URL that sends the user first to the external provider to log in, then redirects them (as usual) back to the web application, but then redirects them (dangerously!) to the attacker's website, along with the authentication information from the provider's response.

[OAuth2 Proxy](https://github.com/oauth2-proxy/oauth2-proxy) is an open-source reverse proxy written in Go, which enables users to log in using a number of external providers via OAuth.

This [GitHub Security Advisory](https://github.com/oauth2-proxy/oauth2-proxy/security/advisories/GHSA-qqxw-m5fj-f7gv) shows an open redirect vulnerability that was identified and [fixed](https://github.com/oauth2-proxy/oauth2-proxy/commit/0198dd6e9378405c432810e190288d796da46e4d) in the proxy code. The code checked redirect strings supplied in incoming requests for some dangerous patterns that might redirect to an attacker's domain, but did not check all such patterns.

In particular, a redirect string that starts with `//` or `/\`, e.g. `https://application-domain.com?redirect=//evil.com` or `https://application-domain.com?redirect=/\evil.com`, allows redirection to an external domain. 
The code checked that the string might start with `/`, and then checked it against `//`, but failed to check it against `/\`.

The refined version of this query is in the open-source CodeQL repository for Go analysis. You can [see the query here](https://github.com/github/codeql-go/blob/master/ql/src/Security/CWE-601/BadRedirectCheck.ql).

In this workshop, we will use CodeQL to analyze the source code of OAuth2 Proxy, taken from before the vulnerability was patched, and identify the same vulnerability.

What does this vulnerability look like in Go code? Consider the following:

```go
redirect = req.Header.Get("X-Redirect")
...
if (strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//"):
	valid = true
```

This obtains a redirect from a request header and checks the value for a prefix of `//`, but not for `/\`.

To summarize the problem, there is a potential security vulnerability when:
1. A string or URL comes from a user-controlled **source**.
1. The string is prefix-checked against `/` but not both `//` and `/\`, suggesting it will eventually be used as a redirect (a **sink**).

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on OAuth2 Proxy offline, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download [this CodeQL database built from the OAuth2 Proxy
   code](https://drive.google.com/file/d/1pACKgqpCASizZn8Pi3ZQOm1ojMmpaEhy/view?usp=sharing) (link accessible only within GitHub).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Run the example query: open `codeql-custom-queries-go/example.ql` from the Explorer view, right-click in the editor, and click **CodeQL: Run Query**.
1. Create a new file, name it `BadRedirectCheck.ql`, and save it under `codeql-custom-queries-go`.

<!--
### Writing queries in the browser
To run CodeQL queries on OAuth2 Proxy online, follow these steps:
1. Create an account on LGTM.com if you haven't already. You can log in via OAuth using your Google or GitHub account.
1. [Start querying the OAuth2 Proxy project](https://lgtm.com/query/project:1511105882117/lang:go/).
    - Alternative: Visit the [OAuth2 Proxy project page](https://lgtm.com/projects/g/oauth2-proxy/oauth2-proxy) and click **Query this project**.

LGTM.com will have the latest version of the codebase, not the vulnerable version used in this workshop.
-->

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for Go](https://help.semmle.com/QL/learn-ql/go/ql-for-go.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)
- [CodeQL library for Go](https://help.semmle.com/qldoc/go)
- [CodeQL query repository (all languages except Go)](https://github.com/Semmle/ql)
- [CodeQL query repository (Go)](https://github.com/github/codeql-go)

## Challenge
The challenge is split into several steps. You can write one query per step, or work with a single query that you refine at each step.

Each step has a **Hint** that describe useful classes and predicates in the CodeQL standard libraries for Go and keywords in CodeQL. You can explore these in your IDE using the autocomplete suggestions and jump-to-definition command.

Each step has a **Solution** that indicates one possible answer. 

### Find function calls

Write a query to find all function calls in the source code.

<details>
<summary>Hint</summary>

- A function call is called a `CallExpr` in the CodeQL Go library.
- Declare variables and their types in the `from` section.
- Use the `select` section to describe what to output as the result of your query.
</details>
<details>
<summary>Solution</summary>

```codeql
import go
from CallExpr call
select call
```

</details>

### Find calls to `HasPrefix`

Modify your query to find all calls to a function named `HasPrefix` in the source code.

<details>
<summary>Hint</summary>

- Add a `where` clause, and use it to describe how to restrict the results of your query.
- The predicate `CallExpr.getTarget()` gives you the `Function` that is the target of the call.
- Many classes, such as `Function`, have a predicate called `getName()`.
- Use the equality operator `=` to assert that two values are the same.
</details>
<details>
<summary>Solution</summary>

```codeql
import go
from CallExpr call
where call.getTarget().getName() = "HasPrefix"
select call
```

</details>

### Find the argument that gets checked by calls to `HasPrefix`

`HasPrefix` checks that a given string argument begins with a given prefix string.
Modify your query to identify the argument of those calls to `HasPrefix` that is being checked.

<details>
<summary>Hint</summary>

- The predicate `CallExpr.getArgument(int i)` gives the argument expression at a particular (0-based) index.
- You may wish to add another variable `Expr checked` to the `from` section of your query.
- You can change the `select` section of your query to output a row of multiple values, separated by commas.
- The `and` keyword allows you to add conditions that must hold. Use this in the `where` section of your query.
</details>
<details>
<summary>Solution</summary>

```codeql
import go
from CallExpr call, Expr checked
where call.getTarget().getName() = "HasPrefix" and
checked = call.getArgument(0)
select call, checked
```

A compact alternative:
```codeql
import go
from CallExpr call
where call.getTarget().getName() = "HasPrefix"
select call, call.getArgument(0)
```

We'll use the first version as we continue below.

</details>

### Find the prefix string being checked against

`HasPrefix` checks that a given string argument begins with a given prefix string.
Modify your query to identify the string value that is being checked against by the calls to `HasPrefix` that you found earlier.

<details>
<summary>Hint</summary>

- Recall the predicate `CallExpr.getArgument(int i)` gives the argument expression at a particular (0-based) index.
- If an expression is a constant string in the source code, use `Expr.getStringValue()` to convert it into the CodeQL `string` type.
</details>
<details>
<summary>Solution</summary>

```codeql
from CallExpr call, Expr checked, string prefix
where
  call.getTarget().getName() = "HasPrefix" and
  checked = call.getArgument(0) and
  prefix = call.getArgument(1).getStringValue()
select call, checked, prefix
```

</details>

### Write a class to describe `HasPrefix` calls

We are interested in a specific set of function calls: the calls to `HasPrefix`.
It may be useful to describe this as a CodeQL `class`.

Add a class to your query that describes these calls. Modify your query clause to use this new class.

<details>
<summary>Hint</summary>

- Basic syntax for a declaring a class:

    ```codeql
    class <ClassName> extends <supertype> {
      <ClassName>() {
        // characteristic predicate: describe what it means for `this` to be a member of the class
      }
    }
    ```
- The `this` variable in the characteristic predicate refers to the value we are describing within the class.
- Use the logic from your `where` clause in the characteristic predicate of the class.
</details>
<details>
<summary>Solution</summary>

```codeql
import go

class HasPrefixCall extends CallExpr {
  HasPrefixCall() {
    this.getTarget().getName() = "HasPrefix"
  }
}

from HasPrefixCall call, Expr checked, string prefix
where
  checked = call.getArgument(0) and
  prefix = call.getArgument(1).getStringValue()
select call, checked, prefix
```

</details>

### Use an existing class from the standard library to describe `HasPrefix` calls

What if there are other standard ways to perform a string prefix check in Go code? Our class would not detect all of those! Perhaps the CodeQL Go library already has some CodeQL code to describe this pattern?

A search for the name `HasPrefix` in your VS Code workspace will show results within a CodeQL library named `StringOps.qll` under `codeql-go`.

The `StringOps` library models string operations in Go, and provides CodeQL classes for each modelled operation. Rewrite your query using the class `StringOps::HasPrefix` from the `StringOps` library instead of your custom class.

<details>
<summary>Hint</summary>

- The syntax `StringOps::HasPrefix` means "the type `HasPrefix` from the `module StringOps`".
- Notice that `StringOps::HasPrefix` extends the class `DataFlow::Node`, not `CallExpr` or `Expr`. A **data flow node** describes a part of the source program that may have a value, and lets us do more complex reasoning about this value.
- You will notice errors when you try to call `getArgument(i)` on a value of type `StringOps::HasPrefix`. Look at the class definition to see the **member predicates** that are defined on the class. One of these will give you the checked string, and the other will give you the prefix substring.
- Each of the above predicates will return a  `DataFlow::Node`. It can be converted into an `Expr` using the predicate `asExpr()`.
</details>
<details>
<summary>Solution</summary>

```codeql
import go

from StringOps::HasPrefix call, DataFlow::Node checked, string prefix
where
  checked = call.getBaseString() and
  prefix = call.getSubstring().asExpr().getStringValue()
select call, checked, prefix
```

This finds all the `HasPrefix` calls we had before, and one more prefix check that uses `!=` instead of `HasPrefix`.

</details>

### Find a variable that is checked by `HasPrefix` calls

Looking at the results of the previous query, the string-valued node that is being checked is usually a reference to a Go variable.

Modify your query to also identify the variable that is being read and checked by `HasPrefix`.

<details>
<summary>Hint</summary>

- A Go variable is a `Variable` in the CodeQL library. This is the **definition** of the variable.
- There may be many data flow nodes that **access** the value of the variable, which you can find using `Variable.getARead()`.
</details>
<details>
<summary>Solution</summary>

```codeql
import go

from StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix
where
  checked = call.getBaseString() and
  checked = v.getARead() and
  prefix = call.getSubstring().asExpr().getStringValue()
select call, checked, v, prefix
```

This finds fewer `HasPrefix` calls than before, since not all of them directly read from a variable.

</details>

### Factor common logic out into a predicate

So far we have found many calls to `HasPrefix` that check variables against different string prefixes: `'/'`, `'//'`, `'http:'`, etc.

We are looking for cases where the variable is checked against some prefixes but not others. This means we will have to reuse the logic of the previous query later, but with different string prefixes.

It is useful to write a `predicate` to describe reusable logic, just like you would write a function/method in a regular programming language.

Convert the `from` and `where` clauses of your previous query into a `predicate prefixCheck(...)`. This predicate should describe a call to `HasPrefix`, the value it checks, the variable that is read when the check happens, and the string prefix that is checked against.
Use it in the `where` clause.

<details>
<summary>Hint</summary>

- Predicates take variable declarations, just like the `from` clause:
    ```codeql
    predicate prefixCheck(StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix) { ... }
    ```
- To evaluate only a single predicate for debugging, right-click on the predicate name, then choose **CodeQL: Quick Evaluation** from the context menu. (Make sure your file has no compile errors first.)

</details>
<details>
<summary>Solution</summary>

```codeql
import go

predicate prefixCheck(StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix) {
  call.getBaseString() = checked and
  checked = v.getARead() and
  call.getSubstring().asExpr().getStringValue() = prefix
}

from StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix
where prefixCheck(call, checked, v, prefix)
select call, checked, v, prefix
```

</details>

### Find checks for a prefix of `/`

Code that checks URL prefixes usually has a check for `/`.

Write another predicate `insufficientPrefixChecks`. It should find a `HasPrefix` call that checks against the prefix `/`, the `DataFlow::Node` for the base string that is checked, and the checked variable. Modify your query to use it.

<details>
<summary>Hint</summary>

- Call the predicate you wrote before, but pass a constant string as the prefix parameter.
- Drop any variables in your query that you are no longer using.

</details>
<details>
<summary>Solution</summary>

```codeql
import go

predicate prefixCheck(StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix) {
  call.getBaseString() = checked and
  checked = v.getARead() and
  call.getSubstring().asExpr().getStringValue() = prefix
}

predicate insufficientPrefixChecks(StringOps::HasPrefix singleSlashCheck, DataFlow::Node checked, Variable v) {
  prefixCheck(singleSlashCheck, checked, v, "/")
}

from StringOps::HasPrefix call, DataFlow::Node checked, Variable v
where insufficientPrefixChecks(call, checked, v)
select call, checked, v
```

</details>

### See if checks for a dangerous prefix of `//` are missing

Redirect strings that start with `//` or `/\` are dangerous: they will be interpreted as absolute domains, not relative to the current domain.

So far we have found checks that a variable's value starts with `/`. Our query doesn't yet know whether the value is also checked against `//` or `/\`.

Let's start with `//`.

Modify your predicate `insufficientPrefixChecks`, so that it holds true if BOTH the following conditions hold true:
- there is a check against `/`
- there is no check against `//`

<details>
<summary>Hint</summary>

- The `not` keyword asserts that a condition does not hold.
- Call your `prefixCheck` predicate, but with different constant strings.
- Pass an `_` as the argument to a predicate call if you don't care what the value is, just that it exists.

</details>
<details>
<summary>Solution</summary>

```codeql
import go

predicate prefixCheck(StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix) {
  call.getBaseString() = checked and
  checked = v.getARead() and
  call.getSubstring().asExpr().getStringValue() = prefix
}

predicate insufficientPrefixChecks(StringOps::HasPrefix singleSlashCheck, DataFlow::Node checked, Variable v) {
  prefixCheck(singleSlashCheck, checked, v, "/") and
  not prefixCheck(_, _, v, "//")
}

from StringOps::HasPrefix call, Variable checked
where insufficientPrefixChecks(call, checked)
select call, checked
```

</details>

### See if checks for a dangerous prefix of `//` or `/\` are missing

The previous query found no results! That's because the code we were looking at correctly checked the string variable against both `/` and `//`.

However, `/\` is also dangerous for the same reason as `//`!

Modify your predicate `insufficientPrefixChecks`, so that it holds true if BOTH the following conditions hold true:
- there is a check against `/`
- there is no check against `//` OR there is no check against `/\`

<details>
<summary>Hint</summary>

- You will have to escape `/\` as `/\\`.
- The `or` keyword asserts that at least one of two conditions must hold true. Be sure to put this logic in parentheses, so it doesn't get confused with the `and`s in your query!

</details>
<details>
<summary>Solution</summary>

```codeql
import go

predicate prefixCheck(StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix) {
  call.getBaseString() = checked and
  checked = v.getARead() and
  call.getSubstring().asExpr().getStringValue() = prefix
}

predicate insufficientPrefixChecks(StringOps::HasPrefix singleSlashCheck, DataFlow::Node checked, Variable v) {
  prefixCheck(singleSlashCheck, checked, v, "/") and
  (
    not prefixCheck(_, _, v, "//") or
    not prefixCheck(_, _, v, "/\\")
  )
}

from StringOps::HasPrefix call, DataFlow::Node checked, Variable v
where insufficientPrefixChecks(call, checked, v)
select call, checked, v
```

This tells us that there is a vulnerability in this source code, where redirect strings may start with `/` but are not sufficiently checked for all dangerous prefixes.

</details>

### Data flow and taint tracking

We now know that this code fails to correctly check a redirect string for all dangerous prefixes. To verify the vulnerability, we need to know if an attacker can control the value of this dangerous redirect string.

A value controlled by an attacker is an untrusted **source**, and the redirect string here is a **sink**. We would like to know whether there is path along which data can **flow** from a source to a sink when the program is run.

This requires the use of **data flow analysis** or **taint tracking analysis** to detect. Data flow analysis tells us how values flow _unchanged_ through the program. Taint tracking analysis is slightly more general: it tells us how values flow through the program and may undergo minor changes, while still influencing (or _tainting_) the places where they end up. For example:
```go
sink = source;  // source -> sink: data and taint both flow
sink += source; // source -> sink: data does not flow, taint does flow
```

Data flow and taint tracking analysis may be **local** (or “intra-procedural”), which means they model the flow of information within each function separately, or **global** (“inter-procedural”), which means they model the flow of information even across function calls.

Global data flow is much more powerful. However, it is not feasible to compute this for all functions in a database: there are exponentially many paths through the code.

For global data flow (and taint tracking), we must therefore provide restrictions to ensure the problem is tractable. Typically, this involves specifying the **source** and **sink**, and looking only for flow paths between them.

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
1. Use `Config.hasFlowPath(source, sink)` in your query to find inter-procedural paths from sources to sinks.

Look at the **Hint** for a suggestion on how to use the above template.

Run your query and look through the flow paths shown in the IDE's result viewer.

<details>
<summary>Hint</summary>

- Your query could look like this:
    ```codeql
    /** @kind path-problem */
    import go
    import DataFlow::PathGraph

    class BadRedirectConfig extends TaintTracking::Configuration {
      BadRedirectConfig() { this = "BadRedirectConfig" }
      override predicate isSource(DataFlow::Node source) {
        source instanceof UntrustedFlowSource
      }
      override predicate isSink(DataFlow::Node sink) {
        /* TODO */
      }
    }

    from DataFlow::PathNode source, DataFlow::PathNode sink, BadRedirectConfig cfg
    where cfg.hasFlowPath(source, sink)
    select sink, source, sink, "Bad redirect check on untrusted data from $@", source, "this source"
    ```

- The source is provided for you here. `UntrustedFlowSource` describes a known set of APIs that accept data from an external source.
- Use the `exists` keyword to declare temporary variables, just like you did in the `from` clause of your previous queries. The syntax is `exists(TypeName varName | condition)`.
- Use the `insufficientPrefixChecks` predicate you wrote previously to fill in the body of the `isSink` predicate. The checked node should be the sink.
- The `/** @kind path-problem */` metadata, the extra `import`, and the modified `select` clause allow us to view nicely-formatted alert messages with flow paths attached.

</details>

<details>
<summary>Solution</summary>

```codeql
/** @kind path-problem */
import go
import DataFlow::PathGraph

predicate prefixCheck(StringOps::HasPrefix call, DataFlow::Node checked, Variable v, string prefix) {
  call.getBaseString() = checked and
  checked = v.getARead() and
  call.getSubstring().asExpr().getStringValue() = prefix
}

predicate insufficientPrefixChecks(StringOps::HasPrefix singleSlashCheck, DataFlow::Node checked, Variable v) {
  prefixCheck(singleSlashCheck, checked, v, "/") and
  (
    not prefixCheck(_, _, v, "//") or
    not prefixCheck(_, _, v, "/\\")
  )
}

class Config extends TaintTracking::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    insufficientPrefixChecks(_, sink, _)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Config c
where c.hasFlowPath(source, sink)
select sink, source, sink, "Untrusted value reaches insufficient redirect check"
```
</details>

### Acknowledgements
@sauyon from the CodeQL Go team identified and reported the original vulnerability in OAuth2 Proxy, and wrote [the production version of this query](https://github.com/github/codeql-go/blob/master/ql/src/Security/CWE-601/BadRedirectCheck.ql). @johnlugton delivered the first tutorial based on this query, @adityasharad adapted it into this workshop, and @lcartey provided valuable feedback.
