# Improvements to C# analysis

The following changes in version 1.26 affect C# analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|


## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Weak encryption: Insufficient key size (`cs/insufficient-key-size`) | More results | The required key size has been increased from 1024 to 2048. |

## Removal of old queries

## Changes to code extraction

* Partial method bodies are extracted. Previously, partial method bodies were skipped completely.
* Inferring the lengths of implicitely sized arrays is fixed. Previously, multidimensional arrays were always extracted with the same length for
each dimension. With the fix, the array sizes `2` and `1` are extracted for `new int[,]{{1},{2}}`. Previously `2` and `2` were extracted.
* The extractor is now assembly-insensitive by default. This means that two entities with the same
  fully-qualified name are now mapped to the same entity in the resulting database, regardless of
  whether they belong to different assemblies. Assembly sensitivity can be reenabled by passing
  `--assemblysensitivetrap` to the extractor.

## Changes to libraries

## Changes to autobuilder

## Changes to tooling support

* The Abstract Syntax Tree of C# files can be printed in Visual Studio Code.
