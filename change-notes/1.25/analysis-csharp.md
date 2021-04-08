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
* The data-flow library has been improved, which affects most security queries by potentially
  adding more results:
  - Flow through methods now takes nested field reads/writes into account.
    For example, the library is able to track flow from `"taint"` to `Sink()` via the method
    `GetF2F1()` in
    ```csharp
    class C1
    {
        string F1;
    }

    class C2
    {
        C1 F2;

        string GetF2F1() => F2.F1; // Nested field read

        void M()
        {
            F2 = new C1() { F1 = "taint" };
            Sink(GetF2F1()); // NEW: "taint" reaches here
        }
    }
    ```
  - Flow through collections is now modeled precisely. For example, instead of modeling an array
    store `a[i] = x` as a taint-step from `x` to `a`, we now model it as a data-flow step that
    stores `x` into `a`. To get the value back out, a matching read step must be taken.

    For source-code based data-flow analysis, the following constructs are modeled as stores into
    collections:
    - Direct array assignments, `a[i] = x`.
    - Array initializers, `new [] { x }`.
    - C# 6-style array initializers, `new C() { Array = { [i] = x } }`.
    - Call arguments that match a `params` parameter, where the C# compiler creates an array under-the-hood.
    - `yield return` statements.

    The following source-code constructs read from a collection:
    - Direct array reads, `a[i]`.
    - `foreach` statements.

    For calls out to library code, existing flow summaries have been refined to precisely
    capture how they interact with collection contents. For example, a call to
    `System.Collections.Generic.List<T>.Add(T)` stores the value of the argument into the
    qualifier, and a call to `System.Collections.Generic.List<T>.get_Item(int)` (that is, an
    indexer call) reads contents out of the qualifier. Moreover, the effect of
    collection-clearing methods such as `System.Collections.Generic.List<T>.Clear()` is now
    also modeled.

## Changes to autobuilder
