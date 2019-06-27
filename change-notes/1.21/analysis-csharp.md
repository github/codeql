# Improvements to C# analysis

## General improvements

C# analysis now supports the extraction and analysis of many C# 8 features. For details see [Changes to code extraction](#changes-to-code-extraction) and [Changes to QL libraries](#changes-to-ql-libraries) below.

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Thread-unsafe capturing of an ICryptoTransform object (`cs/thread-unsafe-icryptotransform-captured-in-lambda`) | concurrency, security, external/cwe/cwe-362 | Highlights instances of classes where a field of type `System.Security.Cryptography.ICryptoTransform` is captured by a lambda, and appears to be used in a thread initialization method. Results are not shown on [LGTM](https://lgtm.com/rules/1508141845995/) by default. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Constant condition (`cs/constant-condition`) | Fewer false positive results | The query now ignores code where the `null` value is in a conditional expression on the left hand side of a null-coalescing expression. For example, in `(a ? b : null) ?? c`, `null` is not considered to be a constant condition. |
| Thread-unsafe use of a static ICryptoTransform field (`cs/thread-unsafe-icryptotransform-field-in-class`) | Fewer false positive results | The criteria for a result has changed to include nested properties, nested fields, and collections. The format of the alert message has changed to highlight the static field. The query name has been updated. |
| Useless upcast (`cs/useless-upcast`) | Fewer false positive results | The query now ignores code where the upcast is used to disambiguate the target of a constructor call. |

## Changes to code extraction

* The following C# 8 features are now extracted:
    - Range expressions
    - Recursive patterns
    - Using declaration statements
    - `static` modifiers on local functions
    - Null-coalescing assignment expressions

* The `unmanaged` type parameter constraint is also now extracted.

## Changes to QL libraries

* The class `Attribute` has two new predicates: `getConstructorArgument()` and `getNamedArgument()`. The first predicate returns arguments to the underlying constructor call and the second returns named arguments for initializing fields and properties.
* The class `TypeParameterConstraints` has a new predicate `hasUnmanagedTypeConstraint()`. This shows whether the type parameter has the `unmanaged` constraint.
* The following QL classes have been added to model C# 8 features:
    - Class `AssignCoalesceExpr` models null-coalescing assignment, for example `x ??= y`
    - Class `IndexExpr` models from-end index expressions, for example `^1`
    - Class `PatternExpr` is an `Expr` that appears in a pattern. It has the new subclasses `DiscardPatternExpr`, `LabeledPatternExpr`, `RecursivePatternExpr`, `TypeAccessPatternExpr`, `TypePatternExpr`, and `VariablePatternExpr`.
    - Class `PatternMatch` models a pattern being matched. It has the subclasses `Case` and `IsExpr`.
    - Class `PositionalPatternExpr` models position patterns, for example `(int x, int y)`
    - Class `PropertyPatternExpr` models property patterns, for example `Length: int len`
    - Class `RangeExpr` models range expressions, for example `1..^1`
    - Class `SwitchCaseExpr` models the arm of a switch expression, for example `(false, false) => true`
    - Class `SwitchExpr` models `switch` expressions, for example `(a, b) switch { ... }`
    - Classes `IsConstantExpr`, `IsTypeExpr` and `IsPatternExpr` are deprecated in favour of `IsExpr`
    - Class `Switch` models both `SwitchExpr` and `SwitchStmt`
    - Class `Case` models both `CaseStmt` and `SwitchCaseExpr`
    - Class `UsingStmt` models both `UsingBlockStmt` and `UsingDeclStmt`
