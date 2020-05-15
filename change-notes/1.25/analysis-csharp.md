# Improvements to C# analysis

The following changes in version 1.25 affect C# analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|


## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|


## Removal of old queries

## Changes to code extraction

* Index initializers, of the form `{ [1] = "one" }`, are extracted correctly. Previously, the kind of the
  expression was incorrect, and the index was not extracted.

## Changes to libraries

* The class `UnboundGeneric` has been refined to only be those declarations that actually
  have type parameters. This means that non-generic nested types inside constructed types,
  such as `A<int>.B`, no longer are considered unbound generics. (Such nested types do,
  however, still have relevant `.getSourceDeclaration()`s, for example `A<>.B`.)

## Changes to autobuilder
