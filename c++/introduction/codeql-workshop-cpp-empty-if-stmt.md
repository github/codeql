# CodeQL workshop for C/C++: Empty if statements

- Analyzed language: C/C++
- Difficulty level: 1/3

## Problem statement

In this workshop, we will be writing our first CodeQL query, which we will use to analyze the source code of [Exiv2](https://www.exiv2.org/), an open source C++ library to manage image metadata.

Redundant code is often an indication that the programmer has made a logical mistake. Consider this simple example:

```c
int write(int buf[], int size, int loc, int val) {
    if (loc >= size) {
       // return -1;
    }

    buf[loc] = val;

    return 0;
}
```
Here we have a C function which writes a value to a buffer. It includes a check that is intended to prevent the write overflowing the buffer, but the return statement within the condition has been commented out, leaving a redundant if statement and no bounds checking.

In this workshop we will explore the features of CodeQL by writing a query to identify redundant conditionals like this. We will use the example above as a _seed vulnerability_ for writing that query to help us find other instances ("variants") of the same class of vulnerability.

This workshops will teach you:
 - Basic query structure
 - QL types and variables
 - Logical conditions

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on Exiv2, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download the [Exiv2 database](http://downloads.lgtm.com/snapshots/cpp/exiv2/Exiv2_exiv2_b090f4d.zip).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `EmptyIf.ql`, save it under `codeql-custom-queries-cpp`.

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for C/C++](https://help.semmle.com/QL/learn-ql/cpp/ql-for-cpp.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)

## Workshop
The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describes useful classes and predicates in the CodeQL standard libraries for C/C++. You can explore these in your IDE using the autocomplete suggestions and jump-to-definition command.

The basic syntax of QL will look familiar to anyone who has used SQL. A query is defined by a _select_ clause, which specifies what the result of the query should be. For example:
```ql
import cpp

select "hello world"
```
This query simply returns the string "hello world".

More complicated queries look like this:
```ql
from /* ... variable declarations ... */
where /* ... logical formulas ... */
select /* ... expressions ... */
```
The `from` clause specifies some variables that will be used in the query. The `where` clause specifies some conditions on those variables in the form of logical formulas. The `select` clauses speciifes what the results should be, and can refer to variables defined in the `from` clause.

The `from` clause is defined as a series of variable declarations, where each declaration has a _type_ and a _name_. For example:
```ql
from IfStmt ifStmt
select ifStmt
```
We are declaring a variable with the name `ifStmt` and the type `IfStmt` (from the CodeQL standard library for analyzing C/C++). Variables represent a set of values, initially constrained by the type of the variable. Here, the variable `ifStmt` represents the set of all `if` statements in the C/C++ program, as we can see if we run the query.

To find empty if statements we will first need to define what it means for the if statement to be empty. If we consider the code sample again:
```c
    if (loc >= size) {
       // return -1;
    }
```
What we can see is that there is a _block_ (i.e. an area of code enclosed by `{` and `}`) which includes no executable code.

1. Write a new query to identify all blocks in the program.
    <details>
    <summary>Hint</summary>

    A block statement is represented by the standard library type `Block`.
    </details>
    <details>
    <summary>Solution</summary>

    ```ql
    from Block block
    select block
    ```
    </details>

QL is an _object-oriented_ language. One consequence of this is that "objects" can have "operations" associated with them. QL uses a "." notation to allow access to operations on a variable. For example:
```ql
from IfStmt ifStmt
select ifStmt, ifStmt.getThen()
```
This reports the "then" part of each if statement (i.e. the part that is executed if the conditional succeeds). If we run the query, we find that it now reports two columns, where the first column is if statements in the program, and the second column is the blocks associated with the "then" part of those if statements.

2. Update your query to report the number of statements within each block.
    <details>
    <summary>Hint</summary>

    `Block` has an operation called `getNumStmt()`.
    </details>
    <details>
    <summary>Solution</summary>

    ```ql
    from Block block
    select block, block.getNumStmt()
    ```
    </details>

We can apply further constraints to the variables by adding a `where` clause, and which specifies logical formula that describes additional conditions on the variables. 
For example:

```ql
from IfStmt ifStmt, Block block
where ifStmt.getThen() = block
select ifStmt, block
```
Here we have added another variable called `block`, and then added a condition (a "formula" in QL terms) to the `where` clause that states that the `block` is equal to the result of the `ifStmt.getThen()` operation. Note: the equals sign (`=`) here is _not_ an assignment - it is _declaring_ a condition on the variables that must be satisified for a result to be reported. Additional conditions can be provided by combining them with an `and`.

When we run this query, we again get two columns, with if statements and then parts, however we now get fewer results. This is because not all if statements have blocks as then parts. Consider:
```c
if (x)
  return 0;
```
This reveals a feature of QL - proscriptive typing. By specifying that the variable `block` has type "Block", we are actually asserting some logical conditions on that variable i.e. that it represents a block. In doing so, we have also limited the set of if statements to only those where the then part is associated with a block.

3. Update your query to report only blocks with `0` stmts.
    <details>
    <summary>Hint</summary>

    Add a `where` clause which states that the number of statements in the block is equal to `0`.
    </details>
    <details>
    <summary>Solution</summary>

    ```ql
    from Block block
    where block.getNumStmt() = 0
    select block
    ```
    </details>

4. Combine your query identifying "empty" blocks with the query identifying blocks associated with if statements, to report all empty if statements in the program.
    <details>
    <summary>Hint</summary>

    Add a new condition to the `where` clause using the logical connective `and`.
    </details>
    <details>
    <summary>Solution</summary>

    ```ql
    from IfStmt ifStmt, Block block
    where
      ifStmt.getThen() = block and
      block.getNumStmt() = 0
    select ifStmt, block
    ```
    </details>

Congratulations, you have now written your first CodeQL query that finds genuine bugs!

In order to use this with the rest of the CodeQL toolchain, we will need to make some final adjustments to the query to add metadata, to help the toolchain interpret and process the results.

<details>
<summary>Reveal</summary>

```ql
/**
 * @name Empty if statement
 * @kind problem
 * @id cpp/empty-if-statement
 */
import cpp

from IfStmt ifStmt, Block block
where
  ifStmt.getThen() = block and
  block.getNumStmt() = 0
select ifStmt, "Empty if statement"
```
</details>


5. _Optional homework_ Review the results. Are there any patterns which are causing false positives to appear? Can you adjust the query to reduce false positives?
