---
category: feature
---
* Added a new predicate `DataFlow::getARuntimeTarget` for getting a function that may be invoked by a `Call` expression. Unlike `Call.getTarget` this new predicate may also resolve function pointers.