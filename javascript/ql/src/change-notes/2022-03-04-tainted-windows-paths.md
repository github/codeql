---
category: newQuery
---
* Added the query `js/path-injection-win32-enabled` which tracks possible
  injections of paths. Its behaviour is comparable to the standard query 
  `js/path-injection`, but it is aware of pitfalls that only apply on
  windows (eg., that some libraries for working with paths recognize both
  forward and backward slashes as path separators).