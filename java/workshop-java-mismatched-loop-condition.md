# CodeQL workshop for Java: Finding mismatched loop conditions

- Analyzed language: Java
- Difficulty level: 1/3

## Problem statement

In this challenge, we will use CodeQL to analyze the source code of Apache Hive, an open-source project written mainly in Java, and find logical errors in loops.

Here are two common patterns seen in loops that use an integer-valued index variable:
   - count **up** and provide an **upper limit** on the loop variable, e.g. `for(int i = start; i < end; i++)`
   - count **down** and provide a **lower limit** on the loop variable, e.g. `for(int i = start; i >= end; i--)`

Mixing up these patterns is usually a mistake. For example, a loop that counts **up** but provides a **lower limit**, or a loop that counts **down** but provides an **upper limit**, indicates a programming error. In these situations there is a mismatch between the loop condition (which tells the loop when to stop) and the loop update expression (which tells the loop what to do before the next iteration).  Such a loop may not run at all, or it may run indefinitely.

We will begin by using CodeQL to identify loops and their component expressions. Then we will narrow down our search to loops that are written incorrectly.
If you follow the challenge all the way to the end, then you will find code in Apache Hive that can never be executed.

## Setup instructions

### Writing queries on your local machine (recommended)

To run CodeQL queries on Hive offline, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Create an account on LGTM.com if you haven't already. You can log in via OAuth using your Google or GitHub account.
1. Visit the [database downloads page for Apache Hive on LGTM.com](https://lgtm.com/projects/g/apache/hive/ci/#ql).
1. Download the latest database for Java.
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `MismatchedLoopCondition.ql`, save it under `codeql-custom-queries-java`.

### Writing queries in the browser

To run CodeQL queries on Hive online, follow these steps:

1. Create an account on LGTM.com if you haven't already. You can log in via OAuth using your Google or GitHub account.
1. [Start querying the Apache Hive project](https://lgtm.com/query/project:41710041/lang:java).
    - Alternative: Visit the [Apache Hive project page](https://lgtm.com/projects/g/apache/hive) and click **Query this project**.


## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for Java](https://help.semmle.com/QL/learn-ql/java/ql-for-java.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode)

## Challenge
The challenge is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describe useful classes and predicates in the CodeQL standard libraries for Java. You can explore these in your IDE using the autocomplete suggestions and jump-to-definition command.

1. Find all `for`-loop statements.
    <details>
    <summary>Hint</summary>

    A `for`-loop is called a `ForStmt` in the CodeQL Java library.
    </details>

1. Identify the comparison and the update expressions of these `for`-loops.
    <details>
    <summary>Hint</summary>

    `Expr`, `ForStmt.getCondition()`, `ForStmt.getAnUpdate()`, `and`, `where`
    </details>

1. Filter your results to only those loops that use a unary update expression (`i++`, `i--`, `++i`, or `--i`).
    <details>
    <summary>Hint</summary>

    `instanceof`, `UnaryAssignExpr`
    </details>

1. Identify the loop variable. This variable should be accessed in both the comparison expression (as an operand) and in the unary update expression. For example: `for(int i = 0; i < limit; i++)`
    <details>
    <summary>Hint</summary>

    `Variable`, `Variable.getAnAccess()`, `ComparisonExpr`, `ComparisonExpr.getAnOperand()`, `UnaryAssignExpr.getExpr()`
    </details>

1. Most `for`-loops using an index behave in one of two ways:
   - count **up** and provide an **upper limit** on the loop variable, e.g. `for(int i = start; i < end; i++)`
   - count **down** and provide a **lower limit** on the loop variable, e.g. `for(int i = start; i >= end; i--)`

    Take your query from the previous step, and modify it to find only those loops that count **up**. (Don't worry about the limit for now.)
    <details>
    <summary>Hint</summary>

    `PreIncExpr`, `PostIncExpr`, `or`
    </details>

1. Take your query from the previous step, and modify it to find only those loops that provide a **lower limit** on the loop variable. These loops are buggy, because they count **up**, so they should have an **upper limit**! This should find 4 results in Hive.
    <details>
    <summary>Hint</summary>

    `ComparisonExpr.getGreaterOperand()`, `Variable.getAnAccess()`
    </details>

1. (Bonus) Make your query more general. Modify your query from the previous step so that it handles **both** mismatched patterns:
   - counting **up** with a **lower limit** on the loop variable
   - counting **down** with an **upper limit** on the loop variable

   You will probably not find any more results in Hive (beyond what you found in the previous step), but you can try running your query on other Java projects on LGTM.com to see if they make similar mistakes.

   How could you make your query even more general, for example by handling `while` loops?
   The fourth result from the previous step appears to be a false positive (because there are two updates to the loop variable). How could you refine your query to avoid flagging this?

    <details>
    <summary>Hint</summary>

    `PreIncExpr`, `PostIncExpr`, `PreDecExpr`, `PostDecExpr`, `or`, `ComparisonExpr.getLesserOperand()`, `ComparisonExpr.getGreaterOperand()`, `Variable.getAnAccess()`
    </details>

## Acknowledgements

The first version of the challenge was devised by @jbj for a workshop delivered by Semmle staff at PLDI 2018.