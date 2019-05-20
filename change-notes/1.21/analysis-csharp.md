# Improvements to C# analysis

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Class defines a field that uses an ICryptoTransform class in a way that would be unsafe for concurrent threads (`cs/thread-unsafe-icryptotransform-field-in-class`) | Fewer false positive results | The criteria for a result has changed to include nested properties, nested fields and collections. The format of the alert message has changed to highlight the static field. |
| Constant condition (`cs/constant-condition`) | Fewer false positive results | Results have been removed where the `null` value is in a conditional expression on the left hand side of a null-coalescing expression. For example, in `(a ? b : null) ?? c`, `null` is not considered to be a constant condition. |

## Changes to code extraction

* The following C# 8 features are now extracted:
    - Range expressions
    - Recursive patterns

## Changes to QL libraries

* The class `Attribute` has two new predicates: `getConstructorArgument()` and `getNamedArgument()`. The first predicate returns arguments to the underlying constructor call and the latter returns named arguments for initializing fields and properties.
* The following QL classes have been added to model C# 8 features:
    - Class `IndexExpr` models from end index expressions, for example `^1`
    - Class `IsRecursivePatternExpr` models `is` recursive patterns, for example `s is string { Length: 0 }`
    - Class `PositionalPatternExpr` models position patterns, for example `(int x, int y)`
    - Class `PropertyPatternExpr` models property patterns, for example `Length: int len`
    - Class `RangeExpr` models range expressions, for example `1..^1`
    - Class `RecursivePatternCase` models `case` statements using recursive patterns, for example `case string { Length: 0 } x:`
    - Class `RecursivePatternExpr` models recursive patterns, for example `string { Length: 0 }`
    - Class `SwitchCaseExpr` models the arm of a switch expression, for example `(false, false) => true`
    - Class `SwitchExpr` models `switch` expressions, for example `(a, b) switch { ... }`

## Changes to autobuilder
