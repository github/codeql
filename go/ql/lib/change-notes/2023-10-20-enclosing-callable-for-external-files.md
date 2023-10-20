---
category: fix
---
* Fixed a bug where data flow nodes in files that are not in the project being analyzed (such as libraries) and are not contained within a function were not given an enclosing `Callable`. Note that for nodes that are not contained within a function, the enclosing callable is considered to be the file itself. This may cause some minor changes to results.
