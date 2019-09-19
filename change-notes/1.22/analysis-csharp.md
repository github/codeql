# Improvements to C# analysis

The following changes in version 1.22 affect C# analysis in all applications.

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Constant condition (`cs/constant-condition`) | Fewer false positive results | Results have been removed for default cases (`_`) in switch expressions. |
| Dispose may not be called if an exception is thrown during execution (`cs/dispose-not-called-on-throw`) | Fewer false positive results | Results have been removed where an object is disposed both by a `using` statement and a `Dispose` call. |
| Unchecked return value (`cs/unchecked-return-value`) | Fewer false positive results | Method calls that are expression bodies of `void` callables (for example, the call to `Foo` in `void Bar() => Foo()`) are no longer considered to use the return value. |

## Removal of old queries

The following historic queries are no longer available in the distribution:

* Added lines (`cs/vcs/added-lines-per-file`)
* Churned lines (`cs/vcs/churn-per-file`)
* Defect filter
* Defect from SVN
* Deleted lines (`cs/vcs/deleted-lines-per-file`)
* Files edited in pairs
* Filter: only files recently edited
* Large files currently edited
* Metric from SVN
* Number of authors (version control) (`cs/vcs/authors-per-file`)
* Number of file-level changes (`cs/vcs/commits-per-file`)
* Number of co-committed files (`cs/vcs/co-commits-per-file`)
* Number of file re-commits (`cs/vcs/recommits-per-file`)
* Number of recent file changes (`cs/vcs/recent-commits-per-file`)
* Number of authors
* Number of commits
* Poorly documented files with many authors
* Recent activity

## Changes to code extraction

* The following C# 8 features are now extracted:
  - Suppress-nullable-warning expressions, for example `x!`
  - Nullable reference types, for example `string?`

## Changes to QL libraries

* The new class `AnnotatedType` models types with type annotations, including nullability information, return kinds (`ref` and `readonly ref`), and parameter kinds (`in`, `out`, and `ref`).
  - The new predicate `Assignable.getAnnotatedType()` gets the annotated type of an assignable (such as a variable or a property).
  - The new predicates `Callable.getAnnotatedReturnType()` and `DelegateType.getAnnotatedReturnType()` gets the annotated type of the return value.
  - The new predicate `ArrayType.getAnnotatedElementType()` gets the annotated type of the array element.
  - The new predicate `ConstructedGeneric.getAnnotatedTypeArgument()` gets the annotated type of a type argument.
  - The new predicate `TypeParameterConstraints.getAnAnnotatedTypeConstraint()` gets a type constraint with type annotations.
* The new class `SuppressNullableWarningExpr` models suppress-nullable-warning expressions such as `x!`.
* The data-flow and taint-tracking libraries now support flow through fields. All existing configurations will have field-flow enabled by default, but it can be disabled by adding `override int fieldFlowBranchLimit() { result = 0 }` to the configuration class. Field assignments, `this.Foo = x`, object initializers, `new C() { Foo = x }`, and field initializers `int Foo = 0` are supported.
* The possibility of specifying barrier edges using
  `isBarrierEdge`/`isSanitizerEdge` in data-flow and taint-tracking
  configurations has been replaced with the option of specifying in- and
  out-barriers on nodes by overriding `isBarrierIn`/`isSanitizerIn` and
  `isBarrierOut`/`isSanitizerOut`. This should be simpler to use effectively,
  as it does not require knowledge about the actual edges used internally by
  the library.
