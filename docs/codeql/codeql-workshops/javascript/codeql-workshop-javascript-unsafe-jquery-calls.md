# CodeQL workshop for JavaScript: Finding unsafe calls to the jQuery `$` function

- Analyzed language: JavaScript
- Difficulty level: 1/3

## Problem statement

jQuery is an extremely popular, but old, open source JavaScript library designed to simplify things like HTML document traversal and manipulation, event handling, animation, and Ajax. The jQuery library supports modular plugins to extend its capabilities. Bootstrap is another popular JavaScript library, which has used jQuery's plugin mechanism extensively. However, the jQuery plugins inside Bootstrap used to be implemented in an unsafe way that could make the users of Bootstrap vulnerable to cross-site scripting (XSS) attacks. This is when an attacker uses a web application to send malicious code, generally in the form of a browser side script, to a different end user.

Four such vulnerabilities in Bootstrap jQuery plugins were fixed in [this pull request](https://github.com/twbs/bootstrap/pull/27047), and each was assigned a CVE.

The core mistake in these plugins was the use of the omnipotent jQuery `$` function to process the options that were passed to the plugin. For example, consider the following snippet from a simple jQuery plugin:

```javascript
let text = $(options.textSrcSelector).text();
```

This plugin decides which HTML element to read text from by evaluating `options.textSrcSelector` as a CSS-selector, or that is the intention at least. The problem in this example is that `$(options.textSrcSelector)` will execute JavaScript code instead if the value of `options.textSrcSelector` is a string like `"<img src=x onerror=alert(1)>".` 

In security terminology, jQuery plugin options are a **source** of user input, and the argument of `$` is an XSS **sink**.

The pull request linked above shows one approach to making such plugins safer: use a more specialized, safer function like `$(document).find` instead of `$`.
```javascript
let text = $(document).find(options.textSrcSelector).text();
```

In this challenge, we will use CodeQL to analyze the source code of Bootstrap, taken from before these vulnerabilities were patched, and identify the vulnerabilities.

## Setup instructions

### Writing queries on your local machine (recommended)

To run CodeQL queries on Bootstrap offline, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/). Full setup instructions are [here](https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/).
1. [Set up the starter workspace](https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/#starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Create an account on LGTM.com if you haven't already. You can log in via OAuth using your Google or GitHub account.
1. Visit the [database downloads page for the vulnerable version of Bootstrap on LGTM.com](https://lgtm.com/projects/g/esbena/bootstrap-pre-27047/ci/#ql).
1. Download the latest database for JavaScript.
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `UnsafeDollarCall.ql`, save it under `codeql-custom-queries-javascript`.

### Writing queries in the browser

To run CodeQL queries on Bootstrap online, follow these steps:

1. Create an account on LGTM.com if you haven't already. You can log in via OAuth using your Google or GitHub account.
1. [Start querying the Bootstrap project](https://lgtm.com/query/project:1510734246425/lang:javascript/).
    - Alternative: Visit the [vulnerable Bootstrap project page](https://lgtm.com/projects/g/esbena/bootstrap-pre-27047) and click **Query this project**.


## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://codeql.github.com/docs/codeql-overview/)
- [Learning CodeQL for JavaScript](https://codeql.github.com/docs/codeql-language-guides/codeql-for-javascript/)
- [Using the CodeQL extension for VS Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/)

## Challenge
The challenge is split into several steps. You can write one query per step, or work with a single query that you refine at each step.

Each step has a **Hint** that describe useful classes and predicates in the CodeQL standard libraries for JavaScript and keywords in CodeQL. You can explore these in your IDE using the autocomplete suggestions and jump-to-definition command.

Each step has a **Solution** that indicates one possible answer. Note that all queries will need to begin with `import javascript`, but for simplicity this may be omitted below.

### Finding calls to the jQuery `$` function

1. Find all function call expressions.
    <details>
    <summary>Hint</summary>

    A function call is called a `CallExpr` in the CodeQL JavaScript library.
    </details>
     <details>
    <summary>Solution</summary>
    
    ```
    from CallExpr dollarCall
    select dollarCall
    ```
    </details>

1. Identify the expression that is used as the first argument for each call.
    <details>
    <summary>Hint</summary>

    `Expr`, `CallExpr.getArgument(int)`, `and`, `where`
    </details>
    <details>
    <summary>Solution</summary>
    
    ```
    from CallExpr dollarCall, Expr dollarArg
    where dollarArg = dollarCall.getArgument(0)
    select dollarArg
    ```
    </details>

1. Filter your results to only those calls to a function named `$`.
    <details>
    <summary>Hint</summary>

    `CallExpr.getCalleeName()`
    </details><details>
    <summary>Solution</summary>
    
    ```
    from CallExpr dollarCall, Expr dollarArg
    where
      dollarArg = dollarCall.getArgument(0) and
      dollarCall.getCalleeName() = "$"
    select dollarArg
    ```
    </details>

### Finding accesses to jQuery plugin options
Consider creating a new query for these next few steps, or commenting out your earlier solutions and using the same file. We will use the earlier solutions again in the next section.

1. When a jQuery plugin option is accessed, the code generally looks like `something.options.optionName`. First, identify all accesses to a property named `options`.
    <details>
    <summary>Hint</summary>

    Property accesses are called `PropAccess` in the CodeQL JavaScript libraries. Use `PropAccess.getPropertyName()` to identify the property.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```
    from PropAccess optionsAccess
    where optionsAccess.getPropertyName() = "options"
    select optionsAccess
    ```
    </details>

1. Take your query from the previous step, and modify it to find chained property accesses of the form `something.options.optionName`.
    <details>
    <summary>Hint</summary>

    There are two property accesses here, with the second being made upon the result of the first. `PropAccess.getBase()` gives the object whose property is being accessed.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```
    from PropAccess optionsAccess, PropAccess nestedOptionAccess
    where
      optionsAccess.getPropertyName() = "options" and
      nestedOptionAccess.getBase() = optionsAccess
    select nestedOptionAccess
    ```
    </details>

### Putting it all together

1. Combine your queries from the two previous sections. Find chained property accesses of the form `something.options.optionName` that are used as the argument of calls to the jQuery `$` function.
    <details>
    <summary>Hint</summary>
    Declare all the variables you need in the `from` section, and use the `and` keyword to combine all your logical conditions.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```
    from CallExpr dollarCall, Expr dollarArg, PropAccess optionsAccess, PropAccess nestedOptionAccess
    where
      dollarCall.getArgument(0) = dollarArg and
      dollarCall.getCalleeName() = "$" and
      optionsAccess.getPropertyName() = "options" and
      nestedOptionAccess.getBase() = optionsAccess and
      dollarArg = nestedOptionAccess
    select dollarArg
    ```
    </details>

1. (Bonus) The solution to step 2 should result in a query with three alerts on the unpatched Bootstrap codebase, two of which are true positives that were fixed in the linked pull request. There are however additional vulnerabilities that are beyond the capabilities of a purely syntactic query such as the one we have written. For example, the access to the jQuery option (`something.options.optionName`) is not always used directly as the argument of the call to `$`: it might be assigned first to a local variable, which is then passed to `$`.

    The use of intermediate variables and nested expressions are typical source code examples that require use of **data flow analysis** to detect.

    To find one more variant of this vulnerability, try adjusting the query to use the JavaScript data flow library a tiny bit, instead of relying purely on the syntactic structure of the vulnerability. See the hint for more details.

    <details>
    <summary>Hint</summary>

    - If we have an AST node, such as an `Expr`, then [`flow()`](https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/predicate.AST$AST$ValueNode$flow.0.html) will convert it into a __data flow node__, which we can use to reason about the flow of information to/from this expression.
    - If we have a data flow node, then [`getALocalSource()`](https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/DataFlow.qll/predicate.DataFlow$DataFlow$Node$getALocalSource.0.html) will give us another data flow node in the same function whose value ends up in this node.
    - If we have a data flow node, then `asExpr()` will turn it back into an AST expression, if possible.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```
    from CallExpr dollarCall, Expr dollarArg, PropAccess optionsAccess, PropAccess nestedOptionAccess
    where
      dollarCall.getArgument(0) = dollarArg and
      dollarCall.getCalleeName() = "$" and
      optionsAccess.getPropertyName() = "options" and
      nestedOptionAccess.getBase() = optionsAccess and
      dollarArg.flow().getALocalSource().asExpr() = nestedOptionAccess
    select dollarArg, nestedOptionAccess
    ```
    </details>

## Acknowledgements

This is a reduced version of a Capture-the-Flag challenge devised by @esbena, available at https://securitylab.github.com/ctf/jquery. Try out the full version!
