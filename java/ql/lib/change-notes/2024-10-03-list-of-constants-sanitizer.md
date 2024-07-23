---
category: minorAnalysis
---
* Calling `coll.contains(x)` is now a taint sanitizer (for any query) for the value `x`, where `coll` is a `java.util.List` or `java.util.Set` which was constructed in one of the below ways, which contains only constant elements, and which is either read from a final static field (in which case it must be immutable) or constructed locally.
  * `java.util.List.of(...)`
  * `java.util.Collections.unmodifiableList(java.util.Arrays.asList(...))`
  * `java.util.Set.of(...)`
  * `java.util.Collections.unmodifiableSet(new HashSet<>(java.util.Arrays.asList(list)))` where `list` is a list of constant elements
  * `var coll = new T(); coll.add(...); ...` where `T` is a class that implements `java.util.List` or `java.util.Set`.
  * `var coll = new T(coll2); coll.add(...); ...` where `T` is a class that implements `java.util.List` or `java.util.Set` and `coll2` is a list of constant elements.
