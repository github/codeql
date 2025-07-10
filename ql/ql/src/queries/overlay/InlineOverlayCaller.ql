/**
 * @name Cannot inline predicate across overlay frontier
 * @description Local inline predicates that are not annotated with `overlay[caller]` are
 *              not inlined across the overlay frontier. This may negatively affect performance.
 * @kind problem
 * @problem.severity warning
 * @id ql/inline-overlay-caller
 * @tags performance
 * @precision high
 */

import ql

predicate mayBeLocal(AstNode n) {
  n.getAnAnnotation() instanceof OverlayLocal
  or
  n.getAnAnnotation() instanceof OverlayLocalQ
  or
  // The tree-sitter-ql grammar doesn't handle annotations on file-level
  // module declarations correctly. To work around that, we consider any
  // node in a file that contains an overlay[local] or overlay[local?]
  // annotation to be potentially local.
  exists(AstNode m |
    n.getLocation().getFile() = m.getLocation().getFile() and
    mayBeLocal(m)
  )
}

from Predicate p
where
  mayBeLocal(p) and
  p.getAnAnnotation() instanceof Inline and
  not p.getAnAnnotation() instanceof OverlayCaller and
  not p.isPrivate()
select p,
  "This possibly local non-private inline predicate will not " +
    "be inlined across the overlay frontier. This may negatively " +
    "affect evaluation performance. Consider adding an " +
    "`overlay[caller]` annotation to allow inlining across the " +
    "overlay frontier. Note that adding an `overlay[caller]` " +
    "annotation affects semantics under overlay evaluation."
