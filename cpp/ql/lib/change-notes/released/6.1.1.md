## 6.1.1

### Minor Analysis Improvements

* The class `DataFlow::FieldContent` now covers both `union` and `struct`/`class` types. A new predicate `FieldContent.getAField` has been added to access the union members associated with the `FieldContent`. The old `FieldContent` has been renamed to `NonUnionFieldContent`.
