private import OverlayXml

/**
 * Holds always for the overlay variant and never for the base variant.
 */
overlay[local]
predicate isOverlay() { databaseMetadata("isOverlay", "true") }

/**
 * Holds if TRAP file or tag `t` is reachable from a source file named
 * `source_file` in the given variant (base or overlay).
 */
overlay[local]
private predicate locally_reachable_trap_or_tag(boolean is_overlay, string source_file, @trap_or_tag t) {
  exists(@source_file sf, string source_file_raw, @trap trap |
    (if isOverlay() then is_overlay = true else is_overlay = false) and
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
private predicate locally_in_trap_or_tag(boolean is_overlay, @element e, @trap_or_tag t) {
  (if isOverlay() then is_overlay = true else is_overlay = false) and
  in_trap_or_tag(e, t)
}

/**
 * Holds if element `e` from the base variant should be discarded because
 * it has been redefined or is no longer reachable in the overlay.
 */
overlay[discard_entity]
private predicate discard_element(@element e) {
  // If we don't have any knowledge about what TRAP file something
  // is in, then we don't want to discard it, so we only consider
  // entities that are known to be in a base TRAP file.
  locally_in_trap_or_tag(false, e, _) and
  // Anything that is reachable from an overlay source file should
  // not be discarded.
  not exists(@trap_or_tag t | locally_in_trap_or_tag(true, e, t) |
    locally_reachable_trap_or_tag(true, _, t)
  ) and
  // Finally, we have to make sure that base shouldn't retain it.
  // If it is reachable from a base source file, then that is
  // sufficient unless either the base source file has changed (in
  // particular, been deleted) or the overlay has redefined the TRAP
  // file it is in.
  forall(@trap_or_tag t, string source_file |
    locally_in_trap_or_tag(false, e, t) and
    locally_reachable_trap_or_tag(false, source_file, t)
  |
    overlayChangedFiles(source_file) or
    locally_reachable_trap_or_tag(true, _, t)
  )
}
