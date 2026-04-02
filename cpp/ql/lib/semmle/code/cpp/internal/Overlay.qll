/**
 * Defines entity discard predicates for C++ overlay analysis.
 */

private import OverlayXml

/**
 * Holds always for the overlay variant and never for the base variant.
 */
overlay[local]
predicate isOverlay() { databaseMetadata("isOverlay", "true") }

/**
 * Holds if the TRAP file or tag `t` is reachable from source file `sourceFile`
 * in the base (isOverlayVariant=false) or overlay (isOverlayVariant=true) variant.
 */
overlay[local]
private predicate locallyReachableTrapOrTag(
  boolean isOverlayVariant, string sourceFile, @trap_or_tag t
) {
  exists(@source_file sf, @trap trap |
    (if isOverlay() then isOverlayVariant = true else isOverlayVariant = false) and
    source_file_uses_trap(sf, trap) and
    source_file_name(sf, sourceFile) and
    (t = trap or trap_uses_tag(trap, t))
  )
}

/**
 * Holds if element `e` is in TRAP file or tag `t`
 * in the base (isOverlayVariant=false) or overlay (isOverlayVariant=true) variant.
 */
overlay[local]
private predicate locallyInTrapOrTag(boolean isOverlayVariant, @element e, @trap_or_tag t) {
  (if isOverlay() then isOverlayVariant = true else isOverlayVariant = false) and
  in_trap_or_tag(e, t)
}

/**
 * Discards an element from the base variant if:
 * - We have knowledge about what TRAP file or tag it is in (in the base).
 * - It is not in any overlay TRAP file or tag that is reachable from an overlay source file.
 * - For every base TRAP file or tag that contains it and is reachable from a base source file,
 *   either the source file has changed, or the overlay has redefined the TRAP file or tag,
 *   or the overlay runner has re-extracted the same source file.
 */
overlay[discard_entity]
private predicate discardElement(@element e) {
  // If we don't have any knowledge about what TRAP file something
  // is in, then we don't want to discard it, so we only consider
  // entities that are known to be in a base TRAP file or tag.
  locallyInTrapOrTag(false, e, _) and
  // Anything that is reachable from an overlay source file should
  // not be discarded.
  not exists(@trap_or_tag t | locallyInTrapOrTag(true, e, t) |
    locallyReachableTrapOrTag(true, _, t)
  ) and
  // Finally, we have to make sure the base variant does not retain it.
  // If it is reachable from a base source file, then that is
  // sufficient unless either the base source file has changed (in
  // particular, been deleted), or the overlay has redefined the TRAP
  // file or tag it is in, or the overlay runner has re-extracted the same
  // source file (e.g. because a header it includes has changed).
  forall(@trap_or_tag t, string sourceFile |
    locallyInTrapOrTag(false, e, t) and
    locallyReachableTrapOrTag(false, sourceFile, t)
  |
    overlayChangedFiles(sourceFile) or
    locallyReachableTrapOrTag(true, _, t) or
    locallyReachableTrapOrTag(true, sourceFile, _)
  )
}
