# Improvements to Java analysis

## General improvements

Path explanations have been added to the relevant security queries. 
Use [QL for Eclipse](https://help.semmle.com/ql-for-eclipse/Content/WebHelp/getting-started.html) 
to run queries and explore the data flow in results.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Arbitrary file write during archive extraction ("Zip Slip") (`java/zipslip`) | security, external/cwe/cwe-022 | Identifies extraction routines that allow arbitrary file overwrite vulnerabilities. Results are shown on LGTM by default. |
| Missing catch of NumberFormatException (`java/uncaught-number-format-exception`) | reliability, external/cwe/cwe-248 | Finds calls to `Integer.parseInt` and similar string-to-number conversions that might raise a `NumberFormatException` without a corresponding `catch`-clause. Results are hidden on LGTM by default. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Array index out of bounds (`java/index-out-of-bounds`) | Fewer false positive results | Results for arrays with a length evenly divisible by 3, or some greater number, and an index being increased with a similar stride length are no longer reported. |
| Confusing overloading of methods (`java/confusing-method-signature`) | Fewer false positive results | A correction to the inheritance relation ensures that spurious results on certain generic classes no longer occur. |
| Query built from user-controlled sources (`java/sql-injection`) | More results | SQL injection sinks from the Spring JDBC, MyBatis, and Hibernate frameworks are now reported. |
| Query built without neutralizing special characters (`java/concatenated-sql-query`) | More results | SQL injection sinks from the Spring JDBC, MyBatis, and Hibernate frameworks are now reported. |
| Unreachable catch clause (`java/unreachable-catch-clause`) | Fewer false positive results | Now accounts for calls to generic methods that throw generic exceptions. |
| Useless comparison test (`java/constant-comparison`) | Fewer false positive results | Constant comparisons guarding `java.util.ConcurrentModificationException` are no longer reported, as they are intended to always be false in the absence of API misuse. |

## Changes to QL libraries

* The class `ControlFlowNode` (and by extension `BasicBlock`) has until now
  been directly equatable to `Expr` and `Stmt`.  Exploiting these equalities,
  for example by using casts, is now deprecated, and the conversions
  `Expr.getControlFlowNode()` and `Stmt.getControlFlowNode()` should be used
  instead.
* The default set of taint sources in the `FlowSources` library is extended to
  cover parameters annotated with Spring framework annotations indicating
  remote user input from servlets. This affects all security queries, which
  will yield additional results on projects that use the Spring Web framework.
* The `ParityAnalysis` library is replaced with the more general `ModulusAnalysis` library, which improves the range analysis.

