---
category: fix
---
* Fixed a rare issue that would occur when a function declaration inside a block statement was referenced before it was declared.
  Such code is reliant on legacy web semantics, which is non-standard but nevertheless implemented by most engines.
  CodeQL now takes legacy web semantics into account and resolves references to these functions correctly.
