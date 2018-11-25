# Improvements to Java analysis

## General improvements

* Where applicable, path explanations have been added to the security queries.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Arbitrary file write during archive extraction ("Zip Slip") (`java/zipslip`) | security, external/cwe/cwe-022 | Identifies extraction routines that allow arbitrary file overwrite vulnerabilities. |
| Missing catch of NumberFormatException (`java/uncaught-number-format-exception`) | reliability, external/cwe/cwe-248 | Finds calls to `Integer.parseInt` and similar string-to-number conversions that might raise a `NumberFormatException` without a corresponding `catch`-clause. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Array index out of bounds (`java/index-out-of-bounds`) | Fewer false positive results | False positives involving arrays with a length evenly divisible by 3 or some greater number and an index being increased with a similar stride length are no longer reported. |
| Confusing overloading of methods (`java/confusing-method-signature`) | Fewer false positive results | A bugfix in the inheritance relation ensures that spurious results on certain generic classes no longer occur. |
| Query built from user-controlled sources (`java/sql-injection`) | More results | Sql injection sinks from the Spring JDBC, MyBatis, and Hibernate frameworks are now reported. |
| Query built without neutralizing special characters (`java/concatenated-sql-query`) | More results | Sql injection sinks from the Spring JDBC, MyBatis, and Hibernate frameworks are now reported. |
| Unreachable catch clause (`java/unreachable-catch-clause`) | Fewer false positive results | This rule now accounts for calls to generic methods that throw generic exceptions. |
| Useless comparison test (`java/constant-comparison`) | Fewer false positive results | Constant comparisons guarding `java.util.ConcurrentModificationException` are no longer reported, as they are intended to always be false in the absence of API misuse. |

## Changes to QL libraries

* The default set of taint sources in the `FlowSources` library is extended to
  cover parameters annotated with Spring framework annotations indicating
  remote user input from servlets. This affects all security queries, which
  will yield additional results on projects using the Spring Web framework.
* The `ParityAnalysis` library is replaced with the more general `ModulusAnalysis` library, which improves the range analysis.

