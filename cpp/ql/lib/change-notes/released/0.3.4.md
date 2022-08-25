## 0.3.4

### Deprecated APIs

* Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* Added support for getting the link targets of global and namespace variables.
* Added a `BlockAssignExpr` class, which models a `memcpy`-like operation used in compiler generated copy/move constructors and assignment operations.

### Minor Analysis Improvements

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.
