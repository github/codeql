# CodeQL workshop for C#: Unsafe pointer arithmetic in CoreFx

**Link to this document**: https://git.io/Jvjwh

- Analyzed language: C#
- Difficulty level: 2/3

## Problem statement

C# has unsafe code that is just as dangerous as unsafe code written in C or C++. In particular, it supports **pointers**, which are raw memory addresses that can point to data, and is susceptible to all of the vulnerabilities that involve writing to a pointer address without sufficient validation, such as buffer overflows.

If an attacker is able to control a memory address that is written to, or a **pointer arithmetic** operation that calculates a memory address, then they can potentially corrupt memory, overwrite parts of the program, or inject malicious code into the process.

In this workshop, we will look for vulnerabilities that involve untrusted data (that may be supplied by a plugin) being used in a pointer arithmetic operation without validation. This is inspired by [CVE-2016-0034](https://securelist.com/the-mysterious-case-of-cve-2016-0034-the-hunt-for-a-microsoft-silverlight-0-day/73255), which resulted in malicious Silverlight applications being able to hijack the browser. We will look for a similar vulnerability that was found and fixed in CoreFx (the .NET Core class libraries).

Consider the following C# code:

```cs
internal static unsafe void CopyTo(this Stream source, byte* destination, int size) {
  byte[] buffer = new byte[Math.Min(StreamCopyBufferSize, size)];
  while (size > 0) {
    int readSize = Math.Min(size, buffer.Length);
    int bytesRead = source.Read(buffer, 0, readSize);
    for (int i=0; i < bytesRead; ++i) {
      destination[i] = buffer[i];
    }
    destination += bytesRead;
    size -= bytesRead;
  }
}
```

This code attempts to read some bytes from a `Stream` named `source` into a buffer named `destination`. It uses an array named `buffer` as temporary storage to hold data from `source` that needs to be written into `destination`.

It uses `source.Read()` to read the stream in chunks, where each chunk is temporarily kept in `buffer` and can be up to `StreamCopyBufferSize` bytes long. It passes a `readSize` to `source.Read()` to indicate the number of bytes required for the current chunk.
`source.Read()` returns the number of bytes that were _actually read_ from the stream, which should be `0 <= bytesRead <= readSize`. In particular, `bytesRead` may be less than `readSize`, perhaps because `size > StreamCopyBufferSize` or fewer than `readSize` bytes were available in the stream. In that case, we go around the loop again, continuing to read chunks until we have read enough bytes from the stream.

Observe that this code places a great deal of trust into the result of `source.Read()`. It uses `bytesRead` to determine how much data to copy into `destination`:
```cs
int bytesRead = source.Read(buffer, 0, readSize);
...
for (int i=0; i < bytesRead; ++i) {
  destination[i] = buffer[i];
}
```
The problem is that the code expects `0 <= bytesRead <= readSize`, but does not actually check this!

The code also does not control which implementation of `Stream.Read()` gets used, because `Read()` is a **virtual method**. What happens if the method `Read` contains a bug, or is provided by a maliciously crafted plugin that writes outside of the buffer? Although plugins can be compiled to be safe, they can supply values to unsafe code to exploit it. We could have `bytesRead` > `readSize`, and then the code will carry on writing beyond the buffer. This is a classic buffer overflow attack, and allows the stream to potentially inject code.

We can fix this vulnerability by validating the size value returned by `source.Read()` before it is used to calculate the destination address.
```cs
if (bytesRead <= 0 || bytesRead > readSize)
{
  throw new IOException(SR.UnexpectedStreamEnd);
}
```

To summarize the problem, there is a potential security vulnerability when:
1. Untrusted data comes from a virtual method call (a **source**). This is code that the caller cannot control, and could come from a plugin.
1. The data is used in pointer arithmetic, which is then unsafe (a **sink**).
1. The data is not validated, for example by comparing it to an expected size limit (there is no **sanitizer**). In this workshop, we won't be able to check whether the validation is entirely correct, but we will be able to flag instances where there is no validation at all being performed.

In this challenge, we will use CodeQL to analyze the source code of CoreFx, taken from before these vulnerabilities were patched, and identify the vulnerabilities.

## Setup instructions

### Writing queries on your local machine

To run CodeQL queries on CoreFx offline, follow these steps:

1. Install the Visual Studio Code IDE.
1. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
1. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    - **Important**: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
    - **Enterprise customers**: Switch to the `1.23.1` branch to obtain query libraries compatible with your installation of LGTM Enterprise / GitHub Advanced Security.
1. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
1. Download [this CodeQL database built from the CoreFx
   code](https://downloads.lgtm.com/snapshots/csharp/microsoft/corefx-lite/corefx-lite.zip).
1. Unzip the database.
1. Import the unzipped database into Visual Studio Code:
    - Click the **CodeQL** icon in the left sidebar.
    - Place your mouse over **Databases**, and click the + sign that appears on the right.
    - Choose the unzipped database directory on your filesystem.
1. Create a new file, name it `UnsafePointerArithmetic.ql`, save it under `codeql-custom-queries-csharp`.
2. Run a simple test query:
   ```ql
   import csharp
   select 42
   ```
   
   When asked
   `Should the database .../corefx-lite-revision-2019-June-28--16-25-29 be upgraded?` 
   select `Yes`.

<!--
NOTE: This particular database is not on LGTM.com: it is a reduced version of the dotnet/corefx codebase.
### Writing queries in the browser
To run CodeQL queries on CoreFx online, follow these steps:
1. Create an account on LGTM.com if you haven't already. You can log in via OAuth using your Google or GitHub account.
1. [Start querying the CoreFx project](https://lgtm.com/query/project:1506081277237/lang:csharp/).
    - Alternative: Visit the [vulnerable CoreFx project page](https://lgtm.com/projects/g/dotnet/corefx) and click **Query this project**.
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
1. Untrusted data comes from a virtual method call (a **source**).
1. The data is used in pointer arithmetic, which is then unsafe (a **sink**).
1. The data is not validated, for example by comparing it to an expected size limit (there is no **sanitizer**).

### Finding pointer arithmetic operations that involve virtual calls

1. Find all arithmetic operations visible in the source code.
    
    <details>
    <summary>Hint</summary>
    
    A basic arithmetic operation is called an `ArithmeticOperation` in the CodeQL C# library.
    </details>
     <details>
    <summary>Solution</summary>
    
    ```codeql
    import csharp
    from ArithmeticOperation op
    select op
    ```
    
    </details>

1. Refine your query to find only arithmetic operations that work on pointers, for example:

    ```cs
    fixed (char* bufferPtr = _buffer)
    {
      char* p = bufferPtr + _startIndex;
      char* end = bufferPtr + _endIndex;
      ...
    }
    ```
    <details>
    <summary>Hint</summary>
    
    - Add a `where` clause to restrict the results of your query.
    - The predicate `getType()` will get the C# type of any expression (such as an arithmetic operation). 
    - `char*` is a "pointer type". These are represented by the class `PointerType`.
    - The keyword `instanceof` tests whether a given value is a member of a particular class.
    </details>
     <details>
    <summary>Solution</summary>
    
    ```codeql
    import csharp
    from ArithmeticOperation op
    where op.getType() instanceof PointerType
    select op
    ```
    </details>

1. Refine your query to find only pointer arithmetic operations where one of the operands is a call to a virtual method. This should give you one result.
    <details>
    <summary>Hint</summary>

    - `VirtualMethodCall`, `ArithmeticOperation.getAnOperand()`, `and`.
    - In CodeQL, you can use the `=` operator to assert that two values must be equal.
    </details>
    <details>
    <summary>Solution</summary>
    
    ```codeql
    import csharp
    from ArithmeticOperation op
    where
      op.getType() instanceof PointerType and
      op.getAnOperand() instanceof VirtualMethodCall
    select op
    ```
    
    Here is another way to write this, which will make the next task a little easier:
    ```codeql
    import csharp
    from ArithmeticOperation op, VirtualMethodCall virtualCall
    where
      op.getType() instanceof PointerType and
      op.getAnOperand() = virtualCall
    select op, virtualCall
    ```
    </details>
    
### Finding pointer arithmetic operations that use the result of virtual calls elsewhere in the same function

In the previous section, we found one result where one of the operands in a pointer arithmetic operation was the result of a virtual method call:
```cs
  bytes += (_encoding ?? s_UTF8Encoding).GetBytes(charsStart, (int)(chars - charsStart), bytes, (int)(bytesMax - bytes));
```
Notice that the pointer addition `+=` and the virtual method call `s_UTF8Encoding.GetBytes()` are in the same line of code. The virtual method call is directly used in the addition operation.

There are, however, additional vulnerabilities that are beyond the capabilities of a purely syntactic query such as the one we have written. For example, the virtual method call is not always used directly as an operand of the arithmetic operation: it might be assigned first to a local variable, which is then operated on.

The use of intermediate variables and nested expressions are typical source code examples that require use of **data flow analysis** to detect.

To find more variants of this vulnerability, we will adjust the query to use the C# local data flow library instead of relying purely on the syntactic structure of the vulnerability.

In terms of C#, this means that instead of limiting the query to `ArithmeticOperation`s and `VirtualMethodCall`s that appear together (such as in the following example) and link them using `getAnOperand()`,
``` cs
bytes += s_UTF8Encoding.GetBytes(...)
```

we search for `ArithmeticOperation`s and `VirtualMethodCall`s that may occur *separately*, and let the data flow library *connect* them for us. The local data flow library is able to work out whether the value of an expression at a certain point in the code eventually ends up at a different place within the same function.

Expand the hint to learn more on how to use the local data flow library, and modify your query to find arithmetic operations and virtual method calls where the value from the virtual call eventually ends up in an operand of the arithmetic operation.

This should give you one more result and solves the first two parts of our original problem:
1. Untrusted data comes from a virtual method call (a **source**)
2. The data is used in pointer arithmetic, which is then considered dangerous (a **sink**)

<details>
<summary>Hint</summary>

- The data flow library is in a module named `DataFlow`, already included by `import csharp`.
- **Data flow nodes** are places in the code that may have a value. They are described by the class `DataFlow::Node` in the CodeQL library.
- To get a data flow node from an expression `Expr e`, use `DataFlow::exprNode(e)`.
- To test the flow of information between data flow nodes `a` and `b`, use `DataFlow::localFlow(a, b)`. This tells us that when the program is run, the two nodes in the program will have the same value.

</details>
<details>
<summary>Solution</summary>
    
```codeql
import csharp
from ArithmeticOperation op, VirtualMethodCall virtualCall
where
    op.getType() instanceof PointerType and
    DataFlow::localFlow(DataFlow::exprNode(virtualCall), DataFlow::exprNode(op.getAnOperand()))
select virtualCall, op
```
</details>
    
### Finding guard conditions
Using local data flow analysis helped us find one more result in CoreFx: there is a virtual function call to `Read()` producing the value
```cs
int bytesRead = source.Read(buffer, 0, readSize);
```
which is later used in an arithmetic operation:
```cs
destination += bytesRead;
size -= bytesRead;
```

However, this new result is a false positive!  Before the arithmetic operation happens, the value of `bytesRead` is checked against the required size, so the pointer arithmetic is actually safe:

```cs
int bytesRead = source.Read(buffer, 0, readSize);

// guard condition: ensure bytesRead is valid
if (bytesRead <= 0 || bytesRead > readSize)
{
    throw new IOException(SR.UnexpectedStreamEnd);
}
... // pointer arithmetic happens after this.
    // Because 0 < bytesRead <= readSize, any use of `bytesRead` is guarded
```

This pattern is known as a **guard**: there is a condition that is checked at a certain place in the code, and is known to still hold at other places in the code.  Examples include a boolean expression that must be `true` or `false`, an expression that must be `null` (or non-`null`), or a `case` that must be matched or not matched.
    
The CodeQL library provides a single interface for working with these different cases in the [Guards](https://help.semmle.com/qldoc/csharp/semmle/code/csharp/controlflow/Guards.qll/module.Guards.html) module. 

Focusing on our current problem, our guard has the form:

```cs
if (bytesRead <= 0 || bytesRead > readSize) // this is a guard condition
{
  ...
  destination += bytesRead; // this use of `bytesRead` is guarded
  ...
}
```

Here the arithmetic expression `destination += bytesRead` is guarded by the comparisons (`<=` and `>`).

To start, find all expressions guarded by a comparison.

<details>
<summary>Hint</summary>

- An operation that compares two values is called a `ComparisonOperation`.  Look for one as your guard condition.

- To use the guards library, add this import statement to your query:
  ```codeql
  import semmle.code.csharp.controlflow.Guards
  ```

- Use the library's [GuardedExpr](https://help.semmle.com/qldoc/csharp/semmle/code/csharp/controlflow/Guards.qll/type.Guards$GuardedExpr.html) class to find all guarded expressions.

- If we have a `GuardedExpr`, we can call  [`isGuardedBy(condition, ...)`](https://help.semmle.com/qldoc/csharp/semmle/code/csharp/controlflow/Guards.qll/predicate.Guards$GuardedExpr$isGuardedBy.3.html) on it to identify the condition that guards it.

- To ignore predicate arguments, use `_` in place of a variable or value.

- The `isGuardedBy` predicate has three arguments, we only use the first for now.
    - The first argument is the whole guarding expression, `ComparisonOperation`
    - The second argument is the guarded subexpression, which we don't care about for now.  Use `_` in place of an argument name.
    - The third argument is the guard value, which we don't care about (use `_`).  We only check that a comparison operation exists at this point.


</details>

<details>
<summary>Solution</summary>

```cs
import csharp
import semmle.code.csharp.controlflow.Guards

from ComparisonOperation cmp, GuardedExpr guarded
where
    guarded.isGuardedBy(cmp, _, _)
select guarded
```
</details>

### Finding guard conditions that apply to pointer arithmetic
The previous query found **all** guard conditions. Now look for guard conditions that check the operands of pointer arithmetic operations.

In this workshop it is enough to look for a guard using comparison -- you don't need to check whether the guard condition is actually correct. Don't worry about data flow from virtual method calls for now.

<details>
<summary>Hint</summary>

- Recall the pointer arithmetic query:
    ```codeql
    import csharp
    from ArithmeticOperation op
    where op.getType() instanceof PointerType
    select op
    ```

- We want the pointer itself to be guarded. This is `op.getAnOperand()`, not the entire expression `op`.

- An `Expr` that is guarded by a condition can be cast to a `GuardedExpr`. You can do this in multiple ways:
  - an equality check, e.g. `e = guarded` where `e` is an `Expr` and `guarded` is a `GuardedExpr`.
  - a cast, e.g. `e.(GuardedExpr)`.

</details>

<details>
<summary>Solution</summary>

```cs
import csharp
import semmle.code.csharp.controlflow.Guards

from ComparisonOperation cmp, GuardedExpr guarded, ArithmeticOperation op
where
    op.getType() instanceof PointerType and
    guarded.isGuardedBy(cmp, _, _) and
    guarded = op.getAnOperand()
select guarded
```

</details>

### Identifying valid pointer arithmetic using guard conditions
You previously wrote a query to identify *all* flow of data from virtual method calls to arithmetic operations on pointers, and a query to identify all guarded pointer arithmetic operations. (Look at the Hint if you need a reminder!)

The third condition for a vulnerability in this situation is:

3. The size value is not validated.

Thus, pointer arithmetic operations are safe if their operands are guarded by a size check.

Combine your previous queries into a single query: identify the flow of data from virtual method calls to the operand of a pointer arithmetic operation where the operand in question is not guarded by a comparison.

Recall that in this workshop it is enough to look for a guard using comparison that checks the operand -- you don't need to check whether the guard condition is actually correct.

<details>
<summary>Hint</summary>
    
- Recall your query for the flow of data from virtual calls to pointer arithmetic:
    ```codeql
    import csharp

    from ArithmeticOperation op, VirtualMethodCall virtualCall
    where
        op.getType() instanceof PointerType and
        DataFlow::localFlow(DataFlow::exprNode(virtualCall), DataFlow::exprNode(op.getAnOperand()))
    select virtualCall, op
    ```
    
- Recall your query to identify guarded pointer arithmetic operations:
    ```codeql
    import csharp
    import semmle.code.csharp.controlflow.Guards

    from ComparisonOperation cmp, GuardedExpr guarded, ArithmeticOperation op
    where
        op.getType() instanceof PointerType and

        guarded.isGuardedBy(cmp, _, _) and
        guarded = op.getAnOperand()
    select guarded
    ```
- For a selected `operand = op.getAnOperand()`, we have to check that there is **no** `ComparisonOperation` guarding it; it is not sufficient to check that **a particular** comparison is not guarding it.  This requires the use of some more CodeQL features:
  - Use `not` in your query to assert a property that you do not want to be true.
  - Use `exists(Type varName | condition)` to declare temporary variables (like in the `from` clause) and assert that they satisfy some condition or property. 
  - Use `not exists` to assert that a certain property is **never** true.  E.g. `not exists(Color c| c.isRed())` asserts that there is **no** `Color` that is red.

</details>
<details>
<summary>Solution</summary>
    
```codeql
import csharp
import semmle.code.csharp.controlflow.Guards

from ArithmeticOperation op, VirtualMethodCall virtualCall, Expr operand
where
    op.getType() instanceof PointerType and
    operand = op.getAnOperand() and
    DataFlow::localFlow(DataFlow::exprNode(virtualCall), DataFlow::exprNode(operand)) and
    not exists(ComparisonOperation cmp, GuardedExpr guarded |
        guarded = operand and
        guarded.isGuardedBy(cmp, _, _)
    )
select virtualCall, op
```

Alternative, using casts:


```cs
import csharp
import semmle.code.csharp.controlflow.Guards

from ArithmeticOperation op, VirtualMethodCall virtualCall, Expr operand
where
    op.getType() instanceof PointerType and
    operand = op.getAnOperand() and
    DataFlow::localFlow(DataFlow::exprNode(virtualCall), DataFlow::exprNode(operand)) and
    not exists(ComparisonOperation cmp | operand.(GuardedExpr).isGuardedBy(cmp, _, _))
select virtualCall, op
```

</details>

## Acknowledgements

The initial version of this workshop was written by @calumgrant and developed further for presentation by @lcartey.  This tutorial version was written by @adityasharad and @hohn.