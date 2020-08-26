# Improvements to C# analysis

The following changes in version 1.26 affect C# analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|


## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|


## Removal of old queries

## Changes to code extraction

* Partial method bodies are extracted. Previously, partial method bodies were skipped completely.
* Inferring the lengths of implicitely sized arrays is fixed. Previously, multidimensional arrays were always extracted with the same length for
each dimension. With the fix, the array sizes `2` and `1` are extracted for `new int[,]{{1},{2}}`. Previously `2` and `2` were extracted.

## Changes to libraries

## Changes to autobuilder

## Changes to tooling support

* The Abstract Syntax Tree of C# files can be printed in Visual Studio Code.
