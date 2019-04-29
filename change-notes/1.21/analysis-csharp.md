# Improvements to C# analysis

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Class defines a field that uses an ICryptoTransform class in a way that would be unsafe for concurrent threads (`cs/thread-unsafe-icryptotransform-field-in-class`) | Fewer false positive results | The criteria for a result has changed to include nested properties, nested fields and collections. The format of the alert message has changed to highlight the static field. |
| Constant condition (`cs/constant-condition`) | Fewer false positive results | Results have been removed where the `null` value is in a conditional expression on the left hand side of a null-coalescing expression. For example, in `(a ? b : null) ?? c`, `null` is not considered to be a constant condition. |

## Changes to code extraction

* Named attribute arguments are now extracted.

## Changes to QL libraries

* The class `Attribute` has two new predicates: `getConstructorArgument()` and `getNamedArgument()`. The first predicate returns arguments to the underlying constructor call and the latter returns named arguments for initializing fields and properties.

## Changes to autobuilder
