---
category: feature
---
* Added a `SimpleTypeSanitizer` class to the new `semmle.python.security.Sanitizers` module. It
  identifies values of a type that cannot carry an injection payload, such as numbers, UUIDs,
  dates, and enum members, either as the result of a conversion or as a routed parameter whose
  type annotation a web framework validates. This is the Python counterpart of the simple-type
  sanitizers used by the Java and C# queries.
