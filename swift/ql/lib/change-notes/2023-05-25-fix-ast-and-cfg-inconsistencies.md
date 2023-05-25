---
category: fix
---

* Fixed some AST printing inconsistencies leading to a non-tree AST. In particular:
    * `getOpaqueExpr()` is not considered a child of `OpenExistentialExpr` anymore, as it is
       actually a reference to an expression nested within `getSubExpr()`;
    * fixed some corner cases involving synthesized `PatternBindingDecl`s for variables wrapped with
      property wrappers.
* Fixed some control flow graph inconsistencies leading to multiple successors and dead ends.
  In particular:
    * fixed the corner cases mentioned above for AST printing, which were a problem also for the
      control graph;
    * fixed an inconsistency caused by an unneeded special treatment of `TapExpr`.
