---
category: fix
---
* Classes that define a `writeReplace` method are no longer flagged by the `java/missing-no-arg-constructor-on-serializable` query on the assumption they are unlikely to be deserialized using the default algorithm.
