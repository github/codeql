# Improvements to C/C++ analysis

## General improvements

> Changes that affect alerts in many files or from many queries
> For example, changes to file classification

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Upcast array used in pointer arithmetic | reliability, correctness, external/cwe/cwe-119 | Finds undefined behavior caused by doing pointer arithmetic on an array of objects that has been cast to an array of a supertype. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Self comparison | Fewer false positive results | Range checks of the form `x == (T)x` are no longer flagged unless they are guaranteed to have the same result on all platforms. |
| [Nested loops with same variable] | Fewer false positive results | Results where the loop variable is a member of a class or struct now account for the object. |
| [For loop variable changed in body] | Fewer false positive results | Results where the loop variable is a member of a class or struct now account for the object. |
| [Local variable hides global variable] | Fewer false positive results | Results for parameters are now only reported if the name of the global variable is the same as the name of the parameter as used in the function definition (not just a function declaration). |
| [Memory may not be freed] | More correct results | This query now models calls to `realloc` more accurately. |
| Wrong number of arguments to formatting function | Fewer false positive results | Some false positives related to custom printf-like functions have been fixed. |
| Wrong number of arguments to formatting function | Clear separation between results of high and low severity | This query has been split into two queries: a high-severity query named [Too few arguments to formatting function] and a low-severity query named [Too many arguments to formatting function]. |
| [Too few arguments to formatting function] | More correct and fewer false positives results | This query now understands positional format arguments as supported by some libraries. |
| [Too many arguments to formatting function] | More correct and fewer false positives results | This query now understands positional format arguments as supported by some libraries. |
| [Variable used in its own initializer] | Fewer false positive results | Results where a macro is used to indicate deliberate uninitialization are now excluded |
| [Assignment where comparison was intended] | Fewer false positive results | Results are no longer reported if the variable is not yet defined. |
| [Comparison where assignment was intended] | More correct results | "This query now includes results where an overloaded `operator==` is used in the wrong context. |
| [User-controlled data in arithmetic expression] | More correct results | Increment / decrement / addition assignment / subtraction assignment operations are now understood as arithmetic operations in this query. |
| [Uncontrolled data in arithmetic expression] | More correct results | Increment / decrement / addition assignment / subtraction assignment operations are now understood as arithmetic operations in this query. |
| [Use of extreme values in arithmetic expression] | More correct results | Increment / decrement / addition assignment / subtraction assignment operations are now understood as arithmetic operations in this query. |
| [Use of extreme values in arithmetic expression] | Fewer false positives | The query now considers whether a particular expression might cause an overflow of minimum or maximum values only. |

## Changes to QL libraries

* Fixes for aggregate initializers using designators:
  * `ClassAggregateLiteral.getFieldExpr()` previously assumed initializer expressions appeared in the same order as the declaration order of the fields, causing it to associate the expressions with the wrong fields when using designated initializers. This has been fixed.
  * `ArrayAggregateLiteral.getElementExpr()` previously assumed initializer expressions appeared in the same order as the corresponding array elements, causing it to associate the expressions with the wrong array elements when using designated initializers. This has been fixed.
* `Element.getEnclosingElement()` no longer includes macro accesses in its results. To explore parents and children of macro accesses, use the relevant member predicates on `MacroAccess` or `MacroInvocation`.
* Added a hash consing library for structural comparison of expressions.
