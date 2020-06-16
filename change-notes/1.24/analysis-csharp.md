# Improvements to C# analysis

The following changes in version 1.24 affect C# analysis in all applications.

## General improvements

You can now suppress alerts using either single-line block comments (`/* ... */`) or line comments (`// ...`).

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Assembly path injection (`cs/assembly-path-injection`) | security, external/cwe/cwe-114 | Finds user-controlled data used to load an assembly. Results are shown on LGTM by default. |
| Insecure configuration for ASP.NET requestValidationMode (`cs/insecure-request-validation-mode`) | security, external/cwe/cwe-016 | Finds where this attribute has been set to a value less than 4.5, which turns off some validation features and makes the application less secure. By default, the query is not run on LGTM. |
| Insecure SQL connection (`cs/insecure-sql-connection`) | security, external/cwe/cwe-327 | Finds unencrypted SQL connection strings. Results are not shown on LGTM by default. |
| Page request validation is disabled (`cs/web/request-validation-disabled`) | security, frameworks/asp.net, external/cwe/cwe-016 | Finds where ASP.NET page request validation has been disabled, which could make the application less secure. By default, the query is not run on LGTM. |
| Serialization check bypass (`cs/serialization-check-bypass`) | security, external/cwe/cwe-20 | Finds where data is not validated in a deserialization method. Results are not shown on LGTM by default. |
| XML injection (`cs/xml-injection`) | security, external/cwe/cwe-091 | Finds user-controlled data that is used to write directly to an XML document. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable may be null (`cs/dereferenced-value-may-be-null`) | More results | Results are reported from parameters with a default value of `null`. |
| Information exposure through an exception (`cs/information-exposure-through-exception`) | More results | The query now recognizes writes to cookies, writes to ASP.NET (`Inner`)`Text` properties, and email contents as additional sinks. |
| Information exposure through transmitted data (`cs/sensitive-data-transmission`) | More results | The query now recognizes writes to cookies and writes to ASP.NET (`Inner`)`Text` properties as additional sinks. |
| Potentially dangerous use of non-short-circuit logic (`cs/non-short-circuit`) | Fewer false positive results | Results have been removed when the expression contains an `out` parameter. |
| Useless assignment to local variable (`cs/useless-assignment-to-local`) | Fewer false positive results | Results have been removed when the value assigned is an (implicitly or explicitly) cast default-like value. For example, `var s = (string)null` and `string s = default`. Results have also been removed when the variable is named `_` in a `foreach` statement. | 
| XPath injection (`cs/xml/xpath-injection`) | More results | The query now recognizes calls to methods on `System.Xml.XPath.XPathNavigator` objects. |

## Changes to code extraction

* Tuple expressions, for example `(int,bool)` in `default((int,bool))` are now extracted correctly.
* Expression nullability flow state is extracted.
* Implicitly typed `stackalloc` expressions are now extracted correctly.
* The difference between `stackalloc` array creations and normal array creations is extracted.

## Changes to libraries

* The data-flow library has been improved, which affects and improves most security queries. The improvements are:
    - Track flow through methods that combine taint tracking with flow through fields.
    - Track flow through clone-like methods, that is, methods that read the contents of a field from a
      parameter and store the value in the field of a returned object.
* The taint tracking library now tracks flow through (implicit or explicit) conversion operator calls.
* [Code contracts](https://docs.microsoft.com/en-us/dotnet/framework/debug-trace-profile/code-contracts) are now recognized, and are treated like any other assertion methods.
* Expression nullability flow state is given by the predicates `Expr.hasNotNullFlowState()` and `Expr.hasMaybeNullFlowState()`.
* `stackalloc` array creations are now represented by the QL class `Stackalloc`. Previously they were represented by the class `ArrayCreation`.
* A new class `RemoteFlowSink` has been added to model sinks where data might be exposed to external users. Examples include web page output, emails, and cookies.
