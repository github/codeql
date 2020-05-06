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

## Changes to libraries

* The class `UnboundGeneric` has been refined to only be those declarations that actually
  have type parameters. This means that non-generic nested types inside construced types,
  such as `A<int>.B`, no longer are considered unbound generics. (Such nested types do,
  however, still have relevant `.getSourceDeclaration()`s, for example `A<>.B`.)
* The data-flow library has been improved, which affects and improves most security queries. Flow
  through methods now takes nested field reads/writes into account. For example, the library is
  able to track flow from `"taint"` to `Sink()` via the method `GetF2F1()` in
  ```csharp
  class C1
  {
      string F1;
  }

  class C2
  {
      C1 F2;
  

      string GetF2F1() => this.F2.F1; // Nested field read

      void M()
      {
          this.F2 = new C1() { F1 = "taint" };
          Sink(this.GetF2F1()); // NEW: "taint" reaches here
      }
  }
  ```

## Changes to autobuilder
