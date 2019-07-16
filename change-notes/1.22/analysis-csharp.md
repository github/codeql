# Improvements to C# analysis

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Added lines (`cs/vcs/added-lines-per-file`) | No results | Query has been removed. |
| Churned lines (`cs/vcs/churn-per-file`) | No results | Query has been removed. |
| Constant condition (`cs/constant-condition`) | Fewer false positive results | Results have been removed for default cases (`_`) in switch expressions. |
| Defect filter | No results | Query has been removed. |
| Defect from SVN | No results | Query has been removed. |
| Deleted lines (`cs/vcs/deleted-lines-per-file`) | No results | Query has been removed. |
| Dispose may not be called if an exception is thrown during execution (`cs/dispose-not-called-on-throw`) | Fewer false positive results | Results have been removed where an object is disposed both by a `using` statement and a `Dispose` call. |
| Files edited in pairs | No results | Query has been removed. |
| Filter: only files recently edited | No results | Query has been removed. |
| Large files currently edited | No results | Query has been removed. |
| Metric from SVN | No results | Query has been removed. |
| Number of authors (version control) (`cs/vcs/authors-per-file`) | No results | Query has been removed. |
| Number of file-level changes (`cs/vcs/commits-per-file`) | No results | Query has been removed. |
| Number of co-committed files (`cs/vcs/co-commits-per-file`) | No results | Query has been removed. |
| Number of file re-commits (`cs/vcs/recommits-per-file`) | No results | Query has been removed. |
| Number of recent file changes (`cs/vcs/recent-commits-per-file`) | No results | Query has been removed. |
| Number of authors | No results | Query has been removed. |
| Number of commits | No results | Query has been removed. |
| Poorly documented files with many authors | No results | Query has been removed. |
| Recent activity | No results | Query has been removed. |

## Changes to code extraction

* The following C# 8 features are now extracted:
  - Suppress-nullable-warning expressions, for example `x!`
  - Nullable reference types, for example `string?`

## Changes to QL libraries

* The new class `AnnotatedType` models types with type annotations, including nullability information, return kinds (`ref` and `readonly ref`), and parameter kinds (`in`, `out`, and `ref`)
  - The new predicate `Assignable.getAnnotatedType()` gets the annotated type of an assignable (such as a variable or a property)
  - The new predicates `Callable.getAnnotatedReturnType()` and `DelegateType.getAnnotatedReturnType()` get the annotated type of the return value
  - The new predicate `ArrayType.getAnnotatedElementType()` gets the annotated type of the array element
  - The new predicate `ConstructedGeneric.getAnnotatedTypeArgument()` gets the annotated type of a type argument
  - The new predicate `TypeParameterConstraints.getAnAnnotatedTypeConstraint()` gets a type constraint with type annotations
* The new class `SuppressNullableWarningExpr` models suppress-nullable-warning expressions such as `x!`

## Changes to autobuilder
