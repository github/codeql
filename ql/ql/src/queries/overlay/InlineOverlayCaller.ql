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

private predicate isDirectlyLocal(AstNode n) {
  n.getAnAnnotation() instanceof OverlayLocal
  or
  n.getAnAnnotation() instanceof OverlayLocalQ
}

predicate mayBeLocal(AstNode n) {
  isDirectlyLocal(n)
  or
  // File-level module annotations belong to an anonymous `Module` sibling of
  // the file's declarations, so consider every node in that file potentially local.
  exists(AstNode m |
    n.getLocation().getFile() = m.getLocation().getFile() and
    isDirectlyLocal(m)
  )
}

from Predicate p
where
  mayBeLocal(p) and
  p.getAnAnnotation() instanceof Inline and
  not p.getAnAnnotation() instanceof OverlayCaller and
  not p.getAnAnnotation() instanceof OverlayCallerQ and
  not p.isPrivate()
select p,
  "This possibly local non-private inline predicate will not " +
    "be inlined across the overlay frontier. This may negatively " +
    "affect evaluation performance. Consider adding an " +
    "`overlay[caller]` or `overlay[caller?]` annotation to allow inlining across the " +
    "overlay frontier. Note that adding an `overlay[caller]` or `overlay[caller?]` " +
    "annotation affects semantics under overlay evaluation."
