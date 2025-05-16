---
category: fix
---
* Fixed a problem where `asExpr()` on `DataFlow::Node` would never return `ArrayAggregateLiteral`s.