# Improvements to C# analysis

The following changes in version 1.24 affect C# analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Assembly path injection (`cs/assembly-path-injection`) | security, external/cwe/cwe-114 | Finds user-controlled data used to load an assembly. |
| Insecure configuration for ASP.NET requestValidationMode (`cs/insecure-request-validation-mode`) | security, external/cwe/cwe-016 | Finds where this attribute has been set to a value less than 4.5, which turns off some validation features and makes the application less secure. |
| Insecure SQL connection (`cs/insecure-sql-connection`) | security, external/cwe/cwe-327 | Finds unencrypted SQL connection strings. |
| Page request validation is disabled (`cs/web/request-validation-disabled`) | security, frameworks/asp.net, external/cwe/cwe-016 | Finds where ASP.NET page request validation has been disabled, which could make the application less secure. |
| Serialization check bypass (`cs/serialization-check-bypass`) | security, external/cwe/cwe-20 | Finds where data is not validated in a deserialization method. |
| XML injection (`cs/xml-injection`) | security, external/cwe/cwe-091 | Finds user-controlled data that is used to write directly to an XML document. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Useless assignment to local variable (`cs/useless-assignment-to-local`) | Fewer false positive results | Results have been removed when the variable is named `_` in a `foreach` statement. | 
| Dereferenced variable may be null (`cs/dereferenced-value-may-be-null`) | More results | Results are reported from parameters with a default value of `null`. |

## Removal of old queries

## Changes to code extraction

* Tuple expressions, for example `(int,bool)` in `default((int,bool))` are now extracted correctly.
* Expression nullability flow state is extracted. 

## Changes to libraries

* The data-flow library has been improved when flow through methods needs to be
  combined with both taint tracking and flow through fields allowing more flow
  to be tracked. This affects and improves most security queries, which may
  report additional results.
* The taint tracking library now tracks flow through (implicit or explicit) conversion operator calls.
* [Code contracts](https://docs.microsoft.com/en-us/dotnet/framework/debug-trace-profile/code-contracts) are now recognized, and are treated like any other assertion methods.
* Expression nullability flow state is given by the predicates `Expr.hasNotNullFlowState()` and `Expr.hasMaybeNullFlowState()`.

## Changes to autobuilder
