# Improvements to C# analysis

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dispose may not be called if an exception is thrown during execution (`cs/dispose-not-called-on-throw`) | Fewer false positive results | Results have been removed where an object is disposed both by a `using` statement and a `Dispose` call. |

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
