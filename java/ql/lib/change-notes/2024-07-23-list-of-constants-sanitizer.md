---
category: minorAnalysis
---
* If a `java.util.List` is constructed using `List.of` to contain only compile-time constant strings, and a value is checked to belong in the list using `List.contains` then it is no longer considered tainted.
