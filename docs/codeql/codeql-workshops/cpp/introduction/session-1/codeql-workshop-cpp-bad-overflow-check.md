# CodeQL workshop for C/C++: Bad overflow checks

- Analyzed language: C/C++
- Difficulty level: 1/3

## Problem statement

In this workshop, we will use CodeQL to analyze the source code of [ChakraCore](https://github.com/microsoft/ChakraCore), an open-source JavaScript engine created by Microsoft.

In C/C++ arithmetic operations can _overflow_ if the result of the operation is a number which is too large to be stored in the type. When an operation overflows, the value typically "wraps" around from the high end of the range to the low end. Developers sometimes exploit this property to write overflow checks like this:
```c
if (v + b < v)
    handle_error("overflow");
} else {
    result = v + b;
}
```
The intention is that if `v + b` overflows, it will wrap around to the start of the range of the type, but that it cannot wrap around beyond the value of `v`.

Where might this go wrong?

<details>
<summary>Answer</summary>
CPUs will generally prefer to perform arithmetic operations on 32-bit or larger integers, as architectures are optimized to perform these efficiently. The compiler therefore performs "integer promotion" for arguments to arithmetic operations that are smaller than 32-bits.

Unfortunately, this means that any arithmetic operations that occur on types smaller than 32 bits will not overflow as expected, because they have been calculated using a larger type.

The arguments of the following arithmetic operators undergo implicit conversions:
 * binary arithmetic * / % + -
 * relational operators < > <= >= == !=
 * binary bitwise operators & ^ |
 * the conditional operator ?:

See <a href="https://en.cppreference.com/w/c/language/conversion">https://en.cppreference.com/w/c/language/conversion</a> for more details.
</details>

Consider this example:
```c
uint16_t v = 65535;
uint16_t b = 1;
uint16_t result;
if (v + b < v) {
    handle_error("overflow");
} else {
    result = v + b;
}
```
What is the value of result?
<details>
<summary>Answer</summary>
Here's the example again, with the conversions made explicit:

```c
uint16_t v = 65535;
uint16_t b = 1;
uint16_t result;
if ((int)v + (int)b < (int)v) {
    handle_error("overflow");
} else {
    result = (uint16_t)((int)v + (int)b);
}
```

In this example the second branch is executed, even though there is a 16-bit overflow, and result is set to zero.

Explanation:

 * The two integer arguments to the addition, `v` and `b`, are promoted to 32-bit integers.
 * The comparison (`<`) is also an arithmetic operation, therefore it will also be completed on 32-bit integers.
 * This means that `v + b < v` will never be true, because v and b can hold at most 2<sup>16</sup>.
 * Therefore, the second branch is executed, but the result of the addition is stored into the result variable. Overflow will still occur as result is a 16-bit integer.

In simple terms, if you have an operation `v + b < v`, and `v` and `b` both have a type smaller than 32-bits, then the overflow check will never succeed.
</details>

We will begin by using CodeQL to identify relational comparison operations (`<`, `>`, `<=`, `>=`) that look like overflow checks. We will then refine this to identify only those checks which are likely wrong due to integer promotion.

If you follow the workshop all the way to the end, then you will find a real security in an old version of ChakraCore.

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on ChakraCore offline, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/#installing-the-extension). Full setup instructions are [here](https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/).
1. [Set up the starter workspace](https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/#setting-up-a-codeql-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download the [ChakraCore database](https://downloads.lgtm.com/snapshots/cpp/microsoft/chakracore/ChakraCore-revision-2017-April-12--18-13-26.zip).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `BadOverflowCheck.ql`, save it under `codeql-custom-queries-cpp`.

## Documentation links
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://codeql.github.com/docs/writing-codeql-queries/)
- [Learning CodeQL for C/C++](https://codeql.github.com/docs/codeql-language-guides/codeql-for-cpp/)
- [Using the CodeQL extension for VS Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/)

## Workshop
The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describe useful classes and predicates in the CodeQL standard libraries for C/C++. You can explore these in your IDE using the autocomplete suggestions and jump-to-definition command.

1. Find all relational comparison operations (i.e. `<`, `>`, `<=` and `>=`) in the program.
    <details>
    <summary>Hint</summary>

    Relational comparison are represented by the `RelationalOperation` class in the CodeQL C++ library.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    from RelationalOperation cmp
    select cmp
    ```
    </details>

1. Identify relational comparison operations which have an add expression (`+`) as one of the "operands" (arguments).
    <details>
    <summary>Hint</summary>

     - A `+` is represented by the class `AddExpr`
     - `RelationalOperation` has a predicate `getAnOperand()` for getting the operands of the operation.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    from AddExpr a, RelationalOperation cmp
    where
      cmp.getAnOperand() = a
    select cmp, a
    ```
    </details>

1. Filter your results to find only cases where there is a variable which is accessed both as an operand of the add expression and the relational operation. For example, the variable `v` in `v + b < v`.
    <details>
    <summary>Hint</summary>

     - The class `Variable` represents variables in the program.
     - `Variable.getAnAccess()` to get an access of the variable.
     - `AddExpr.getAnOperand()` to get an operand of a `+`.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    from AddExpr a, Variable v, RelationalOperation cmp
    where
      cmp.getAnOperand() = a and
      cmp.getAnOperand() = v.getAnAccess() and
      a.getAnOperand() = v.getAnAccess()
    select cmp, "Overflow check"
    ```
    </details>

1. The results identified in the previous step are likely to be overflow checks. However, we only want to find "bad" overflow checks. As a reminder, a bad overflow check is one where the type of both of the arguments of the addition (`v + b`) have a type smaller than 32-bits. Write a helper _predicate_ `isSmall` to identify expressions in the program which have a type smaller than 32-bits (4 bytes).
    <details>
    <summary>Hint</summary>

     - The class `Expr`, and the predicate `Expr.getType()` to get the type of each expression.
     - The class `Type` and the predicate `Type.getSize()` to get the size of that type.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    predicate isSmall(Expr e) {
      e.getType().getSize() < 4
    }
    ```
    </details>

1. Refine the query to identify only the additions where both the operands are small, using the `isSmall` predicate you previously wrote.
    <details>
    <summary>Hint</summary>

     * Simple approach: `AddExpr.getLeftOperand()`, `AddExpr.getRightOperand()`
     * Advanced approach: `forall`, `AddExpr.getAnOperand()`
    </details>
    <details>
    <summary>Solution</summary>
    
    The simplest approach is to add two conditions, one for each operand of the add expression.
    ```ql
    from AddExpr a, Variable v, RelationalOperation cmp
    where
      cmp.getAnOperand() = a and
      cmp.getAnOperand() = v.getAnAccess() and
      a.getAnOperand() = v.getAnAccess() and
      isSmall(a.getLeftOperand()) and
      isSmall(a.getRightOperand())
    select cmp, "Overflow check"
    ```
    This works, but it does require us to refer to `isSmall` twice. Wouldn't it be nice if we could specify the _both operands_ aspect without needing the duplication? Well, we can! QL provides a `forall` _quantifier_. This is specified in three parts:
     * one or more variable declarations
     * a "range", that describes some conditions on the variables
     * a formula that must hold for every value in the range

    For example, we can use this to specify the "both operands are small" condition by saying `forall(Expr op | op = a.getAnOperand() | isSmall(op))`.
    </details>

1. Review the results. You should notice that some include an explicit cast of the result of the addition to `(USHORT)`. This makes these conversions "safe", as it will force them to overflow. Update the query to take account of these "explicit" conversions.
    <details>
    <summary>Hint</summary>

    `Expr.getExplicitlyConverted()`
    </details>
    <details>
    <summary>Solution</summary>
    
    ```ql
    from AddExpr a, Variable v, RelationalOperation cmp
    where
      cmp.getAnOperand() = a and
      cmp.getAnOperand() = v.getAnAccess() and
      a.getAnOperand() = v.getAnAccess() and
      forall(Expr op | op = a.getAnOperand() | isSmall(op)) and
      not isSmall(a.getExplicitlyConverted())
    select cmp, "Overflow check"
    ```
    </details>

You should now have exactly one result, which was a [genuine security bug](https://github.com/Microsoft/ChakraCore/commit/2500e1cdc12cb35af73d5c8c9b85656aba6bab4d) in ChakraCore.
