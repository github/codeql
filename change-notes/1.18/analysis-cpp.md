# Improvements to C/C++ analysis

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Upcast array used in pointer arithmetic (`cpp/upcast-array-pointer-arithmetic`) | reliability, correctness, external/cwe/cwe-119 | Finds undefined behavior caused by doing pointer arithmetic on an array of objects that has been cast to an array of a supertype. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Assignment where comparison was intended (`cpp/assign-where-compare-meant`) | Fewer false positive results | Results are no longer reported if the variable is not yet defined. |
| Comparison where assignment was intended (`cpp/compare-where-assign-meant`) | More results | This query now includes results where an overloaded `operator==` is used in the wrong context. |
| For loop variable changed in body (`cpp/loop-variable-changed`)  | Fewer false positive results | Results where the loop variable is a member of a class or struct now account for the object. |
| Local variable hides global variable (`cpp/local-variable-hides-global-variable`) | Fewer false positive results | Results for parameters are now only reported if the name of the global variable is the same as the name of the parameter as used in the function definition (not just a function declaration). |
| Nested loops with same variable (`cpp/nested-loops-with-same-variable`) | Fewer false positive results | Results where the loop variable is a member of a class or struct now account for the object. |
| Self comparison (`cpp/comparison-of-identical-expressions`) | Fewer false positive results | Range checks of the form `x == (T)x` are no longer flagged unless they are guaranteed to have the same result on all platforms. |
| Too few arguments to formatting function (`cpp/wrong-number-format-arguments`) | More precise results | This was previously known as "Wrong number of arguments to formatting function". It now focuses only on functions calls that are missing arguments, which tend to be more severe. See the next row for the new query that reports lower-severity alerts for calls with too many arguments. In addition, both queries now understand positional format arguments as supported by some libraries, and some false positive results for custom printf-like functions have been fixed.|
| Too many arguments to formatting function (`cpp/too-many-format-arguments`) | More precise results | This new query was created by splitting the old "Wrong number of arguments to formatting function" query (see row above). It reports function calls with too many arguments.  |
| User-controlled data in arithmetic expression (`cpp/tainted-arithmetic`) | More results | The query is extended to analyze increment, decrement, addition-assignment, and subtraction-assignment operations. |
| Variable used in its own initializer (`cpp/use-in-own-initializer`) | Fewer false positive results | Results where a macro is used to indicate deliberate uninitialization are now excluded. |
|Uncontrolled data in arithmetic expression (`cpp/uncontrolled-arithmetic`) | More results | The query is extended to analyze increment, decrement, addition-assignment, and subtraction-assignment operations. |
 
## Changes to QL libraries

* The `ClassAggregateLiteral.getFieldExpr()` and `ArrayAggregateLiteral.getElementExpr()` predicates incorrectly assumed that initializer expressions appeared in the same order as the declaration order of the elements. This resulted in the association of the expressions with the wrong elements when designated initializers were used. This has been fixed.
* Results for the `Element.getEnclosingElement()` predicate no longer included macro accesses. To explore parents and children of macro accesses, use the relevant member predicates on `MacroAccess` or `MacroInvocation`.
