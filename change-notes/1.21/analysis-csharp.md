# Improvements to C# analysis

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|


## Changes to code extraction

* Named attribute arguments are now extracted.

## Changes to QL libraries

* The class `Attribute` has two new predicates: `getConstructorArgument()` and `getNamedArgument()`. The first predicate returns arguments to the underlying constructor call and the latter returns named arguments for initializing fields and properties.

## Changes to autobuilder
