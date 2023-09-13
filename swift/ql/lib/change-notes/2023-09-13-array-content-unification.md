---
category: breaking
---

* The `ArrayContent` type in the data flow library has been removed and its uses have been replaced with the `CollectionContent` type, to better reflect the hierarchy of the Swift standard library. Uses of `ArrayElement` in model files will be interpreted as referring to `CollectionContent`.
