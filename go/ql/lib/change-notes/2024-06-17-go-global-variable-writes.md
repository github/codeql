---
category: fix
---
* Fixed dataflow via global variables other than via a direct write: for example, via a side-effect on a global, such as `io.copy(SomeGlobal, ...)` or via assignment to a field or array or slice cell of a global. This means that any data-flow query may return more results where global variables are involved.
