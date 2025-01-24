---
category: breaking
---
* Added a basic block construction as part of the library. This is currently
  considered an internal unstable API. The input signature to the control flow
  graph now requires two additional predicates: `idOfAstNode` and
  `idOfCfgScope`.
