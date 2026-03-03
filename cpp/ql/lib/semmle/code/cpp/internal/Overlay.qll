/**
 * Defines entity discard predicates for C++ overlay analysis.
 *
 * The discard strategy is based on TRAP file and tag tracking rather than
 * source locations. The extractor records which TRAP file or tag each element
 * is defined in (`in_trap_or_tag`), which source files use which TRAP files
 * (`source_file_uses_trap`), and which TRAP files use which tags
 * (`trap_uses_tag`). These relations allow us to precisely determine whether
 * a base element should be discarded or retained in the combined database.
 */

private import OverlayXml

/**
 * Holds always for the overlay variant and never for the base variant.
 * This local predicate is used to define local predicates that behave
 * differently for the base and overlay variant.
 */
overlay[local]
predicate isOverlay() { databaseMetadata("isOverlay", "true") }

/**
 * Holds if TRAP file or tag `t` is reachable from a source file named
 * `source_file` in the given variant (base or overlay).
 *
 * A TRAP file is directly reachable from its source file. A tag is reachable
 * if the TRAP file that uses it is reachable.
 */
overlay[local]
private predicate locallyReachableTrapOrTag(
  boolean isOverlayVariant, string source_file, @trap_or_tag t
) {
  exists(@source_file sf, string source_file_raw, @trap trap |
    (if isOverlay() then isOverlayVariant = true else isOverlayVariant = false) and
    source_file_uses_trap(sf, trap) and
    source_file_name(sf, source_file_raw) and
    source_file = source_file_raw.replaceAll("\\", "/") and
    (t = trap or trap_uses_tag(trap, t))
  )
}

/**
 * Holds if element `e` is defined in TRAP file or tag `t` in the given
 * variant (base or overlay).
 */
overlay[local]
private predicate locallyInTrapOrTag(boolean isOverlayVariant, @element e, @trap_or_tag t) {
  (if isOverlay() then isOverlayVariant = true else isOverlayVariant = false) and
  in_trap_or_tag(e, t)
}

/**
 * Discards an element from the base variant if:
 * - It is known to be in a base TRAP file or tag, and
 * - It is not reachable from any overlay source file, and
 * - Every base source file that reaches it has either changed or had its TRAP
 *   file redefined by the overlay.
 */
overlay[discard_entity]
private predicate discardElement(@element e) {
  // If we don't have any knowledge about what TRAP file something
  // is in, then we don't want to discard it, so we only consider
  // entities that are known to be in a base TRAP file.
  locallyInTrapOrTag(false, e, _) and
  // Anything that is reachable from an overlay source file should
  // not be discarded.
  not exists(@trap_or_tag t | locallyInTrapOrTag(true, e, t) |
    locallyReachableTrapOrTag(true, _, t)
  ) and
  // Finally, we have to make sure that base shouldn't retain it.
  // If it is reachable from a base source file, then that is
  // sufficient unless either the base source file has changed (in
  // particular, been deleted) or the overlay has redefined the TRAP
  // file it is in.
  forall(@trap_or_tag t, string source_file |
    locallyInTrapOrTag(false, e, t) and
    locallyReachableTrapOrTag(false, source_file, t)
  |
    overlayChangedFiles(source_file) or
    locallyReachableTrapOrTag(true, _, t)
  )
}
